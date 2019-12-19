import 'dart:convert';
import 'dart:io';

import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/dialogs/br_confirm_operation.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';

class ImageViewer extends StatefulWidget {
  bool selected, controls;
  String hero, src, title;
  Future Function(ImageViewer, String source, bool remove) callback;

  ImageViewer({Key key,
    @required this.src,
    @required this.title,
    this.hero,
    this.callback,
    this.selected = false,
    this.controls = true,
  }) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ));
    super.initState();
  }
  @override
  void didChangeDependencies() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ));
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: resources.colors.primary,
      systemNavigationBarColor: resources.colors.primary,
    ));
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        actions:
        (widget.controls)
        ?
        <Widget>[BrIcon(
          src: 'lib/interface/assets/icons/camera.svg',
          color: Colors.white,
          click: (view) {
            imageselector(ImageSource.camera);
          },
        ),
          BrIcon(
            src: 'lib/interface/assets/icons/gallery.svg',
            color: Colors.white,
            click: (view) {
              imageselector(ImageSource.gallery);
            },
          ),
          Container(
            margin: EdgeInsets.only(right: 12),
            child:
            BrIcon(
              src: 'lib/interface/assets/icons/bin.svg',
              color: Colors.white,
              click: (view) {
                dialogs.confirmoperation(context,
                    message: 'Remove Profile Picture',
                    callback: (BrConfirmOperation dialog, bool confirmed) async {
                      widget.callback(widget, widget.src, confirmed);
                      Navigator.pop(context);
                    }
                );
              },
            ),
          ),
        ]
        :
        <Widget>[Container()],
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,

        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,

              child:
              (widget.hero == null)
                  ?
              Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.transparent,

                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,

                    child: PhotoView(
                      imageProvider: MemoryImage(base64Decode(widget.src)),
                    ),
                  )
              )
                  :
              Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(0),
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black,

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                        alignment: Alignment.center,
                        child: herowidget(),
                      ),
                    ),
                  ),
                ),
              )
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 256),
              transform: Matrix4.identity()..translate(0.0, (widget.selected) ? 0 : 128.0, 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                color: Colors.black,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 32),
                      child: MaterialButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('CANCEL',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 32),
                      child: MaterialButton(
                        onPressed: () {
                          widget.callback(widget, widget.src, false).then((value) {
                            Navigator.pop(context);
                          }).catchError((error) {
                            Navigator.pop(context);

                            throw error;
                          });
                        },
                        child: Text('DONE',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              )
            )
          ],
        )
      ),
    );
  }

  Hero herowidget() {
    return Hero(
      tag: widget.hero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: PhotoView(
          imageProvider: MemoryImage(base64Decode(widget.src)),
          minScale: 0.32,
          maxScale: 1.8,
        ),
      ),
    );
  }

  Future<String> imageselector(ImageSource source) async {
    try{
      widget.src = base64Encode((await imagecropper((await ImagePicker.pickImage(source: source)).path)
        .then((value) {

        this.setState(() {
          if(widget.src != null)
            widget.selected = true;
        });

        return value;
      })).readAsBytesSync());
    } catch(e) {

    }

    return widget.src;
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
}