import 'package:beautyreformatory/interface/components/br_button.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/components/br_input.dart';
import 'package:beautyreformatory/services/controllers/account_controller.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/account.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../main.dart';

class Login extends StatefulWidget {
  _LoginState state;

  void Function(Login) signup, recover;

  Login({Key key,
    this.signup,
    this.recover,
  }) : super(key: key);

  @override
  _LoginState createState() {
    state = _LoginState();
    return state;
  }
}

class _LoginState extends State<Login> {
  // input components
  BrInput username, password;
  BrButton submit;
  BrIconButton google, facebook;

  @override
  void initState() {
    _inputinit();

    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 32, right: 32),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[
                // Title
                Container(
                    child: Text('Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: 'Segoe UI',
                        color: resources.colors.dark,
                      ),
                    )
                ),

                // Form Interface
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 32),

                  child: username,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 12),

                  child: password,
                ),
                Container(
                    margin: EdgeInsets.only(top: 32),

                    child: submit
                ),

                // Separators
                Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        GestureDetector(
                          onTap: () => widget.recover(widget),
                            child: Wrap(
                                children: <Widget>[
                                  Text('forgot password?',
                                      style: TextStyle(
                                        color: resources.colors.primary,
                                        fontSize: 14,
                                      )
                                  )
                                ])
                        ),
                        Container(
                          height: 24,
                          width: 1.5,
                          margin: EdgeInsets.only(left: 36, right: 16),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: resources.colors.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.signup(widget),
                          child: Wrap(
                                spacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  Text('new here?',
                                      style: TextStyle(
                                        color: resources.colors.primary,
                                        fontSize: 14,
                                      )
                                  ),
                                  Text('sign up!',

                                      style: TextStyle(
                                          color: resources.colors.primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                ])
                        ),
                      ],
                    )
                ),

                // Separators
                Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 1.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: resources.colors.dark.withOpacity(0.48),
                          ),
                        ),
                        Text(' or ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 1.5,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: resources.colors.dark.withOpacity(0.48),
                          ),
                        )
                      ],
                    )
                ),

                // External login
                Container(
                    margin: EdgeInsets.only(top: 16),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 8),

                          child: google,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),

                          child: facebook,
                        ),
                      ],
                    )
                )
              ],
            )
        ),
      ),
    );
  }

  /*
   * This function will be used to initialize the input components for the logging
   * in form.
   */
  void _inputinit() {
    password = BrInput(placeholder: 'password',
      icon: 'lib/interface/assets/flares/lock_icon.flr',
      type: TextInputType.visiblePassword,
      action: TextInputAction.done,
      obscure: true,
    );
    username = BrInput(placeholder: 'username / email address',
      icon: 'lib/interface/assets/flares/avatar_icon.flr',
      type: TextInputType.emailAddress,
      action: TextInputAction.next,
      submit: (view, value) {
        setState(() {
          FocusScope.of(context).requestFocus(password.state.focus);
        });
      },
    );
    submit = BrButton(
        title: 'sign in',
        color: Colors.white,
        background: resources.colors.primary,
        click: (view) async {
          dialogs.loader.show(true);
          FirebaseMessaging firebase = new FirebaseMessaging();

          firebase.getToken().then((String token) {

            (new UserController()).
            authenticate(
                email: username.value,
                password: password.value,
                firebase: token,
            ).
            then((User user) {
              dialogs.loader.show(false).then((value){
                if(user != null) {
                  BeautyReformatory.initapp().then((User user) {
                    dialogs.loader.show(false).then((value){
                      Navigator.of(context).pushReplacementNamed('/house');
                    });
                  });
                }
              });
            });
          }).catchError((error) {
            dialogs.snack.show(error.message);
            dialogs.loader.show(false);
          });

        }
    );
    google = BrIconButton(
      src: 'lib/interface/assets/flares/google.flr',
      background: Colors.white,
      color: resources.colors.google,

      click: (view) {
        GoogleSignIn _google = GoogleSignIn(
          scopes: [
            'email',
            'profile'
          ],
        );

        dialogs.loader.show(true);
        FirebaseMessaging firebase = new FirebaseMessaging();

        firebase.getToken().then((String token) {
          _google.signIn().then((GoogleSignInAccount account) {
            account.authentication.then((GoogleSignInAuthentication authentication) {

              (new AccountController()).
              google_signin(
                  email: account.email,
                  token: authentication.accessToken,
                  firebase: token,
              ).
              then((Account account) {
                if(account != null) {
                  BeautyReformatory.initapp().then((User user) {
                    dialogs.loader.show(false).then((value){
                      Navigator.of(context).pushReplacementNamed('/house');
                    });
                  });
                }
              }).catchError((error) {
                dialogs.loader.show(false);
                dialogs.snack.show(error.toString());
              });
            });
          });
        }).catchError((error) {
          /**
           * Here we must figure a way to handle the APIExceptions that could occur
           * for now though we will just show it in the snack
           */

          dialogs.loader.show(false);
          dialogs.snack.show(error.toString());
        });
      },
    );
    facebook = BrIconButton(
      src: 'lib/interface/assets/flares/facebook.flr',
      background: Colors.white,
      color: resources.colors.facebook,

      click: (view) {

        dialogs.loader.show(true);
        FirebaseMessaging firebase = new FirebaseMessaging();

        firebase.getToken().then((String token) {

          final _facebook = FacebookLogin();
          _facebook.logIn(['email']).then((FacebookLoginResult result) {
            switch (result.status) {
              case FacebookLoginStatus.loggedIn:

                (new AccountController()).
                facebook_signin(
                    token: result.accessToken.token,
                    firebase: token,
                ).
                then((Account account) {
                  dialogs.loader.show(false).then((value){
                    if(account != null) {
                      BeautyReformatory.initapp().then((User user) {
                        dialogs.loader.show(false).then((value){
                          Navigator.of(context).pushReplacementNamed('/house');
                        });
                      });
                    }
                  });
                }).catchError((error) {
                  dialogs.loader.show(false);
                  dialogs.snack.show(error.toString());
                });

                break;
              case FacebookLoginStatus.cancelledByUser:
                dialogs.loader.show(false);
                break;
              case FacebookLoginStatus.error:
                throw new ExternalException(result.errorMessage);
              default:
                throw new UnknownException('Oops, something went wrong!');
            }
          });
        }).catchError((error) {
          /**
           * Here we must figure a way to handle the APIExceptions that could occur
           * for now though we will just show it in the snack
           */

          dialogs.loader.show(false);
          dialogs.snack.show(error.toString());
        });

      },
    );
  }
}
