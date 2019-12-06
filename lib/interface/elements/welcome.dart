import 'package:beautyreformatory/interface/components/br_button.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class Welcome extends StatelessWidget {
  void Function(Welcome) done;

  Welcome({
    @required this.done
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 56, right: 56),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[
                // Title
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Welcome to the ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: 'Segoe UI',
                            color: resources.colors.dark,
                          ),
                        ),
                        Text('BR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: 'Segoe UI',
                            color: resources.colors.primary,
                          ),
                        ),
                        Text('!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: 'Segoe UI',
                            color: resources.colors.dark,
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Text('Hey there 👋, thanks for signing up to the beauty reformatory, get ready for the best social treatment tailored for you! To finish signing up please check your email for a verification link.',
                        style: TextStyle(
                          color: resources.colors.primary,
                          fontSize: 12,
                          height: 1.6,
                        )
                    )
                ),

                Container(
                    margin: EdgeInsets.only(top: 32),

                    child: BrButton(
                        title: 'done',
                        color: Colors.white,
                        background: resources.colors.primary,
                        click: (view) => done(this)
                    )
                ),

              ],
            )
        ),
      ),
    );
  }
}
