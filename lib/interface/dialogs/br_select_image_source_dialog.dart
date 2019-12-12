import 'dart:convert';
import 'dart:io';

import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/dialogs/br_confirm_operation.dart';
import 'package:beautyreformatory/interface/screens/house/image/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';

class BrSelectImageSourceDialog extends StatefulWidget {
  String title;
  Future Function(BrSelectImageSourceDialog, String, bool) callback;

  BrSelectImageSourceDialog({Key key,
    @required this.title,
    @required this.callback,
  }) : super(key: key);

  @override
  _BrSelectImageSourceDialogState createState() => _BrSelectImageSourceDialogState();
}

class _BrSelectImageSourceDialogState extends State<BrSelectImageSourceDialog> {
  String src;
  bool loadin = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ));
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    load();

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        return unload().then((value) {
          Navigator.of(context).pop();
          return false;
        });
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            return unload().then((value) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                statusBarColor: resources.colors.primary,
                systemNavigationBarColor: resources.colors.primary,
              ));
              Navigator.of(context).pop();
              return false;
            });
          },
          child: Material(
            color: Colors.black.withOpacity(0.64),

            child: AnimatedContainer(
              duration: Duration(milliseconds: 245),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()..translate(0.0, (loadin) ? 0.0 : 212, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                      color: Colors.transparent,

                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 16, left: 24),
                        child: Text(widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 128,


                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),

                        child: Container(
                          color: Colors.white,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              /*
                                Buttons are here
                                 */
                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            BrIconButton(
                                                src: 'lib/interface/assets/icons/gallery_source.svg',
                                                size: 64,
                                                click: (view) {
                                                  imageselector(ImageSource.gallery);
                                                }
                                            ),
                                            Text(
                                              'gallery',
                                              style: TextStyle(
                                                fontSize: 11,
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                    Container(

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            BrIconButton(
                                                src: 'lib/interface/assets/icons/camera_source.svg',
                                                size: 64,
                                                click: (view) {
                                                  imageselector(ImageSource.camera);
                                                }
                                            ),
                                            Text(
                                              'camera',
                                              style: TextStyle(
                                                fontSize: 11,
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                    Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            BrIconButton(
                                                src: 'lib/interface/assets/icons/remove.svg',
                                                size: 64,
                                                click: (view) {

                                                  dialogs.confirmoperation(context,
                                                      message: 'Remove Profile Picture',
                                                      callback: (BrConfirmOperation dialog, bool confirmed) async {
                                                        Navigator.pop(context);
                                                        widget.callback(widget, '', confirmed).then((value) {
                                                          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                                                            statusBarColor: resources.colors.primary,
                                                            systemNavigationBarColor: resources.colors.primary,
                                                          ));

                                                          return value;
                                                        });
                                                      }
                                                  );
                                                }
                                            ),
                                            Text(
                                              'remove picture',
                                              style: TextStyle(
                                                fontSize: 11,
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  /*
                This padding is for lifting the widget when you open the keyboard
                 */
                  Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void imageselector(ImageSource source) async {
    try{
      src = base64Encode((await imagecropper((await ImagePicker.pickImage(source: source)).path)).readAsBytesSync());

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, __, ___) => ImageViewer(
            title: 'Profile picture',
            src: src,
            selected: true,
            callback: (view, source, remove) async {
              widget.callback(widget, source, remove);
            },
          ),
          transitionDuration: Duration(milliseconds: 400),
        ),
      );

    } catch(e) {

    }

    this.setState(() {});
  }
  Future<File> imagecropper(String path) async {
    return await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.original,
        ],
        compressQuality: 100,
        maxHeight: 768,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: widget.title,
          toolbarColor: Colors.black,
          activeControlsWidgetColor: resources.colors.primary,
          activeWidgetColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
  }

  void load() {
    Future.delayed(Duration(milliseconds: 80), () {
      setState(() {
        loadin = true;
      });
    });
  }
  Future unload() async {
    setState(() {
      loadin = false;
    });
    return Future.delayed(Duration(milliseconds: 256), () async {
    });
  }
}