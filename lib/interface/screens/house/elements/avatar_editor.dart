import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/dialogs/br_select_image_source_dialog.dart';
import 'package:beautyreformatory/interface/screens/house/image/image_viewer.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class AvatarEditor extends StatefulWidget {
  User user;

  AvatarEditor({Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _AvatarEditorState createState() => _AvatarEditorState();
}

class _AvatarEditorState extends State<AvatarEditor> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context, __, ___) => ImageViewer(
                  title: 'Profile picture',
                  src: widget.user.image,
                  hero: 'avatar',
                  callback: (view, source, remove) async {
                    setState(() {
                      loader.show(true);
                    });

                    (DefaultAssetBundle.of(context).load('lib/interface/assets/images/default_avatar.png')).then((data) {
                      widget.user.image = (remove) ? base64Encode(data.buffer.asUint8List()) : source;

                      UserController().update(
                        email: widget.user.email,
                        token: widget.user.token,
                        image: (remove) ? '' : widget.user.image,
                      ).then((User user) async {
                        if(user != null){
                          snack.show('Hey, your profile has been updated!');
                          setState(() {
                            widget.user = user;
                            loader.show(false);
                          });
                        }
                      }).catchError((error) {
                        snack.show(error.message);
                        setState(() {
                          loader.show(false);
                        });
                      });
                    });
                  },
                ),
                transitionDuration: Duration(milliseconds: 440),
              ),
            );
          },
          child: BrAvatar(
            src: widget.user.image,
            elevation: 4,
            size: 128,
            radius: 64,
            frame: 8,
            hero: 'avatar',
            stroke: resources.colors.light.withOpacity(0.64),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          child: BrIconButton(
            src: 'lib/interface/assets/icons/camera.svg',
            color: Colors.white,
            background: resources.colors.secondary,
            padding: 10,
            click: (view) {

              dialogs.selectsource(context,
                  title: 'Profile picture',
                  callback: (BrSelectImageSourceDialog dialog, String source, bool remove) async {
                    setState(() {
                      loader.show(true);
                    });

                    (DefaultAssetBundle.of(context).load('lib/interface/assets/images/default_avatar.png')).then((data) {
                      widget.user.image = (remove) ? base64Encode(data.buffer.asUint8List()) : source;

                      UserController().update(
                        email: widget.user.email,
                        token: widget.user.token,
                        image: (remove) ? '' : widget.user.image,
                      ).then((User user) async {
                        if(user != null){
                          snack.show('Hey, your profile has been updated!');
                          setState(() {
                            widget.user = user;
                            loader.show(false);
                          });
                        }
                      }).catchError((error) {
                        snack.show(error.message);
                        setState(() {
                          loader.show(false);
                        });
                      });
                    });
                  }
              );

            },
          ),
        )
      ],
    );
  }
}