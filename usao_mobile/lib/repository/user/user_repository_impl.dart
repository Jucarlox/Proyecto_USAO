import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/models/user/profile_response.dart';
import 'package:usao_mobile/repository/constants.dart';
import 'package:usao_mobile/repository/user/user_repository.dart';

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
}
