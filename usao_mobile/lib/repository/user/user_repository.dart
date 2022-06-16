import 'package:usao_mobile/models/register/register_response.dart';
import 'package:usao_mobile/models/user/editUserDto.dart';
import 'package:usao_mobile/models/user/profile_response.dart';

abstract class UserRepository {
  Future<ProfileResponse> fetchProfile();
  Future<RegisterResponse> editProfile(EditUserDto dto, String image);
}
