class ProductoDto {
  ProductoDto({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.fileOriginal,
    required this.fileScale,
  });
  late final String nombre;
  late final String descripcion;
  late final double precio;
  late final String categoria;
  late final String fileOriginal;
  late final String fileScale;

  ProductoDto.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    precio = json['precio'];
    categoria = json['categoria'];
    fileOriginal = json['fileOriginal'];
    fileScale = json['fileScale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nombre'] = nombre;
    _data['descripcion'] = descripcion;
    _data['precio'] = precio;
    _data['categoria'] = categoria;
    _data['fileOriginal'] = fileOriginal;
    _data['fileScale'] = fileScale;
    return _data;
  }
}
