part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {
  const FetchUser();

  @override
  List<Object> get props => [];
}

class FetchUserEdit extends UserEvent {
  const FetchUserEdit();

  @override
  List<Object> get props => [];
}

class DeleteProductoEvent extends UserEvent {
  final int id;

  const DeleteProductoEvent(this.id);
}

class EditUserEvent extends UserEvent {
  final EditUserDto editDto;
  final String imagePath;
  const EditUserEvent(
    this.editDto,
    this.imagePath,
  );
}
