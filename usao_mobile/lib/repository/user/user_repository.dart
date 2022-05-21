import 'package:usao_mobile/models/user/profile_response.dart';

abstract class UserRepository {
  Future<ProfileResponse> fetchProfile();
}
