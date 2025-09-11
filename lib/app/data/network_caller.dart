import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kario_wellness_watch/app/data/api_constants.dart';

/// Custom exception for network-related errors
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'NetworkException: $message';
}

/// HTTP methods enum
enum HttpMethod { get, post, put, patch, delete, multipart }

/// Multipart file wrapper
class MultipartFile {
  final String field;
  final String filename;
  final List<int> bytes;
  final String? contentType;

  MultipartFile({
    required this.field,
    required this.filename,
    required this.bytes,
    this.contentType,
  });

  /// Create from File
  static Future<MultipartFile> fromFile({
    required String field,
    required File file,
    String? filename,
    String? contentType,
  }) async {
    final bytes = await file.readAsBytes();
    return MultipartFile(
      field: field,
      filename: filename ?? file.path.split('/').last,
      bytes: bytes,
      contentType: contentType,
    );
  }

  /// Create from bytes
  static MultipartFile fromBytes({
    required String field,
    required String filename,
    required List<int> bytes,
    String? contentType,
  }) {
    return MultipartFile(
      field: field,
      filename: filename,
      bytes: bytes,
      contentType: contentType,
    );
  }
}

/// Network response wrapper
class NetworkResponse<T> {
  final T? data;
  final int statusCode;
  final String? message;
  final bool isSuccess;
  final Map<String, String>? headers;

  NetworkResponse({
    this.data,
    required this.statusCode,
    this.message,
    required this.isSuccess,
    this.headers,
  });

  NetworkResponse.success({
    required this.data,
    required this.statusCode,
    this.message,
    this.headers,
  }) : isSuccess = true;

  NetworkResponse.error({
    required this.statusCode,
    required this.message,
    this.data,
    this.headers,
  }) : isSuccess = false;
}

/// Request interceptor interface
abstract class RequestInterceptor {
  Future<Map<String, String>> interceptHeaders(Map<String, String> headers);
}

/// Response interceptor interface
abstract class ResponseInterceptor {
  Future<http.Response> interceptResponse(http.Response response);
}

/// Auth interceptor implementation
class AuthInterceptor implements RequestInterceptor {
  final String token;
  final String tokenType;

  AuthInterceptor({required this.token, this.tokenType = 'Bearer'});

  @override
  Future<Map<String, String>> interceptHeaders(
    Map<String, String> headers,
  ) async {
    headers['Authorization'] = '$tokenType $token';
    return headers;
  }
}

/// Content-Type interceptor
class ContentTypeInterceptor implements RequestInterceptor {
  final String contentType;

  ContentTypeInterceptor({this.contentType = 'application/json'});

  @override
  Future<Map<String, String>> interceptHeaders(
    Map<String, String> headers,
  ) async {
    headers['Content-Type'] = contentType;
    return headers;
  }
}

/// Logging interceptor for debugging
class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  final bool enabled;

  LoggingInterceptor({this.enabled = true});

  @override
  Future<Map<String, String>> interceptHeaders(
    Map<String, String> headers,
  ) async {
    if (enabled) {
      print('📤 Request Headers: $headers');
    }
    return headers;
  }

  @override
  Future<http.Response> interceptResponse(http.Response response) async {
    if (enabled) {
      print('📥 Response [${response.statusCode}]: ${response.body}');
    }
    return response;
  }
}

/// Main NetworkCaller class
class NetworkCaller {
  static NetworkCaller? _instance;

  static NetworkCaller get instance => _instance ??= NetworkCaller._internal();

  NetworkCaller._internal() {
    // Initialize base URL internally - configure your API base URL here
    _baseUrl = ApiConstants.baseUrl; // Set your API base URL here
    _baseUri = Uri.parse(_baseUrl!);
  }

  final http.Client _client = http.Client();
  String? _baseUrl;
  Uri? _baseUri;
  final Duration _defaultTimeout = const Duration(seconds: 30);
  final List<RequestInterceptor> _requestInterceptors = [];
  final List<ResponseInterceptor> _responseInterceptors = [];

  /// Update base URL if needed (optional method for environment switching)
  void updateBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _baseUri = Uri.parse(baseUrl);
  }

  /// Add request interceptor
  void addRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  /// Add response interceptor
  void addResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.add(interceptor);
  }

  /// Clear all interceptors
  void clearInterceptors() {
    _requestInterceptors.clear();
    _responseInterceptors.clear();
  }

  /// Generic HTTP request method
  Future<NetworkResponse<T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
    T Function(dynamic)? fromJson,
    // Multipart specific parameters
    List<MultipartFile>? files,
    Map<String, String>? fields,
  }) async {
    try {
      // Build URL
      final uri = _buildUri(endpoint, queryParameters);

      // Prepare headers
      final requestHeaders = await _prepareHeaders(headers ?? {});

      // Prepare request
      http.Response response;
      final timeoutDuration = timeout ?? _defaultTimeout;

      switch (method) {
        case HttpMethod.get:
          response = await _client
              .get(uri, headers: requestHeaders)
              .timeout(timeoutDuration);
          break;
        case HttpMethod.post:
          response = await _client
              .post(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              ).timeout(timeoutDuration);
          break;
        case HttpMethod.put:
          response = await _client
              .put(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case HttpMethod.patch:
          response = await _client
              .patch(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case HttpMethod.delete:
          response = await _client
              .delete(uri, headers: requestHeaders)
              .timeout(timeoutDuration);
          break;
        case HttpMethod.multipart:
          response = await _sendMultipartRequest(
            uri: uri,
            headers: requestHeaders,
            files: files,
            fields: fields,
            timeout: timeoutDuration,
          );
          break;
      }

      // Process response through interceptors
      for (final interceptor in _responseInterceptors) {
        response = await interceptor.interceptResponse(response);
      }

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}');
    } on FormatException {
      throw NetworkException('Invalid response format');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }

  /// GET request
  Future<NetworkResponse<T>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.get,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// POST request
  Future<NetworkResponse<T>> post<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.post,
      body: body,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// PUT request
  Future<NetworkResponse<T>> put<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.put,
      body: body,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// PATCH request
  Future<NetworkResponse<T>> patch<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.patch,
      body: body,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// DELETE request
  Future<NetworkResponse<T>> delete<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.delete,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// MULTIPART request for file uploads
  Future<NetworkResponse<T>> multipart<T>({
    required String endpoint,
    List<MultipartFile>? files,
    Map<String, String>? fields,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.multipart,
      files: files,
      fields: fields,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// Upload single file
  Future<NetworkResponse<T>> uploadFile<T>({
    required String endpoint,
    required MultipartFile file,
    Map<String, String>? fields,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return multipart<T>(
      endpoint: endpoint,
      files: [file],
      fields: fields,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// Upload multiple files
  Future<NetworkResponse<T>> uploadFiles<T>({
    required String endpoint,
    required List<MultipartFile> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
    Duration? timeout,
    T Function(dynamic)? fromJson,
  }) async {
    return multipart<T>(
      endpoint: endpoint,
      files: files,
      fields: fields,
      headers: headers,
      timeout: timeout,
      fromJson: fromJson,
    );
  }

  /// Send multipart request
  Future<http.Response> _sendMultipartRequest({
    required Uri uri,
    required Map<String, String> headers,
    List<MultipartFile>? files,
    Map<String, String>? fields,
    required Duration timeout,
  }) async {
    final request = http.MultipartRequest('POST', uri);

    // Add headers (remove content-type as it will be set automatically)
    final filteredHeaders = Map<String, String>.from(headers);
    filteredHeaders.remove('Content-Type');
    filteredHeaders.remove('content-type');
    request.headers.addAll(filteredHeaders);

    // Add fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Add files
    if (files != null) {
      for (final file in files) {
        request.files.add(
          http.MultipartFile.fromBytes(
            file.field,
            file.bytes,
            filename: file.filename,
            contentType:
                file.contentType != null
                    ? _parseMediaType(file.contentType!)
                    : null,
          ),
        );
      }
    }

    final streamedResponse = await request.send().timeout(timeout);
    return await http.Response.fromStream(streamedResponse);
  }

  /// Parse media type for multipart files
  _parseMediaType(String contentType) {
    try {
      final parts = contentType.split('/'); //=== need lookup mimetype
      if (parts.length == 2) {
        return MediaType(parts[0], parts[1]);
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }

  //Need to clear
  /// Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    late Uri uri;

    if (_baseUri != null) {
      // Use pre-parsed base URI for efficiency
      final path = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
      uri = _baseUri!.resolve(path);
    } else {
      // Handle absolute URLs or when no base URL is set
      uri = Uri.parse(endpoint);
    }

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParameters.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        },
      );
    }

    return uri;
  }

  /// Prepare headers with interceptors
  Future<Map<String, String>> _prepareHeaders(
    Map<String, String> headers,
  ) async {
    Map<String, String> processedHeaders = Map.from(headers);

    for (final interceptor in _requestInterceptors) {
      processedHeaders = await interceptor.interceptHeaders(processedHeaders);
    }

    return processedHeaders;
  }

  /// Handle response and parse data
  NetworkResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    final bool isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    try {
      final responseBody = response.body.isEmpty ? null : jsonDecode(response.body);

      if (isSuccess) {
        T? data;
        if (fromJson != null && responseBody != null) {
          data = fromJson(responseBody);
        } else if (T == String) {
          data = response.body as T;
        } else {
          data = responseBody as T?;
        }

        return NetworkResponse.success(
          data: data,
          statusCode: response.statusCode,
          headers: response.headers,
        );
      } else {
        return NetworkResponse.error(
          statusCode: response.statusCode,
          message: _extractErrorMessage(responseBody),
          data: responseBody,
          headers: response.headers,
        );
      }
    } catch (e) {
      if (isSuccess) {
        return NetworkResponse.success(
          data: response.body as T?,
          statusCode: response.statusCode,
          headers: response.headers,
        );
      } else {
        return NetworkResponse.error(
          statusCode: response.statusCode,
          message: response.body.isNotEmpty ? response.body : 'Unknown error',
          headers: response.headers,
        );
      }
    }
  }

  /// Extract error message from response body
  String _extractErrorMessage(dynamic responseBody) {
    if (responseBody == null) return 'Unknown error';

    if (responseBody is Map<String, dynamic>) {
      return responseBody['message'] ??
          responseBody['error'] ??
          responseBody['detail'] ??
          'Unknown error';
    }

    return responseBody.toString();
  }

  /// Dispose resources
  void dispose() {
    _client.close();
    _baseUri = null;
    _baseUrl = null;
    clearInterceptors();
  }
}

///  ====== Usage Example: ================

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class ApiService {
  final NetworkCaller _networkCaller = NetworkCaller.instance;

  ApiService() {
    // No need to initialize base URL - it's set internally
    // Just add interceptors
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(LoggingInterceptor()); // Print response

    // Add auth token if available
    // _networkCaller.addRequestInterceptor(AuthInterceptor(token: 'your-token'));
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await _networkCaller.get<List<dynamic>>(
        endpoint: '/users',
        fromJson: (json) => json as List<dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return response.data!.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw NetworkException(response.message ?? 'Failed to fetch users');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: '/users',
        body: user.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return User.fromJson(response.data!);
      } else {
        throw NetworkException(response.message ?? 'Failed to create user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser(int id, User user) async {
    try {
      final response = await _networkCaller.put<Map<String, dynamic>>(
        endpoint: '/users/$id',
        body: user.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return User.fromJson(response.data!);
      } else {
        throw NetworkException(response.message ?? 'Failed to update user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _networkCaller.delete(endpoint: '/users/$id');

      if (!response.isSuccess) {
        throw NetworkException(response.message ?? 'Failed to delete user');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Multipart request examples
  Future<String> uploadProfilePicture(int userId, File imageFile) async {
    try {

      final multipartFile = await MultipartFile.fromFile(
        field: 'profile_picture',
        file: imageFile,
        contentType: 'image/jpeg',
      );

      final response = await _networkCaller.uploadFile<Map<String, dynamic>>(
        endpoint: '/users/$userId/profile-picture',
        file: multipartFile,
        fields: {
          'user_id': userId.toString(),
          'description': 'Profile picture upload',
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return response.data!['image_url'] as String;
      } else {
        throw NetworkException(response.message ?? 'Failed to upload image');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> uploadMultipleFiles(List<File> files) async {
    try {
      final multipartFiles = <MultipartFile>[];

      for (int i = 0; i < files.length; i++) {
        final multipartFile = await MultipartFile.fromFile(
          field: 'files[$i]',
          file: files[i],
          contentType: 'application/octet-stream',
        );
        multipartFiles.add(multipartFile);
      }

      final response = await _networkCaller.uploadFiles<Map<String, dynamic>>(
        endpoint: '/upload/multiple',
        files: multipartFiles,
        fields: {
          'upload_type': 'batch',
          'total_files': files.length.toString(),
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final urls = response.data!['file_urls'] as List<dynamic>;
        return urls.map((url) => url.toString()).toList();
      } else {
        throw NetworkException(response.message ?? 'Failed to upload files');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> submitFormWithFile({
    required String name,
    required String email,
    required File document,
  }) async {
    try {
      final documentFile = await MultipartFile.fromFile(
        field: 'document',
        file: document,
        contentType: 'application/pdf',
      );

      final response = await _networkCaller.multipart<Map<String, dynamic>>(
        endpoint: '/submit-form',
        files: [documentFile],
        fields: {
          'name': name,
          'email': email,
          'submission_date': DateTime.now().toIso8601String(),
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return response.data!['submission_id'] as String;
      } else {
        throw NetworkException(response.message ?? 'Failed to submit form');
      }
    } catch (e) {
      rethrow;
    }
  }
}
