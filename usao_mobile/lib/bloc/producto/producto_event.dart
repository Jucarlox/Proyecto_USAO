part of 'producto_bloc.dart';

abstract class ProductoEvent extends Equatable {
  const ProductoEvent();

  @override
  List<Object> get props => [];
}

class FetchProductoWithType extends ProductoEvent {
  const FetchProductoWithType();

  @override
  List<Object> get props => [];
}

class DoProductoEvent extends ProductoEvent {
  final ProductoDto productoDto;
  final String imagePath;

  const DoProductoEvent(this.productoDto, this.imagePath);
}

class DeleteProductoEvent extends ProductoEvent {
  final int id;

  const DeleteProductoEvent(this.id);
}