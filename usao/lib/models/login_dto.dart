class LoginDto {
  LoginDto({
    required this.nick,
    required this.password,
  });
  late final String nick;
  late final String password;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nick'] = nick;
    _data['password'] = password;
    return _data;
  }
}
