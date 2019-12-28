import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/interface/screens/house/elements/conversation_results.dart';
import 'package:beautyreformatory/interface/screens/house/elements/people_results.dart';
import 'package:beautyreformatory/interface/screens/house/elements/posts_results.dart';
import 'package:beautyreformatory/interface/screens/house/elements/search_input.dart';
import 'package:beautyreformatory/interface/screens/house/elements/status_bar.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String search_value;

  StreamController people_stream = new StreamController<List<Map>>(),
      converstation_stream = new StreamController<List<Map>>(),
      posts_stream = new StreamController<List<Map>>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(top: 128),

                  child: Column(
                    children: <Widget>[
                      /*
                      People results will go in this container
                       */
                      PeopleResults(
                          stream: people_stream.stream,
                      ),

                      /*
                      Chat results will go here
                       */
                      ConversationResults(
                        stream: converstation_stream.stream,
                      ),
                      /*
                      Posts will go here
                       */
                      PostsResults(
                        stream: posts_stream.stream,
                      ),
                    ],
                  )
              ),
            ),
            SearchInput(
                change: (view, value) {
                  search_value = value;
                },
                submit: (view, value) {
                  search_value = value;
                  if(value.length > 0) {
                    dialogs.loader.show(true);
                    UserMiddleware.fromSave().then((User user) {
                      UserController().find(email: user.email, token: user.token, find: value).then((List<Map> results) {

                        people_stream.sink.add(results);
                      }).catchError((error) {
                        dialogs.snack.show(error.message);
                      }).whenComplete(() => dialogs.loader.show(false));
                    });
                  }
                }
            ),
            StatusBar(),

            dialogs.loader,
            dialogs.snack,
          ],
        ),
      ),
    );
  }
}