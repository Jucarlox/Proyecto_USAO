class RegisterResponse {
  RegisterResponse({
    required this.id,
    required this.nick,
    required this.email,
    required this.fechaNacimiento,
    required this.avatar,
    required this.estado,
  });
  late final String id;
  late final String nick;
  late final String email;
  late final String fechaNacimiento;
  late final String avatar;
  late final String estado;

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nick = json['nick'];
    email = json['email'];
    fechaNacimiento = json['fechaNacimiento'];
    avatar = json['avatar'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nick'] = nick;
    _data['email'] = email;
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['avatar'] = avatar;
    _data['estado'] = estado;
    return _data;
  }
}
