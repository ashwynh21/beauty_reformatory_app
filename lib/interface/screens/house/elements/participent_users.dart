import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/services/controllers/bookmark_controlller.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/bookmark.dart';
import 'package:beautyreformatory/services/models/article.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';

class ParticipentUsers extends StatefulWidget {
  Article article;
  User user;
  ParticipentUsers({key: Key,
    @required this.article,
    @required this.user,
  });

  @override
  State<StatefulWidget> createState() => new _ParticipentUsersState();
}

class _ParticipentUsersState extends State<ParticipentUsers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: BookmarkController().get(email: widget.user.email, token: widget.user.token, article: widget.article.id),
          builder: (BuildContext context, AsyncSnapshot<List<Bookmark>> participants) {
            if(participants.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: (participants.data).map((f) {
                        return Transform.translate(
                          offset: Offset(20.0 * (participants.data.indexOf(f)), 0),

                          child: FutureBuilder(
                              future: UserController().getuserprofile(email: widget.user.email, token: widget.user.token, user: f.user),
                              builder: (context, profile) {
                                if(profile.hasData) {

                                  return BrAvatar(
                                    src: profile.data.image,
                                    elevation: 2,
                                    frame: 4,
                                    stroke: Colors.white,
                                    size: 32,
                                    radius: 16,
                                  );
                                }
                                return Container();
                              }
                          ),
                        );
                      }).toList().sublist(0, participants.data.length > 4 ? 4 : participants.data.length)
                  ),
                  Container(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text( participants.data.length.toString() + ' participent' + (participants.data.length > 1 ? 's': ''),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              )
                          ),
                        ],
                      )
                  )
                ],
              );
            }
            return Container();
          }
      ),
    );
  }
}