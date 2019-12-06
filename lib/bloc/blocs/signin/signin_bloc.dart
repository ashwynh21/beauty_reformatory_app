import 'dart:async';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signin_event.dart';

part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  UserController controller = new UserController();

  @override
  SigninState get initialState => InitialSigninState();

  @override
  Stream<SigninState> mapEventToState(SigninEvent event) async* {
    if(event is SigninSubmit) {
      yield LoadingSigninState(email: event.email, password: event.password);

      yield await controller.authenticate(email: event.email, password: event.password)
        .then((User user) {
          if(user != null)
            return SuccessSigninState(user: user);
          else
            return FailedSigninState(exception: ResponseException('Oops, invalid username or password!'));
        })
        .catchError((error) {
          return FailedSigninState(exception: error);
        });
    }
  }
}
