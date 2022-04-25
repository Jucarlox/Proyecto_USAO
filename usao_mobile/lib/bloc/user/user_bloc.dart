/*import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/posts/post_response.dart';
import '../../models/user/usuario_actual.dart';
import '../../repository/user/user_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUser>(_usersFetched);
  }

  void _usersFetched(FetchUser event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.me();
      final posts = await userRepository.userPosts();
      emit(UserFetched(user, posts));
      return;
    } on Exception catch (e) {
      emit(UserFetchError(e.toString()));
    }
  }
}*/