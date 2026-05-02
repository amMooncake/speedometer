import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(SignInInitial()) {
    on<SignInRequest>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());
      } catch (e) {
        emit(const SignInFailure(message: 'Nieprawidłowy email lub hasło!'));
      }
    });
    on<SignOutRequired>((event, emit) async => await _userRepository.logOut());

    on<SignInWithGoogleRequest>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signInWithGoogle();
        emit(SignInSuccess());
      } catch (e) {
        emit(const SignInFailure());
      }
    });
  }
}
