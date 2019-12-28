import 'package:beautyreformatory/interface/components/br_button.dart';
import 'package:beautyreformatory/interface/components/br_input.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class Recover extends StatefulWidget {
  Future<bool> Function() back;
  void Function(Recover) login;

  Recover({Key key,
    this.back,
    this.login
  }) : super(key: key);

  @override
  _RecoverState createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {
  // input components
  BrInput username;
  BrButton submit;

  @override
  void initState() {
    _inputinit();

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
                  // Title
                  Container(
                      child: Text('Forgot password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Segoe UI',
                          color: resources.colors.dark,
                        ),
                      )
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 24,),
                    child: Text('Hi there 👋, if you have forgotten your account password, drop your email in the field below and we will send you a recovery link to get your account back.',
                        style: TextStyle(
                          color: resources.colors.primary,
                          fontSize: 12,
                          height: 1.8,
                        )
                    )
                  ),

                  // Form Interface
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 48,),

                    child: username,
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
                              onTap: () => widget.login(widget),
                              child: Wrap(
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text('manage to remember?',
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
                ],
              )
          ),
        ),
      ),
    );
  }

  /*
   * This function will be used to initialize the input components for the logging
   * in form.
   */
  void _inputinit() {
    username = BrInput(placeholder: 'username / email address',
      icon: 'lib/interface/assets/flares/avatar_icon.flr',
      type: TextInputType.emailAddress,
      action: TextInputAction.done,
      submit: (view, value) {

      },
    );
    submit = BrButton(
        title: 'recover',
        color: Colors.white,
        background: resources.colors.primary,
        click: (view) async {
          dialogs.loader.show(true);
          (new UserController()).
          recover(email: username.value).
          then((String message) {
            dialogs.loader.show(false).then((value){
              if(message != null) {
                dialogs.snack.show(message);
                widget.login(widget);
              }
            });
          }).catchError((error) {
            dialogs.snack.show(error.message);
            dialogs.loader.show(false);
          });
        }
    );
  }
}