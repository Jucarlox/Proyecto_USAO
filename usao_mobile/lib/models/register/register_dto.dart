class RegisterDto {
  RegisterDto({
    required this.nick,
    required this.email,
    required this.fechaNacimiento,
    required this.password,
    required this.password2,
    required this.avatar,
    required this.localizacion,
  });
  late final String nick;
  late final String email;
  late final String fechaNacimiento;
  late final String password;
  late final String password2;
  late final String avatar;
  late final String localizacion;

  RegisterDto.fromJson(Map<String, dynamic> json) {
    nick = json['nick'];
    email = json['email'];
    fechaNacimiento = json['fechaNacimiento'];
    password = json['password'];
    password2 = json['password2'];
    avatar = json['avatar'];
    localizacion = json['localizacion'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nick'] = nick;
    _data['email'] = email;
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['password'] = password;
    _data['password2'] = password2;
    _data['avatar'] = avatar;
    _data['localizacion'] = localizacion;
    return _data;
  }
}
