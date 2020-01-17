import 'package:beautyreformatory/services/controllers/image_controller.dart';
import 'package:beautyreformatory/services/controllers/video_controller.dart';
import 'package:beautyreformatory/services/models/article.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';

class MediaCount extends StatefulWidget {
  User user;
  Article article;
  MediaCount({Key key,
    @required this.user,
    @required this.article
  }) : super(key: key);

  @override
  _MediaCountState createState() => _MediaCountState();
}

class _MediaCountState extends State<MediaCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 104,
        child: FutureBuilder<int>(
            future: ImageController().count(email: widget.user.email, token: widget.user.token, article: widget.article.id),
            builder: (context, images) {
              if(images.connectionState == ConnectionState.done) {
                return FutureBuilder<int>(
                    future: VideoController().count(email: widget.user.email, token: widget.user.token, article: widget.article.id),
                    builder: (context, videos) {
                      if(videos.hasData) {

                        return Text(
                          (images.data + videos.data > 0) ? '+' + (images.data + videos.data).toString() + ' images & videos' : 'no media',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: (images.data + videos.data > 0) ? TextAlign.left : TextAlign.end,
                        );
                      }
                      return Container();
                    }
                );
              }
              return Container();
            }
        )
    );
  }
}