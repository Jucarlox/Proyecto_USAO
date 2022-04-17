import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:usao/models/login/login_dto.dart';

import '../../../models/login/login_response.dart';
import '../../../models/register/register_dto.dart';
import '../../../models/register/register_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginDto loginDto);
  Future<RegisterResponse> register(RegisterDto registerDto, String filePath);
}
