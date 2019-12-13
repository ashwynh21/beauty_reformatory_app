import 'package:beautyreformatory/interface/components/br_slider_input.dart';
import 'package:beautyreformatory/services/controllers/emotion_controller.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class EmotionsRating extends StatelessWidget {
  Emotion emotion;

  EmotionsRating({Key key,
    @required this.emotion,
  }) : super(key: key);

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
                      child: Row(
                        children: <Widget>[

                          FutureBuilder<Object>(
                            future: resources.files.preload(context),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.done) {
                                return BrSliderInput(
                                    value: (emotion != null) ? emotion.mood : resources.files.emojis[0]['char'],
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
                              }

                              return Container();
                            }
                          ),

                        ],
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