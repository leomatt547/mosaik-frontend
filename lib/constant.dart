// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

// ignore: non_constant_identifier_names
String API_URL = 'https://mosaik-id.herokuapp.com';
// Cannot implement async in android
// String API_URL = dotenv.get('API_URL');

// Token storage
final storage = GetStorage();

// Get Token
getToken() {
  return storage.read('token');
}
