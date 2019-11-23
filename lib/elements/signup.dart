import 'package:beautyreformatory/components/br_button.dart';
import 'package:beautyreformatory/components/br_dropdown.dart';
import 'package:beautyreformatory/components/br_icon_button.dart';
import 'package:beautyreformatory/components/br_input.dart';
import 'package:beautyreformatory/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  _SignupState state;

  Future<bool> Function() back;
  void Function(Signup) login;

  Signup({Key key,
    this.back,
    this.login,
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
              margin: EdgeInsets.only(left: 32, right: 32, top: 104),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,

                children: <Widget>[
                  Container(
                      child: Text('create an account',
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
                          flex: 1,
                          child: Container(
                              child: country
                          ),
                        ),
                        Expanded(
                          flex: 2,
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

                      child: BrButton(
                          title: 'sign up',
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
                              onTap: () => widget.login(widget),
                              child: Wrap(
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text('already have an account?',
                                        style: TextStyle(
                                          color: utilities.colors.primary,
                                          fontSize: 14,
                                        )
                                    ),
                                    Text('login',

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
      ),
    );
  }

  void initfields() {
    password = BrInput(placeholder: 'password',
        icon: 'lib/assets/flares/lock_icon.flr',
        type: TextInputType.visiblePassword,
        action: TextInputAction.done,
        submit: (view, value) {
        }
    );
    mobile = BrInput(placeholder: 'mobile number',
        icon: 'lib/assets/flares/mobile_icon.flr',
        type: TextInputType.phone,
        action: TextInputAction.next,
        submit: (view, value) {
          setState(() {
            FocusScope.of(context).requestFocus(password.state.focus);
          });
        }
    );
    email = BrInput(placeholder: 'email address',
        icon: 'lib/assets/flares/mail_icon.flr',
        type: TextInputType.emailAddress,
        action: TextInputAction.next,
        submit: (view, value) {
          setState(() {
            FocusScope.of(context).requestFocus(mobile.state.focus);
          });
        }
    );
    fullname = BrInput(placeholder: 'full name',
      icon: 'lib/assets/flares/avatar_icon.flr',
      type: TextInputType.text,
      action: TextInputAction.next,
      submit: (view, value) {
        setState(() {
          FocusScope.of(context).requestFocus(email.state.focus);
        });
      },
    );
    country = BrDropdown(icon: 'lib/assets/flares/globe_icon.flr',);
  }
}