import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:usao_mobile/models/user/profile_response.dart';
import 'package:usao_mobile/repository/user/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUser>(_userFetched);
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
}
