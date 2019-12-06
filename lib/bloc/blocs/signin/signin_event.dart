part of 'signin_bloc.dart';

@immutable
abstract class SigninEvent {}

class SigninSubmit extends SigninEvent {
  String email, password;

  SigninSubmit({
    @required this.email,
    @required this.password,
  });
}