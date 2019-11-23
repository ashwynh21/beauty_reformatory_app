import 'package:beautyreformatory/screens/house.dart';
import 'package:beautyreformatory/screens/sploosh.dart';
import 'package:beautyreformatory/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
  We then configure the static initializations of the application such as the
  status bar here.
   */

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: utilities.colors.primary,
  ));
  utilities.flares.preload();

  return runApp(BeautyReformatory());
}

class BeautyReformatory extends StatefulWidget {
  _BeautyReformatoryState state;

  @override
  State<StatefulWidget> createState() {
    state = _BeautyReformatoryState();
    return state;
  }
}
class _BeautyReformatoryState extends State<BeautyReformatory> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BR',
      theme: ThemeData(
        primarySwatch: utilities.material_colors.primary,
      ),
      home: Sploosh(),
      routes: <String, WidgetBuilder>{
        '/sploosh': (BuildContext context) => new Sploosh(),
      },
    );
  }

}
