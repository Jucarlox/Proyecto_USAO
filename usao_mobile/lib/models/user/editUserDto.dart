class EditUserDto {
  EditUserDto({
    required this.fechaNacimiento,
    required this.localizacion,
  });
  late final String fechaNacimiento;
  late final String localizacion;

  EditUserDto.fromJson(Map<String, dynamic> json) {
    fechaNacimiento = json['fechaNacimiento'];
    localizacion = json['localizacion'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['localizacion'] = localizacion;
    return _data;
  }
}
