import 'dart:convert';
import 'dart:io';

import 'package:beautyreformatory/interface/screens/house/house.dart';
import 'package:beautyreformatory/interface/screens/house/messaging/messaging.dart';
import 'package:beautyreformatory/interface/screens/sploosh/sploosh.dart';
import 'package:beautyreformatory/services/controllers/article_controller.dart';
import 'package:beautyreformatory/services/controllers/emotion_controller.dart';
import 'package:beautyreformatory/services/controllers/friendship_controller.dart';
import 'package:beautyreformatory/services/controllers/message_controller.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget widget = new Sploosh();
  /*
  We then configure the static initializations of the application such as the
  status bar here.
   */

  if((await BeautyReformatory.initapp().catchError((error) => null)) != null)
    widget = new House();
  /*
  (await SharedPreferences.getInstance()).clear();
   */
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: resources.colors.primary,
    systemNavigationBarColor: resources.colors.primary,
  ));
  resources.flares.preload();

  return runApp(BeautyReformatory(home: widget));
}

class BeautyReformatory extends StatefulWidget {
  _BeautyReformatoryState state;

  Widget home;
  FirebaseMessaging _firebase;

  BeautyReformatory({@required this.home});

  @override
  State<StatefulWidget> createState() {
    state = _BeautyReformatoryState();
    return state;
  }

  /*
  Placing an application initialization function at this location to be a static
  function for the rest of the application because we need to collect user data
  at intervals of the application such as signing or signing up

  currently the user has to restart the application in order to trigger the
  functionality that we require from the application.
   */
  static Future<User> initapp() async {
    User user = await UserMiddleware.fromSave();
    if(user == null) {
      throw AuthorizationException('Oops, internal authorization error occured');
    }
    /*
    Considering adding a network syncing block of code here to make sure
    the user get a refresh list of content that is not theirs.

    This block could be an opportunity to check token expiration and make a
    refresh request or otherwise.
     */
    UserController()
        .refresh(email: user.email, token: user.token)
        .then((User u) {

      FriendshipController()
          .get(email: u.email, token: u.token).then((List<Friendship> friendships) {

            /*
            We then retrieve any messages from friendships whose state is accepted.
             */
            friendships.forEach((f) {
              if(f.state == accepted)
                MessageController().paged(email: u.email, token: u.token, friend: (f.initiator.email == u.email) ? f.subject.email : f.initiator.email)
                  .then((List<Message> messages) {
                    return messages;
                }).catchError((error) => debugPrint(error.toString()));
            });
          }).catchError((error) => debugPrint(error.toString()));
      EmotionController()
          .get(email: u.email, token: u.token).catchError((error) => null);
      ArticleController()
          .get(email: u.email, token: u.token).catchError((error) => debugPrint(error.toString()));
    });

    return user;
  }
  static Future<FirebaseMessaging> initfirebase(BuildContext context) async {
    FirebaseMessaging firebase = (new FirebaseMessaging())..configure(
      onMessage: (Map<String, dynamic> message) async {
        String instruction = message['data']['instruction'];
        if(instruction == 'message_delivery'){
          UserMiddleware.fromSave().then((User user){

            MessageController().poll(email: user.email, token: user.token, friend: jsonDecode(message['data']['sender'])['email'])
                .then((List<Message> messages) {
                  return messages;
                });
          });
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        /*
        This function is called when the user clicks on the notification that
        they get from the firebase service...So what we need to do and handle
        the payload of the notification appropriately in order to navigate the
        user to the correct area and functionality to handle the notification.

        Firstly we should expect that the payload of the notification should tell
        the user how to handle it, hence we should expect the payload to have a
        field called instruction.
         */
        String instruction = message['data']['instruction'];

        if(instruction == 'friend_request') {
          /*
          The notification recieved has the instruction to inform the user
          that they have recieved a friend request from another user..
           */
          User friend = User.fromJson(jsonDecode(message['data']['initiator']));

          dialogs.confirmoperation(context, message: 'approve friend request from ${friend.fullname}?', callback: (view, confirmed) async {
            if(confirmed) {
              return UserMiddleware.fromSave().then((User user) {
                return FriendshipController().approve(email: user.email, token: user.token, subject: friend.email,).then((friendship) {
                  /*
                  From this step we can the proceed to making the reaction control system for the controller
                  to be able to confirm that the user has been blocked in the processing system of the server.
                   */
                }).catchError((error) {
                  dialogs.snack.show(error.message);
                });
              });
            }
          });
        } else if(instruction == 'message_delivery'){
          UserMiddleware.fromSave().then((User user){

            MessageController().paged(email: user.email, token: user.token, friend: (jsonDecode(message['data']['sender'])['email']))
                .then((List<Message> messages) {
                  return messages;
                });
          });
        }

      },
      onResume: (Map<String, dynamic> message) async {

      },
      // onBackgroundMessage: Platform.isIOS ? null : BeautyReformatory.backgroundmessages,
    );
    return firebase;
  }

  static Future<dynamic> backgroundmessages(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }
}
class _BeautyReformatoryState extends State<BeautyReformatory> {
  // This widget is the root of your application.
  @override
  void initState() {
    /*
    Here we will be performing initializations that will require a context to
    run on
     */
    /*
    We initialize firebase early in the application to ensure it listens quickly
    for notifications.
     */
    BeautyReformatory.initfirebase(context).then((firebase) {
      widget._firebase = firebase;

      /*
      Here we have access to a context object so we are able to navigate the user properly
       */
    });


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: resources.files.preload(context),
      builder: (context, snapshot) {
        return MaterialApp(
          color: resources.colors.primary,

          title: 'BR',
          theme: ThemeData(
            primarySwatch: resources.material_colors.primary,
          ),
          home: widget.home,
          routes: <String, WidgetBuilder> {
            '/sploosh': (BuildContext context) => new Sploosh(),
            '/house': (BuildContext context) => new House(),
            '/messaging': (BuildContext context) => new Messaging(),
          },
        );
      }
    );
  }

}
