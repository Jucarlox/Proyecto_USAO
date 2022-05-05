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

  /*@override
  Future<List<ProductoResponse>> fetchPublicPost(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(
        Uri.parse('http://10.0.2.2:8080/post/public'),
        headers: {'Authorization': 'Bearer ${prefs.getString("token")}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => PublicResponse.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load psot');
    }
  }*/

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
}
