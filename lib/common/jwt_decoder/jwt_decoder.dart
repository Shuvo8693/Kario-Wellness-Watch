 import 'dart:convert';

Map<String,dynamic> decodeJWT(String token){

 try {
   final parts = token.split('.');
    if(parts.length != 3){
      throw Exception('Invalid JWT token format');
    }
    final payload  = parts[1];
    String normalized = base64.normalize(payload);
    final decoded = utf8.decode(base64.decode(normalized));
  return jsonDecode(decoded);

 } on Exception catch (e) {
   throw Exception('Error decoding JWT: $e');
 }
  
 }

 extension Base64Extension on String {
   static String normalizes(String source) {
     // Add padding if necessary
     switch (source.length % 4) {
       case 0:
         break;
       case 2:
         source += '==';
         break;
       case 3:
         source += '=';
         break;
       default:
         throw Exception('Invalid base64 string');
     }
     return source;
   }
 }


 // Usage example
 void _jwtExample() {
   String token = 'your.jwt.token.here';

   try {
     Map<String, dynamic> payload = decodeJWT(token);

     print('User ID: ${payload['user_id']}');
     print('Email: ${payload['email']}');
     print('Expires: ${DateTime.fromMillisecondsSinceEpoch((payload['exp'] ?? 0) * 1000)}');

   } catch (e) {
     print('Error: $e');
   }
 }
