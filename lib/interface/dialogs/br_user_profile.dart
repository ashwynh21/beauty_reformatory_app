import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/screens/house/image/image_viewer.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrUserProfile extends StatefulWidget {
  String image, id, fullname, email;
  int state;
  Future Function(BrUserProfile) right;
  Future Function(BrUserProfile) left;
  Future Function(BrUserProfile, String value) report;

  BrUserProfile({Key key,
    @required this.image,
    @required this.id,
    @required this.fullname,
    @required this.email,
    @required this.right,
    @required this.report,
    @required this.state,
    @required this.left,
  }) : super(key: key);

  @override
  _BrUserProfileState createState() => _BrUserProfileState();
}

class _BrUserProfileState extends State<BrUserProfile> {
  StreamController<bool> load = new StreamController();

  @override
  void initState() {
    initinput();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: GestureDetector(
        onTap: () {
          unloadinput();
        },
        child: Material(
          color: Colors.transparent,

          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
            GestureDetector(
              onTap: () {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.black,
                  systemNavigationBarColor: Colors.black,
                ));

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, __, ___) => ImageViewer(
                      title: widget.fullname,
                      src: widget.image,
                      hero: widget.id,
                      controls: false,
                      callback: (view, source, remove) async {

                      },
                    ),
                    transitionDuration: Duration(milliseconds: 440),
                  ),
                );
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    width: 256,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Hero(
                          tag: widget.id,
                          child:
                          Container(
                            width: 256,
                            height: 280,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.memory(base64Decode(widget.image)).image
                                )
                            ),
                          ),
                        ),
                        StreamBuilder(
                          initialData: false,
                          stream: load.stream,
                          builder: (context, snapshot) {
                            return AnimatedOpacity(
                              duration: Duration(milliseconds: 256),
                              opacity: (snapshot.data) ? 1: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    color: Colors.black26,
                                    padding: EdgeInsets.only(left: 16),

                                    child: Text(widget.fullname,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 44,
                                      color: Colors.white,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Container(
                                              child: BrIcon(
                                                src: (widget.state == pending || widget.state == accepted)
                                                    ?
                                                'lib/interface/assets/icons/chat.svg'
                                                    :
                                                (widget.state == unapproved)
                                                    ?
                                                'lib/interface/assets/icons/confirm.svg'
                                                    :
                                                'lib/interface/assets/icons/add.svg',
                                                color: resources.colors.primary,
                                                click: (view) {
                                                  if(widget.state == pending || widget.state == accepted) {
                                                    unloadinput().then((_) => widget.left(widget));
                                                  } else {
                                                    widget.left(widget).whenComplete(() => unloadinput());
                                                  }
                                                },
                                              )
                                          ),
                                          Container(
                                              child: BrIcon(
                                                src: 'lib/interface/assets/icons/report.svg',
                                                color: resources.colors.primary,
                                                click: (view) {
                                                  /*
                                                  In this function we will setup a dialog that will allow the user to describe
                                                  the report they would like to make on the user that is in the search result.
                                                   */
                                                  dialogs.editfield(context,
                                                    placeholder: 'description',
                                                    value: '',
                                                    instruction: 'Report Abuse',
                                                    submit: 'REPORT',
                                                    icon: 'lib/interface/assets/icons/abuse.svg',

                                                    callback: (view, value) async {
                                                      widget.report(widget, value).whenComplete(() => unloadinput());
                                                    }
                                                  );
                                                },
                                              )
                                          ),
                                          Container(
                                              child: BrIcon(
                                                src: (widget.state == pending) ? 'lib/interface/assets/icons/close.svg' : 'lib/interface/assets/icons/block.svg',
                                                color: resources.colors.primary.withOpacity((widget.state == blocked) ? 0.24 : 1),
                                                click: (view) {
                                                  /*
                                                  This button will be responsible for initiating a confirmation dialog
                                                  that will ask the user if they are sure if they want to block the given
                                                  user. We have the email of the user in the widget so that we can send it
                                                  to the server.

                                                  However we must set the normal model, middleware and controller of the system
                                                  before we actually submit the request for processing.
                                                 */
                                                  widget.right(widget).whenComplete(() => unloadinput());
                                                },
                                              )
                                          ),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            );
                          }
                        )
                      ],
                    ),
                  )
              ),
            ),
            ],
          )
        ),
      ),
    );
  }

  Future initinput() {
    return Future.delayed(Duration(milliseconds: 256), () {
      load.sink.add(true);
    });
  }
  Future unloadinput() {
    load.sink.add(false);

    return Future.delayed(Duration(milliseconds: 128), () {
      Navigator.of(context).pop();
    });
  }
}