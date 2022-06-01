import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usao_mobile/models/producto/producto_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:usao_mobile/models/producto/producto_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';

part 'producto_event.dart';
part 'producto_state.dart';

class ProductoBloc extends Bloc<ProductoEvent, ProductoState> {
  final ProductoRepository productoRepository;

  ProductoBloc(this.productoRepository) : super(ProductoInitialState()) {
    on<FetchAllProducto>(_productoFetchedAll);
    on<DoProductoEvent>(_doProductoEvent);
    on<LikeProductoEvent>(_likeProductoEvent);
    on<FetchProductosLike>(__productoFetchedLike);
    on<DislikeProductoEvent>(_dislikeProductoEvent);
    on<ProductoIdEvent>(_productoIdEvent);
    on<SearchProductoEvent>(_productoFetchedSearch);
    on<EditProductoEvent>(_editProductoEvent);
    on<ProductoIdEvent2>(_productoIdEditEvent);
  }

  void _likeProductoEvent(
      LikeProductoEvent event, Emitter<ProductoState> emit) async {
    try {
      final postResponse = await productoRepository.likeProducto(event.id);
      emit(ProductoSuccessState(postResponse));
      return;
    } on Exception catch (e) {
      emit(ProductoErrorState(e.toString()));
    }
  }

  void _productoIdEvent(
      ProductoIdEvent event, Emitter<ProductoState> emit) async {
    try {
      final postResponse = await productoRepository.productoId(event.id);
      emit(ProductoSuccessState(postResponse));
      return;
    } on Exception catch (e) {
      emit(ProductoErrorState(e.toString()));
    }
  }

  void _productoIdEditEvent(
      ProductoIdEvent2 event, Emitter<ProductoState> emit) async {
    try {
      final postResponse = await productoRepository.productoId(event.id);
      emit(ProductoInitialEditState(postResponse));
      return;
    } on Exception catch (e) {
      emit(ProductoErrorState(e.toString()));
    }
  }

  void _dislikeProductoEvent(
      DislikeProductoEvent event, Emitter<ProductoState> emit) async {
    try {
      final postResponse = await productoRepository.dislikeProducto(event.id);
      emit(ProductoSuccessState(postResponse));
      return;
    } on Exception catch (e) {
      emit(ProductoErrorState(e.toString()));
    }
  }

  void _productoFetchedAll(
      FetchAllProducto event, Emitter<ProductoState> emit) async {
    try {
      final allProductos = await productoRepository.fetchAllProductos();
      final gangasProducto = await productoRepository.fetchGangasProducto();
      emit(ProductoFetchedAll(gangasProducto, allProductos));
      return;
    } on Exception catch (e) {
      emit(ProductoFetchError(e.toString()));
    }
  }

  void _productoFetchedSearch(
      SearchProductoEvent event, Emitter<ProductoState> emit) async {
    try {
      final producto = await productoRepository.fetchSearchProducto(event.text);
      emit(ProductoFetched(producto));
      return;
    } on Exception catch (e) {
      emit(ProductoFetchError(e.toString()));
    }
  }

  void __productoFetchedLike(
      FetchProductosLike event, Emitter<ProductoState> emit) async {
    try {
      final producto = await productoRepository.fetchLikesProducto();
      emit(ProductoFetched(producto));
      return;
    } on Exception catch (e) {
      emit(ProductoFetchError(e.toString()));
    }
  }

  void _doProductoEvent(
      DoProductoEvent event, Emitter<ProductoState> emit) async {
    try {
      final postResponse = await productoRepository.createProducto(
          event.productoDto, event.imagePath);
      emit(ProductoSuccessState(postResponse));
      return;
    } on Exception catch (e) {
      emit(ProductoErrorState(e.toString()));
    }
  }

  void _editProductoEvent(
      EditProductoEvent event, Emitter<ProductoState> emit) async {
    try {
      final postResponse = await productoRepository.editProducto(
          event.productoDto, event.id, event.imagePath);
      emit(ProductoSuccessState(postResponse));
      return;
    } on Exception catch (e) {
      emit(ProductoErrorState(e.toString()));
    }
  }
}
