import 'package:beautyreformatory/interface/screens/house.dart';
import 'package:beautyreformatory/interface/screens/sploosh.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/user.dart';
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

  /*
   */
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  (await SharedPreferences.getInstance()).clear();

  User user = await UserMiddleware.fromSave();
  if(user != null) {
    widget = new House();
  }

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
}
class _BeautyReformatoryState extends State<BeautyReformatory> {
  // This widget is the root of your application.
  @override
  void initState() {
    resources.files.preload(context);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

}
