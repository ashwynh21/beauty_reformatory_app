import 'package:beautyreformatory/components/br_button.dart';
import 'package:beautyreformatory/components/br_icon_button.dart';
import 'package:beautyreformatory/components/br_input.dart';
import 'package:beautyreformatory/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  _LoginState state;

  void Function(Login) signup;

  Login({Key key,
    this.signup
  }) : super(key: key);

  @override
  _LoginState createState() {
    state = _LoginState();
    return state;
  }
}

class _LoginState extends State<Login> {
  BrInput username, password;

  @override
  void initState() {
    password = BrInput(placeholder: 'password',
      icon: 'lib/assets/flares/lock_icon.flr',
      type: TextInputType.visiblePassword,
      action: TextInputAction.done,
      obscure: true,
    );
    username = BrInput(placeholder: 'username / email address',
      icon: 'lib/assets/flares/avatar_icon.flr',
      type: TextInputType.emailAddress,
      action: TextInputAction.next,
      submit: (view, value) {
        setState(() {
          FocusScope.of(context).requestFocus(password.state.focus);
        });
      },
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 32, right: 32, top: 128),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[
                Container(
                    child: Text('sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: 'Segoe UI',
                        color: utilities.colors.dark,
                      ),
                    )
                ),

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

                    child: BrButton(
                        title: 'sign in',
                        color: Colors.white,
                        background: utilities.colors.primary,
                        click: (view) {

                        }
                    )
                ),

                Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        GestureDetector(
                            child: Wrap(
                                children: <Widget>[
                                  Text('forgot password?',
                                      style: TextStyle(
                                        color: utilities.colors.primary,
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
                            color: utilities.colors.primary,
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
                                        color: utilities.colors.primary,
                                        fontSize: 14,
                                      )
                                  ),
                                  Text('sign up!',

                                      style: TextStyle(
                                          color: utilities.colors.primary,
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
                            color: utilities.colors.dark.withOpacity(0.48),
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
                            color: utilities.colors.dark.withOpacity(0.48),
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

                          child: BrIconButton(
                            src: 'lib/assets/flares/google.flr',
                            background: Colors.white,
                            color: utilities.colors.google,

                            click: (view) {

                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),

                          child: BrIconButton(
                            src: 'lib/assets/flares/facebook.flr',
                            background: Colors.white,
                            color: utilities.colors.facebook,

                            click: (view) {

                            },
                          ),
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
}
