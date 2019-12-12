import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_slider_input.dart';
import 'package:beautyreformatory/services/controllers/emotion_controller.dart';
import 'package:beautyreformatory/services/middleware/emotion_middleware.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class EmotionsRating extends StatefulWidget {
  EmotionsRating({Key key}) : super(key: key);

  @override
  _EmotionsRatingState createState() => _EmotionsRatingState();
}

class _EmotionsRatingState extends State<EmotionsRating> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      child: Container(
        height: 136,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('feel-o-meter',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                fontFamily: 'Jandys Dua',
                color: resources.colors.primary,
                letterSpacing: 1.2,
              ),

            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: Offset(0, 2)
                  )
                ],
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white
              ),

              child: Container(
                height: 72,
                child: Container(
                  child: FutureBuilder(
                    future: resources.files.preload(context),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.done)
                        return Row(
                          children: <Widget>[

                            FutureBuilder(
                              future: EmotionMiddleware.listFromSave(),
                              builder: (BuildContext context, AsyncSnapshot<List<Emotion>> emotions) {

                                return BrSliderInput(
                                    value: (emotions.hasData && emotions.data != null && emotions.data.length > 0) ? emotions.data[0].mood : resources.files.emojis[0]['char'],
                                    length: resources.files.emojis.length - 1,
                                    emojis: resources.files.emojis,
                                    complete: (view, value) async {
                                      /*
                                      Here we will then initiate the callback that will allow the upload of
                                      the emotion to occur.
                                       */
                                      Future.delayed(Duration(seconds: 2), () async {
                                        await EmotionController().create(
                                          mood: value,
                                        );
                                      });
                                    }
                                );
                              },
                            ),

                          ],
                        );

                      return Container(

                      );
                    },
                  )
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}