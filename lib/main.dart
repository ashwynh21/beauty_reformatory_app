import 'package:beautyreformatory/interface/screens/house/house.dart';
import 'package:beautyreformatory/interface/screens/sploosh/sploosh.dart';
import 'package:beautyreformatory/services/controllers/emotion_controller.dart';
import 'package:beautyreformatory/services/controllers/friendship_controller.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await UserController()
        .refresh(email: user.email, token: user.token)
        .then((User u) {
      FriendshipController()
          .get(email: u.email, token: u.token).catchError((error) => null);
      EmotionController()
          .get(email: u.email, token: u.token).catchError((error) => null);
    });

    return user;
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
          routes: <String, WidgetBuilder>{
            '/sploosh': (BuildContext context) => new Sploosh(),
            '/house': (BuildContext context) => new House(),
          },
        );
      }
    );
  }

}
