import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kario_wellness_watch/sk_key.dart';

import 'api_constants.dart';


class GoogleApiService{

static  Future<List<String>> fetchSuggestions(String query)async{

   final response = await http.get(Uri.parse('${ApiConstants.googleBaseUrl}?input=$query&key=${SKey.googleApiKey}')); // All Country
  // final response = await http.get(Uri.parse('${ApiConstants.googleBaseUrl}?input=$query&components=country:BD&key=${ApiConstants.googleApiKey}')); // Individual Country
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final predictions = jsonData['predictions'] as List<dynamic>;
      var  _suggestions = predictions.map((prediction) => prediction['description'].toString()).toList();
      return _suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

static Future<LatLng?> fetchAddressToCoordinate(String address, Function(LatLng location) locationCallBack)async{
  final String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=${SKey.googleApiKey}';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        print('Lat: ${location['lat']}, Lng: ${location['lng']}');
        locationCallBack(LatLng(location['lat'],location['lng']));
        return LatLng(location['lat'],location['lng']);
      }
    }
  } catch (e) {
    print('Coordinate failed: $e');
  }
  return null;
}

static Future<List<Placemark>> placeMarkFromCoordinate(LatLng location)async{
  final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=${SKey.googleApiKey}';
  List<Placemark> placeMark= [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      placeMark=[];
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final results = data['results'][0];
        final address = results['formatted_address'];
        final components = results['address_components'] as List;

        final placeMarks = Placemark(
          name: address,
          street: _componentsPlaceMark(components, 'route'),
          locality: _componentsPlaceMark(components, 'locality'),
          administrativeArea: _componentsPlaceMark(components, 'administrative_area_level_1'),
          country: _componentsPlaceMark(components, 'country'),
          postalCode: _componentsPlaceMark(components, 'postal_code'),
        );
        print('Address: $address');
        placeMark.add(placeMarks);
        return placeMark;
      }else{
        return [Placemark()];
      }
    }
  } catch (e) {
    print('placeMark from coordinate failed: $e');
  }
  return placeMark;
}

static String? _componentsPlaceMark(List components, String type) {
  for (var component in components) {
    if (component['types'].contains(type)) {
      return component['long_name'];
    }
  }
  return null;
}

}