import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:usao_mobile/models/user/editUserDto.dart';
import 'package:usao_mobile/models/user/profile_response.dart';
import 'package:usao_mobile/repository/producto/producto_repository.dart';
import 'package:usao_mobile/repository/user/user_repository.dart';

import '../../models/register/register_response.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final ProductoRepository productoRepository;

  UserBloc(this.userRepository, this.productoRepository)
      : super(UserInitial()) {
    on<FetchUser>(_userFetched);
    on<DeleteProductoEvent>(_deleteProductoEvent);
    on<EditUserEvent>(_userIdEditEvent);
    on<FetchUserEdit>(_userFetchedEdit);
  }

  void _userFetched(FetchUser event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.fetchProfile();
      emit(UserFetched(user));
      return;
    } on Exception catch (e) {
      emit(UserFetchError(e.toString()));
    }
  }

  void _userFetchedEdit(FetchUserEdit event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.fetchProfile();
      emit(UserInitialEditState(user));
      return;
    } on Exception catch (e) {
      emit(UserFetchError(e.toString()));
    }
  }

  void _deleteProductoEvent(
      DeleteProductoEvent event, Emitter<UserState> emit) async {
    try {
      final postResponse = await productoRepository.deleteProducto(event.id);
      emit(UserFetched(postResponse));
      return;
    } on Exception catch (e) {
      emit(UserFetchError(e.toString()));
    }
  }

  void _userIdEditEvent(EditUserEvent event, Emitter<UserState> emit) async {
    try {
      final editResponse =
          await userRepository.editProfile(event.editDto, event.imagePath);
      emit(UserEditState(editResponse));
      return;
    } on Exception catch (e) {
      emit(UserFetchError(e.toString()));
    }
  }
}
