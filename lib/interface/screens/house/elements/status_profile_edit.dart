import 'package:beautyreformatory/interface/screens/house/elements/status_update.dart';
import 'package:beautyreformatory/services/middleware/emotion_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:flutter/material.dart';

import 'emotions_rating.dart';

class StatusProfileEdit extends StatefulWidget {
  StatusProfileEdit({Key key}) : super(key: key);

  @override
  _StatusProfileEditState createState() => _StatusProfileEditState();
}

class _StatusProfileEditState extends State<StatusProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(top: 320),
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: UserMiddleware.fromSave(),
                  builder: (context, user) {
                    if(user.hasData){
                      return StatusUpdate(
                        user: user.data,
                      );
                    }

                    return Container();
                  }
              ),

              FutureBuilder(
                  future: EmotionMiddleware.firstFromSave(),
                  builder: (context, emotion) {
                    return EmotionsRating(
                      emotion: emotion.data,
                    );
                  }
              )
            ],
          )
      ),
    );
  }
}