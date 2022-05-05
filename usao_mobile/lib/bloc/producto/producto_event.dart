part of 'producto_bloc.dart';

abstract class ProductoEvent extends Equatable {
  const ProductoEvent();

  @override
  List<Object> get props => [];
}

class FetchProductoWithType extends ProductoEvent {
  final String type;

  const FetchProductoWithType(this.type);

  @override
  List<Object> get props => [type];
}

class DoProductoEvent extends ProductoEvent {
  final ProductoDto productoDto;
  final String imagePath;

  const DoProductoEvent(this.productoDto, this.imagePath);
}
