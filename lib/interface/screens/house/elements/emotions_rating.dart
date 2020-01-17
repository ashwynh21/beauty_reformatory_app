import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/components/br_slider_input.dart';
import 'package:beautyreformatory/services/controllers/emotion_controller.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class EmotionsRating extends StatefulWidget {
  Emotion emotion;

  EmotionsRating({Key key,
    @required this.emotion,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _EmotionsRatingState();

}

class _EmotionsRatingState extends State<EmotionsRating> {
  List<dynamic> emojis;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,

        child: FutureBuilder(
          future: resources.files.preload(context).then((value) {
            emojis = resources.files.emojis;
          }),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return Container(
                height: 138,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('feel-o-meter',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              fontFamily: 'Handlee',
                              color: resources.colors.primary,
                              letterSpacing: 1.2,
                            ),

                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Tooltip(
                                waitDuration: Duration.zero,
                                decoration: BoxDecoration(
                                    color: resources.colors.primary.withOpacity(0.32),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                message: 'describe how you feel with one emoji.',
                                textStyle: TextStyle(
                                    color: Colors.white
                                ),
                                child: BrIcon(
                                  src: 'lib/interface/assets/icons/status.svg',
                                  color: Colors.black26,
                                  click: (view) {},
                                )
                            )
                        ),
                      ],
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

                                BrSliderInput(
                                    value: (widget.emotion != null) ? widget.emotion.mood : emojis[0]['char'],
                                    length: emojis.length - 1,
                                    emojis: emojis,
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
                                ),

                              ],
                            )
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          }
        )
    );
  }
}