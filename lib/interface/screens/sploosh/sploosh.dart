import 'package:beautyreformatory/interface/elements/background.dart';
import 'package:beautyreformatory/interface/screens/sploosh/login/login.dart';
import 'package:beautyreformatory/interface/screens/sploosh/recover/recover.dart';
import 'package:beautyreformatory/interface/screens/sploosh/signup/signup.dart';
import 'package:beautyreformatory/interface/screens/sploosh/welcome/welcome.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:flutter/material.dart';

class Sploosh extends StatefulWidget {
  _SplooshState state;

  Sploosh({Key key}) : super(key: key);

  @override
  _SplooshState createState() {
    state = _SplooshState();
    return state;
  }
}

class _SplooshState extends State<Sploosh> {
  PageController controller;

  Background background;

  @override
  void initState() {
    background = new Background(
      onchange: (String animation) {
        controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      },
    );
    controller = new PageController(initialPage: 1,);

    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,

        children: <Widget>[
          background,

          PageView.builder(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,

            itemBuilder: (context, index) {
              List<Widget> pages = <Widget>[
                Recover(
                  back: () async {
                    controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                    return false;
                  },
                  login: (view) {
                    controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  }
                ),

                Container(),
                Login(
                  recover: (view) {
                    controller.animateToPage(0, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  },
                  signup: (view) {
                    controller.animateToPage(3, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  },
                ),
                Signup(
                  back: () async {
                    controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                    return false;
                  },
                  login: (view) {
                    controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  },
                  success: (view) {
                    controller.animateToPage(4, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  },
                ),
                Welcome(
                  done: (view) {
                    Navigator.of(context).pushReplacementNamed('/house');
                  }
                )
              ];
              return pages[index];

            }
          ),

          snack,
          loader,
        ],
      ),
    );
  }
}