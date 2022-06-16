part of 'producto_bloc.dart';

abstract class ProductoState extends Equatable {
  const ProductoState();

  @override
  List<Object> get props => [];
}

class ProductoInitialState extends ProductoState {}

class ProductoInitialEditState extends ProductoState {
  final ProductoResponse productoResponse;

  const ProductoInitialEditState(this.productoResponse);

  @override
  List<Object> get props => [productoResponse];
}

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
  final List<ProductoResponse> productosSearch;

  const ProductoFetched(this.productosSearch);

  @override
  List<Object> get props => [productosSearch];
}

class ProductoFetchedAll extends ProductoState {
  final List<ProductoResponse> productoGangas;
  final List<ProductoResponse> productoAll;

  const ProductoFetchedAll(this.productoGangas, this.productoAll);

  @override
  List<Object> get props => [productoGangas, productoAll];
}

class ProductoIdFetched extends ProductoState {
  final ProductoResponse producto;

  const ProductoIdFetched(this.producto);

  @override
  List<Object> get props => [producto];
}

class ProductoFetchError extends ProductoState {
  final String message;
  const ProductoFetchError(this.message);

  @override
  List<Object> get props => [message];
}
