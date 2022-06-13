class EditUserDto {
  EditUserDto({
    required this.nick,
    required this.fechaNacimiento,
    required this.localizacion,
    required this.password,
  });
  late final String nick;
  late final String fechaNacimiento;
  late final String localizacion;
  late final String password;

  EditUserDto.fromJson(Map<String, dynamic> json) {
    nick = json['nick'];
    fechaNacimiento = json['fechaNacimiento'];
    localizacion = json['localizacion'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nick'] = nick;
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['localizacion'] = localizacion;
    _data['password'] = password;
    return _data;
  }
}
