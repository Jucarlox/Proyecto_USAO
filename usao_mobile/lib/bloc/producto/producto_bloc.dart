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
    on<FetchProductoWithType>(_productoFetchedGangas);
    on<DoProductoEvent>(_doProductoEvent);
    on<LikeProductoEvent>(_likeProductoEvent);
    on<FetchProductosLike>(__productoFetchedLike);
    on<DislikeProductoEvent>(_dislikeProductoEvent);
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

  void _productoFetchedGangas(
      FetchProductoWithType event, Emitter<ProductoState> emit) async {
    try {
      final producto = await productoRepository.fetchGangasProducto();
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
}
