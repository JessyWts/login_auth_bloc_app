import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repo.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({
    required UserRepository myUserRepository
  }) : _userRepository = myUserRepository,
    super (SignInInitial()) {
    on<SignInRequired>(_onSignInRequired);
    on<SignOutRequired>(_onSignOutRequired);
  }

  FutureOr<void> _onSignInRequired(SignInRequired event, Emitter<SignInState> emit) async {
    emit(SignInProcess());
    try {
      await _userRepository.signIn(event.email, event.password);
      emit(SignInSuccess());
    } catch (e) {
      log('_onSignInRequired -  ${e.toString()}');
      emit(SignInFailure(message: e.toString()));
    }
  }

  FutureOr<void> _onSignOutRequired(SignOutRequired event, Emitter<SignInState> emit) async {
    await _userRepository.signOut();
  }
}
