import 'package:beautyreformatory/elements/background.dart';
import 'package:beautyreformatory/elements/login.dart';
import 'package:beautyreformatory/elements/signup.dart';
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
        controller.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      },
    );
    controller = new PageController();

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
            itemCount: 3,

            itemBuilder: (context, index) {
              List<Widget> pages = <Widget>[
                Container(),
                Login(
                  signup: (view) {
                    controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  },
                ),
                Signup(
                  back: () async {
                    controller.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                    return false;
                  },
                  login: (view) {
                    controller.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                  }
                ),
              ];
              return pages[index];

            }
          )
        ],
      ),
    );
  }
}