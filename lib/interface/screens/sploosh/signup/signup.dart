import 'package:beautyreformatory/interface/components/br_button.dart';
import 'package:beautyreformatory/interface/components/br_dropdown.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/components/br_input.dart';
import 'package:beautyreformatory/services/controllers/account_controller.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/account.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class Signup extends StatefulWidget {
  _SignupState state;

  Future<bool> Function() back;
  void Function(Signup) login, success;

  Signup({Key key,
    this.back,
    this.login,
    this.success
  }) : super(key: key);

  @override
  _SignupState createState() {
    state = _SignupState();
    return state;
  }
}

class _SignupState extends State<Signup> {
  BrInput fullname, email, mobile, password;
  BrDropdown country;
  BrButton submit;
  BrIconButton google, facebook;

  @override
  void initState() {
    initfields();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.back,
      child: Material(
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
                  Container(
                      child: Text('Create an account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Segoe UI',
                          color: resources.colors.dark,
                        ),
                      )
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 16),

                    child: fullname,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 8),

                    child: email,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    width: MediaQuery.of(context).size.width,

                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: country
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(left: 16),
                            child: mobile
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 8),

                    child: password,
                  ),

                  Container(
                      margin: EdgeInsets.only(top: 32),

                      child: submit
                  ),

                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: <Widget>[
                          GestureDetector(
                              onTap: () => widget.login(widget),
                              child: Wrap(
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text('already have an account?',
                                        style: TextStyle(
                                          color: resources.colors.primary,
                                          fontSize: 14,
                                        )
                                    ),
                                    Text('login',

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
      ),
    );
  }

  Future initfields() {
    password = BrInput(placeholder: 'password',
        icon: 'lib/interface/assets/flares/lock_icon.flr',
        type: TextInputType.visiblePassword,
        action: TextInputAction.done,
        obscure: true,
        submit: (view, value) {
        }
    );
    mobile = BrInput(placeholder: 'mobile number',
        icon: 'lib/interface/assets/flares/mobile_icon.flr',
        type: TextInputType.phone,
        action: TextInputAction.next,
        submit: (view, value) {
          setState(() {
            FocusScope.of(context).requestFocus(password.state.focus);
          });
        }
    );
    email = BrInput(placeholder: 'email address',
        icon: 'lib/interface/assets/flares/mail_icon.flr',
        type: TextInputType.emailAddress,
        action: TextInputAction.next,
        submit: (view, value) {
          setState(() {
            FocusScope.of(context).requestFocus(mobile.state.focus);
          });
        }
    );
    country = BrDropdown(
      icon: 'lib/interface/assets/flares/globe_icon.flr',
      hint: 'country',
      items: resources.files.countries,
    );
    fullname = BrInput(placeholder: 'full name',
      icon: 'lib/interface/assets/flares/avatar_icon.flr',
      type: TextInputType.text,
      action: TextInputAction.next,
      submit: (view, value) {
        setState(() {
          FocusScope.of(context).requestFocus(email.state.focus);
        });
      },
    );
    submit = BrButton(
        network: true,
        title: 'sign up',
        color: Colors.white,
        background: resources.colors.primary,
        click: (view) {

          dialogs.loader.show(true);
          FirebaseMessaging firebase = new FirebaseMessaging();

          return firebase.getToken().then((String token) {

            return (new UserController()).
            create(
              email: email.value,
              password: password.value,
              fullname: fullname.value,
              mobile: mobile.value,
              location: country.value,
              firebase: token,
            ).
            then((User user) {
              if(user != null) {
                BeautyReformatory.initapp().then((User user) {
                  dialogs.loader.show(false).then((value){
                    widget.success(widget);
                  });
                });
              }
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
              google_signup(
                  email: account.email,
                  token: authentication.accessToken,
                  firebase: token,
              ).
              then((Account account) {
                if(account != null) {
                  BeautyReformatory.initapp().then((User user) {
                    dialogs.loader.show(false).then((value){
                      widget.success(widget);
                    });
                  });
                }
              }).catchError((error) {
                dialogs.loader.show(false);
                dialogs.snack.show(error.message);
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
                facebook_signup(
                    token: result.accessToken.token,
                    firebase: token,
                ).
                then((Account account) {
                  if(account != null) {
                    BeautyReformatory.initapp().then((User user) {
                      dialogs.loader.show(false).then((value){
                        widget.success(widget);
                      });
                    });
                  }
                }).catchError((error) {
                  dialogs.loader.show(false);
                  dialogs.snack.show(error.message);
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