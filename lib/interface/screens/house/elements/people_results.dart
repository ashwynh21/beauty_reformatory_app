import 'package:beautyreformatory/interface/screens/house/elements/friends.dart';
import 'package:beautyreformatory/interface/screens/house/elements/user_list_item.dart';
import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';

class PeopleResults extends StatelessWidget {
  Stream<List<Map>> stream;

  PeopleResults({Key key,
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData)
            return Container(
              width: double.infinity,

              child: Column(
                children: <Widget>[
                  Container(
                      height: 36,
                      color: resources.colors.primary.withOpacity(0.64),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Text('people',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                  Container(height: 1, width: double.infinity, color: Colors.white),
                  Container(
                    child: Column(
                      children: (snapshot.data as List<Map>).map((m) {
                        return UserListItem(
                          state: m['state'],
                          user: User.fromJson(m),
                          callback: (view) => _initfriends(),
                        );
                      }).toList(),
                    )
                  )
                ],
              ),
            );
          return Container();
        },
      );
  }
  void _initfriends() {
    UserMiddleware.fromSave().then((User u) {
      FriendshipMiddleware.listFromSave().then((List<Friendship> list) {
        Friends.friends_controller.sink.add(list);
      });
    });
  }
}
