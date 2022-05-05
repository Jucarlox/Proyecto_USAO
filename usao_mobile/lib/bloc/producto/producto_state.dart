part of 'producto_bloc.dart';

abstract class ProductoState extends Equatable {
  const ProductoState();

  @override
  List<Object> get props => [];
}

class ProductoInitialState extends ProductoState {}

class ProductoLoading extends ProductoState {}

class ProductoSuccessState extends ProductoState {
  final ProductoResponse productoResponse;

  const ProductoSuccessState(this.productoResponse);

  @override
  List<Object> get props => [productoResponse];
}

class ProductoErrorState extends ProductoState {
  final String message;

  const ProductoErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ProductoFetched extends ProductoState {
  final List<ProductoResponse> productos;
  final String type;

  const ProductoFetched(this.productos, this.type);

  @override
  List<Object> get props => [productos];
}

class ProductoFetchError extends ProductoState {
  final String message;
  const ProductoFetchError(this.message);

  @override
  List<Object> get props => [message];
}
