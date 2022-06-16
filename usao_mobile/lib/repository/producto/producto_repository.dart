import 'package:usao_mobile/models/producto/producto_dto.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';

abstract class ProductoRepository {
  Future<List<ProductoResponse>> fetchGangasProducto();
  Future<List<ProductoResponse>> fetchAllProductos();
  Future<ProductoResponse> createProducto(ProductoDto dto, String image);
  Future deleteProducto(int id);

  Future likeProducto(int id);
  Future dislikeProducto(int id);
  Future<List<ProductoResponse>> fetchLikesProducto();
  Future<ProductoResponse> productoId(int id);

  Future<List<ProductoResponse>> fetchSearchProducto(String text);
  Future<ProductoResponse> editProducto(ProductoDto dto, int id, String image);
}
