import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/models/producto/producto_dto.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/constants.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProductoRepositoryImpl extends ProductoRepository {
  final Client _client = Client();

  @override
  Future<List<ProductoResponse>> fetchGangasProducto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
        Uri.parse("${Constants.baseUrl}/producto/gangas"),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => ProductoResponse.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load psot');
    }
  }

  @override
  Future<ProductoResponse> createProducto(
      ProductoDto productoDto, String filePath) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    try {
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + token!
      };

      var data = json.encode({
        "nombre": productoDto.nombre,
        "descripcion": productoDto.descripcion,
        "precio": productoDto.precio,
        "categoria": productoDto.categoria,
        "fileOriginal": productoDto.fileOriginal,
        "fileScale": productoDto.fileScale,
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse("${Constants.baseUrl}/producto"))
        ..files.add(http.MultipartFile.fromString('producto', data,
            contentType: MediaType('application', 'json')))
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 201) {
        return ProductoResponse.fromJson(
            jsonDecode(await response.stream.bytesToString()));
      } else {
        throw Exception('Fail to create post');
      }
    } catch (error) {
      print('Error add project $error');
      throw (error);
    }
  }

  @override
  Future deleteProducto(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + token!
      };

      var request = http.MultipartRequest(
          'DELETE', Uri.parse("${Constants.baseUrl}/producto/${id}"));

      request.headers.addAll(headers);

      var response = await request.send();
      if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception('Fail to delete post');
      }
    } catch (error) {
      print('Error add project $error');
      throw (error);
    }
  }

  @override
  Future likeProducto(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + token!
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse("${Constants.baseUrl}/producto/like/${id}"));

      request.headers.addAll(headers);

      var response = await request.send();
      if (response.statusCode == 201) {
        return ProductoResponse.fromJson(
            jsonDecode(await response.stream.bytesToString()));
      } else {
        throw Exception('Fail to favorite producto');
      }
    } catch (error) {
      print('Error add project $error');
      throw (error);
    }
  }

  @override
  Future dislikeProducto(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + token!
      };

      var request = http.MultipartRequest(
          'DELETE', Uri.parse("${Constants.baseUrl}/producto/dislike/${id}"));

      request.headers.addAll(headers);

      var response = await request.send();
      if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception('Fail to delete post');
      }
    } catch (error) {
      print('Error add project $error');
      throw (error);
    }
  }

  @override
  Future<List<ProductoResponse>> fetchLikesProducto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
        Uri.parse("${Constants.baseUrl}/producto/like"),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => ProductoResponse.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load list likes');
    }
  }

  @override
  Future<ProductoResponse> productoId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
        Uri.parse("${Constants.baseUrl}/productos/${id}"),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 201) {
      return ProductoResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load list likes');
    }
  }

  @override
  Future<List<ProductoResponse>> fetchSearchProducto(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
        Uri.parse("${Constants.baseUrl}/producto/filtro?string=${text}"),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => ProductoResponse.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load list likes');
    }
  }

  @override
  Future<ProductoResponse> editProducto(
      ProductoDto productoDto, int id, String image) async {
    // TODO: implement editProducto
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    try {
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + token!
      };

      var data = json.encode({
        "nombre": productoDto.nombre,
        "descripcion": productoDto.descripcion,
        "precio": productoDto.precio,
        "categoria": productoDto.categoria,
        "fileOriginal": productoDto.fileOriginal,
        "fileScale": productoDto.fileScale,
      });

      if (productoDto.fileScale == image) {
        throw Exception('Debe cambiar la imagen del producto');
      }

      var request = http.MultipartRequest(
          'PUT', Uri.parse("${Constants.baseUrl}/producto/${id}"))
        ..files.add(http.MultipartFile.fromString('producto', data,
            contentType: MediaType('application', 'json')))
        ..files.add(await http.MultipartFile.fromPath('file', image));

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 201) {
        return ProductoResponse.fromJson(
            jsonDecode(await response.stream.bytesToString()));
      } else {
        throw Exception('Fail to edit post');
      }
    } catch (error) {
      print('Error add project $error');
      throw (error);
    }
  }

  @override
  Future<List<ProductoResponse>> fetchAllProductos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
        Uri.parse("${Constants.baseUrl}/producto"),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => ProductoResponse.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load productos');
    }
  }
}
