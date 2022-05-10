import 'package:usao_mobile/models/producto/producto_dto.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';

abstract class ProductoRepository {
  Future<List<ProductoResponse>> fetchGangasProducto();
  Future<ProductoResponse> createProducto(ProductoDto dto, String image);
  Future deleteProducto(int id);

  Future likeProducto(int id);
  Future<List<ProductoResponse>> fetchLikesProducto();
}
