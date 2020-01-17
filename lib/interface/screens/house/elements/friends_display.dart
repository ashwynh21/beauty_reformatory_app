import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:flutter/material.dart';

class FriendsDisplay extends StatelessWidget {
  User user;

  FriendsDisplay({Key key,
    @required this.user
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: (FriendshipMiddleware.listFromSave()),
        builder: (BuildContext context, AsyncSnapshot<List<Friendship>> friendships) {
          if(friendships.connectionState == ConnectionState.done && friendships.hasData) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: (friendships.data..removeWhere((e) => (
                        e.state == removed ||
                        e.state == cancelled ||
                        e.state == pending ||
                        e.state == blocked
                      ))).map((f) {
                        if(f.initiator.id != user.id) {
                          return Transform.translate(
                            offset: Offset(16 + 20.0 * - (friendships.data.indexOf(f)), 0),

                            child: BrAvatar(
                              src: f.initiator.image,
                              elevation: 2,
                              frame: 4,
                              stroke: Colors.white,
                              size: 32,
                              radius: 16,
                            ),
                          );
                        } else {
                          return Transform.translate(
                            offset: Offset(16 + 20.0 * - (friendships.data.indexOf(f)), 0),

                            child: BrAvatar(
                              src: f.subject.image,
                              elevation: 4,
                              size: 32,
                              frame: 4,
                              stroke: Colors.white,
                              radius: 16,
                            ),
                          );
                        }
                      }).toList().sublist(0, friendships.data.length > 4 ? 4 : friendships.data.length)
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24),
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (friendships.data.length > 0) ?
                          Text(friendships.data.length.toString(),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              )
                          )
                              : Container(),
                          Text((friendships.data.length > 0) ? 'in circles' : 'none in circles',
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
              ),
            );
          }
          return Container();
        }
    );
  }
}
