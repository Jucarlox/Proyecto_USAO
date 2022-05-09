class ProfileResponse {
  ProfileResponse({
    required this.id,
    required this.nick,
    required this.email,
    required this.fechaNacimiento,
    required this.avatar,
    required this.role,
    required this.productoList,
    required this.productoListLike,
  });
  late final String id;
  late final String nick;
  late final String email;
  late final String fechaNacimiento;
  late final String avatar;
  late final String role;
  late final List<ProductoList> productoList;
  late final List<ProductoListLike> productoListLike;

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nick = json['nick'];
    email = json['email'];
    fechaNacimiento = json['fechaNacimiento'];
    avatar = json['avatar'];
    role = json['role'];
    productoList = List.from(json['productoList'])
        .map((e) => ProductoList.fromJson(e))
        .toList();
    productoListLike = List.from(json['productoListLike'])
        .map((e) => ProductoListLike.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nick'] = nick;
    _data['email'] = email;
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['avatar'] = avatar;
    _data['role'] = role;
    _data['productoList'] = productoList.map((e) => e.toJson()).toList();
    _data['productoListLike'] =
        productoListLike.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ProductoList {
  ProductoList({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.propietario,
    required this.fileScale,
  });
  late final int id;
  late final String nombre;
  late final String descripcion;
  late final String categoria;
  late final double? precio;
  late final Propietario propietario;
  late final String fileScale;

  ProductoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    categoria = json['categoria'];
    precio = json['precio'];
    propietario = Propietario.fromJson(json['propietario']);
    fileScale = json['fileScale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nombre'] = nombre;
    _data['descripcion'] = descripcion;
    _data['categoria'] = categoria;
    _data['precio'] = precio;
    _data['propietario'] = propietario.toJson();
    _data['fileScale'] = fileScale;
    return _data;
  }
}

class Propietario {
  Propietario({
    required this.id,
    required this.nick,
    required this.email,
    required this.localizacion,
    required this.fechaNacimiento,
    required this.avatar,
    required this.role,
  });
  late final String id;
  late final String nick;
  late final String email;
  late final String localizacion;
  late final String fechaNacimiento;
  late final String avatar;
  late final String role;

  Propietario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nick = json['nick'];
    email = json['email'];
    localizacion = json['localizacion'];
    fechaNacimiento = json['fechaNacimiento'];
    avatar = json['avatar'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nick'] = nick;
    _data['email'] = email;
    _data['localizacion'] = localizacion;
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['avatar'] = avatar;
    _data['role'] = role;
    return _data;
  }
}

class ProductoListLike {
  ProductoListLike({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.propietario,
    required this.fileScale,
  });
  late final int id;
  late final String nombre;
  late final String descripcion;
  late final String categoria;
  late final int precio;
  late final Propietario propietario;
  late final String fileScale;

  ProductoListLike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    categoria = json['categoria'];
    precio = json['precio'];
    propietario = Propietario.fromJson(json['propietario']);
    fileScale = json['fileScale'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nombre'] = nombre;
    _data['descripcion'] = descripcion;
    _data['categoria'] = categoria;
    _data['precio'] = precio;
    _data['propietario'] = propietario.toJson();
    _data['fileScale'] = fileScale;
    return _data;
  }
}
