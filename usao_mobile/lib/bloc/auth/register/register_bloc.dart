import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:usao_mobile/repository/auth/auth_repository.dart';

import '../../../models/register/register_dto.dart';
import '../../../models/register/register_response.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc(this.authRepository) : super(RegisterInitialState()) {
    on<DoRegisterEvent>(_doRegisterEvent);
  }

  void _doRegisterEvent(
      DoRegisterEvent event, Emitter<RegisterState> emit) async {
    try {
      final registerResponse =
          await authRepository.register(event.registerDto, event.filePath);
      emit(RegisterSuccessState(registerResponse));
      return;
    } on Exception catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }
}
