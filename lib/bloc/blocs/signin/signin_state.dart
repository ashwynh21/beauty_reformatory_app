part of 'signin_bloc.dart';

@immutable
abstract class SigninState {}

class InitialSigninState extends SigninState {
}
class LoadingSigninState extends SigninState {
  String email, password;

  LoadingSigninState({
    @required this.email,
    @required this.password,
  });
}
class SuccessSigninState extends SigninState {
  User user;

  SuccessSigninState({
    @required this.user
  });
}
class FailedSigninState extends SigninState {
  Exception exception;

  FailedSigninState({
    @required this.exception
  });
}