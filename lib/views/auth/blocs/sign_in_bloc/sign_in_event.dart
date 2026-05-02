part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInRequest extends SignInEvent {
  final String email;
  final String password;

  const SignInRequest(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutRequired extends SignInEvent {}

class SignInWithGoogleRequest extends SignInEvent {}
