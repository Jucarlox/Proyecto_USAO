import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/models/login/login_dto.dart';
import 'package:usao_mobile/models/login/login_response.dart';
import 'package:usao_mobile/models/register/register_dto.dart';
import 'package:usao_mobile/models/register/register_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:diacritic/diacritic.dart';

import '../constants.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Client _client = Client();

  @override
  Future<LoginResponse> login(LoginDto loginDto) async {
    final prefs = await SharedPreferences.getInstance();
    final response =
        await _client.post(Uri.parse("${Constants.baseUrl}/auth/login"),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(loginDto.toJson()));
    if (response.statusCode == 201) {
      prefs.setString(
          'token', LoginResponse.fromJson(json.decode(response.body)).token);
      prefs.setString(
          'id', LoginResponse.fromJson(json.decode(response.body)).id);
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fail to login');
    }
  }

  @override
  Future<RegisterResponse> register(
      RegisterDto registerDto, String filePath) async {
    Map<String, String> headers = {"Content-Type": "multipart/form-data"};

    var data = json.encode({
      "nick": registerDto.nick,
      "email": registerDto.email,
      "password": registerDto.password,
      "password2": registerDto.password2,
      "avatar": registerDto.avatar,
      "fechaNacimiento": registerDto.fechaNacimiento,
      "categoria": "false",
      "localizacion": removeDiacritics(registerDto.localizacion.toLowerCase())
    });

    if (filePath == '') {
      throw Exception('Debe de selecionar una imagen');
    } else {
      var request = http.MultipartRequest(
          'POST', Uri.parse("https://usao-back.herokuapp.com/auth/register"))
        ..files.add(http.MultipartFile.fromString('user', data,
            contentType: MediaType('application', 'json')))
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 201) {
        if (registerDto.password.length < 6 ||
            registerDto.password2.length < 6) {
          throw Exception('contraseña inferior a 6 caracteres');
        } else {
          LoginDto loginDto = LoginDto(
              email: registerDto.email, password: registerDto.password);
          login(loginDto);
          print(registerDto.avatar);
          return RegisterResponse.fromJson(
              jsonDecode(await response.stream.bytesToString()));
        }
      } else {
        throw Exception('Fail to register');
      }
    }
  }
}

jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
  for (var key in data.keys) {
    request.fields[key] = data[key].toString();
  }
  return request;
}
