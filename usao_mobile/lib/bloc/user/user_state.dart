part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserFetched extends UserState {
  final ProfileResponse user;

  const UserFetched(this.user);

  @override
  List<Object> get props => [user];
}

class UserFetchError extends UserState {
  final String message;
  const UserFetchError(this.message);

  @override
  List<Object> get props => [message];
}

class UserInitialEditState extends UserState {
  final ProfileResponse editResponse;

  const UserInitialEditState(this.editResponse);
}

class UserEditState extends UserState {
  final RegisterResponse editResponse;

  const UserEditState(this.editResponse);

  @override
  List<Object> get props => [editResponse];
}
