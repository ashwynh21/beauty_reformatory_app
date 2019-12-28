import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/services/controllers/message_controller.dart';
import 'package:beautyreformatory/services/middleware/emotion_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrChatInput extends StatefulWidget {
  String value;
  User user;

  void Function(BrChatInput, String) submit, change, tap;
  void Function(BrChatInput, Message) sent;

  BrChatInput({Key key,
    @required this.user,
    @required this.submit,
    @required this.change,
    @required this.tap,
    @required this.sent,
    this.value,
  }) : super(key: key);

  @override
  _BrChatInputState createState() => _BrChatInputState();
}

class _BrChatInputState extends State<BrChatInput> {
  TextEditingController _controller;
  bool _enabled = false;

  int _duration = 400;
  Curve curve = Curves.easeOutCubic;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.value);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _duration),
      width: MediaQuery.of(context).size.width,
      bottom: 0,

      child: Container(
        child:
        /*
        The text input field is here
         */
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Material(
                borderRadius: BorderRadius.circular(24),
                elevation: 4,
                shadowColor: Colors.black26,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: _duration),
                    curve: curve,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width - (
                        (_enabled)
                            ?
                        80
                            :
                        0),

                    child: Container(
                      margin: EdgeInsets.all(4),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
//                              Container(
//                                child: SizedBox(
//                                  width: 40,
//                                  height: 40,
//                                  child: FutureBuilder<Emotion>(
//                                      future: EmotionMiddleware.firstFromSave(),
//                                      builder: (context, emotion) {
//                                        if(emotion.hasData)
//                                          return Tooltip(
//                                            waitDuration: Duration.zero,
//                                            decoration: BoxDecoration(
//                                                color: resources.colors.primary.withOpacity(0.32),
//                                                borderRadius: BorderRadius.circular(4)
//                                            ),
//                                            message: 'emoji keypad',
//                                            textStyle: TextStyle(
//                                                color: Colors.white
//                                            ),
//
//                                            child: Material(
//                                                borderRadius: BorderRadius.circular(20),
//                                                child: InkWell(
//                                                  onTap: () {
//                                                    /*
//                                                        Here we will popup the emoji keyboard of the device
//                                                         */
//                                                  },
//                                                  borderRadius: BorderRadius.circular(20),
//
//                                                  child: Container(
//                                                      alignment: Alignment.center,
//                                                      padding: EdgeInsets.all(8),
//                                                      child: Text(emotion.data.mood,
//                                                        style: TextStyle(
//                                                          fontSize: 16,
//                                                        ),
//                                                        textAlign: TextAlign.center,
//                                                      )
//                                                  ),
//                                                )
//                                            ),
//                                          );
//
//                                        return Container();
//                                      }
//                                  ),
//                                ),
//                              ),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: _duration),
                                  curve: curve,
                                  transform: Matrix4.identity()..translate((
                                      (_enabled)
                                          ?
                                      36.0
                                          :
                                      0.0), 0.0, 0.0),

                                  child: Row(
                                    children: <Widget>[
                                      Tooltip(
                                        waitDuration: Duration.zero,
                                        decoration: BoxDecoration(
                                            color: resources.colors.primary.withOpacity(0.32),
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        message: 'attach media file',
                                        textStyle: TextStyle(
                                            color: Colors.white
                                        ),

                                        child: BrIcon(
                                            src: 'lib/interface/assets/icons/attach.svg',
                                            color: resources.colors.primary,

                                            click: (_) {

                                            }
                                        ),
                                      ),

                                      AnimatedOpacity(
                                        duration: Duration(milliseconds: _duration),
                                        curve: curve,
                                        opacity: (
                                            (_enabled)
                                                ?
                                            0.0
                                                :
                                            1.0),

                                        child: Tooltip(
                                          waitDuration: Duration.zero,
                                          decoration: BoxDecoration(
                                              color: resources.colors.primary.withOpacity(0.32),
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          message: 'take a picture',
                                          textStyle: TextStyle(
                                              color: Colors.white
                                          ),

                                          child: BrIcon(
                                              src: 'lib/interface/assets/icons/camera.svg',
                                              color: resources.colors.primary,

                                              click: (_) {

                                              }
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 16, right: 40 + ((_enabled)
                                ?
                            0.0
                                :
                            40.0)),
                            child: ConstrainedBox(
                              constraints: new BoxConstraints(
                                maxHeight: 96.0,
                              ),

                              child: NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowGlow();
                                  return true;
                                },
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: TextField(
                                    controller: _controller,
                                    cursorColor: resources.colors.primary,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hasFloatingPlaceholder: false,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(bottom: 10),
                                        hintText: 'type a message',
                                        hintStyle: TextStyle(
                                            color: resources.colors.primary.withOpacity(0.32)
                                        )
                                    ),

                                    onTap: () {
                                      widget.tap(widget, _controller.value.text);
                                    },
                                    onChanged: (value) {
                                      widget.change(widget, value);
                                      _enabled = _controller.value.text != null && _controller.value.text.length > 0;

                                      /*
                                          When the state sets we must then call a future function to
                                          sort fof create a completion listener for the animations so that
                                          we can trigger some reorganization function.
                                           */
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              left: MediaQuery.of(context).size.width - (
                  (_enabled)
                      ?
                  56
                      :
                  0),
              bottom: 15,
              duration: Duration(milliseconds: _duration),
              curve: curve,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: _duration),
                curve: curve,
                opacity: (
                    (_enabled)
                        ?
                    1.0
                        :
                    0.0),
                child: BrIconButton(
                    src: 'lib/interface/assets/icons/send.svg',
                    size: 42,
                    color: Colors.white,
                    background: resources.colors.primary,
                    padding: 12.5,
                    click: (view) {
                      /*
                          Here we have the logic that allows us to send messages to
                          the given friend in the chat.

                          A small snap that has been encountered is that we are unable
                          to generate message id's on the client application. In the
                          sense that we have ruled out creating id's on the client application.

                          Now we need a way of storing the users message before sending
                          it and still be able to update the message once it has been
                          sent. One strategy that can be performed is to make an
                          exception and generate the ID within the model structure or
                          more specifically, the constructor and have an appropriate
                          and equivalent function as the server side function to
                          generate the ID.
                           */

                      sendmessage(_controller.value.text).then((Message message) {
                        /*
                        With the message stored onto the device all we need to do
                        here is make sure the UI reacts to the message being
                        completely processed.
                         */

                        /*
                        call sent callback here
                         */
                        widget.sent(widget, message);
                        setState(() {});
                      });
                      _controller.value = TextEditingValue(text: '');
                      setState(() {
                        _enabled = _controller.value.text != null && _controller.value.text.length > 0;
                      });
                      FocusScope.of(context).requestFocus(FocusNode());

                      widget.submit(widget, '');
                    }
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Future<Message> sendmessage(String message) async {
    User u = (await UserMiddleware.fromSave());

    return MessageController().send(
      message: message,
      email: u.email,
      token: u.token,
      friend: widget.user.email
    );
  }
}