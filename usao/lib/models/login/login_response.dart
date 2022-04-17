class LoginResponse {
  LoginResponse({
    required this.email,
    required this.nike,
    required this.id,
    required this.role,
    required this.token,
  });
  late final String email;
  late final String nike;
  late final String id;
  late final String role;
  late final String token;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    nike = json['nike'];
    id = json['id'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['nike'] = nike;
    _data['id'] = id;
    _data['role'] = role;
    _data['token'] = token;
    return _data;
  }
}
