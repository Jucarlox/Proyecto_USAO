import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/models/register/register_response.dart';
import 'package:usao_mobile/models/user/editUserDto.dart';
import 'package:usao_mobile/models/user/profile_response.dart';
import 'package:usao_mobile/repository/constants.dart';
import 'package:usao_mobile/repository/user/user_repository.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserRepositoryImpl extends UserRepository {
  final Client _client = Client();

  @override
  Future<ProfileResponse> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(Uri.parse("${Constants.baseUrl}/me"),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load profile');
    }
  }

  @override
  Future<RegisterResponse> editProfile(
      EditUserDto editUserDto, String image) async {
    // TODO: implement editProducto
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    try {
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + token!
      };

      var data = json.encode({
        "fechaNacimiento": editUserDto.fechaNacimiento,
        "localizacion": editUserDto.localizacion,
      });

      var request = http.MultipartRequest(
          'PUT', Uri.parse("${Constants.baseUrl}/profile/me"))
        ..files.add(http.MultipartFile.fromString('user', data,
            contentType: MediaType('application', 'json')))
        ..files.add(await http.MultipartFile.fromPath('file', image));

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(
            jsonDecode(await response.stream.bytesToString()));
      } else {
        throw Exception('Fail to edit user');
      }
    } catch (error) {
      print('Error add project $error');
      throw (error);
    }
  }
}
