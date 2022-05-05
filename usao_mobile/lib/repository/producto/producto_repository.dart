import 'package:usao_mobile/models/producto/producto_dto.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';

abstract class ProductoRepository {
  //Future<List<ProductoResponse>> fetchPublicPost(String type);
  Future<ProductoResponse> createProducto(ProductoDto dto, String image);
}
