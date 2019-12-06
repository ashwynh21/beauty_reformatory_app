import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMiddleware {

  /*
   * This class will be used as a data stop to store and update the relevant
   * data items which is in this the user model.
   *
   * The class will have sets of methods that except response payloads
   * and abstracts them into appropriate models from the models directory.
   *
   * In prior architectures the data storage was handled by the model itself
   * and we did not have any middleware to handle payload abstraction either.
   *
   * With this architecture we will basically be passing the response object
   * from the controller system whose architecture we are aware of to this
   * instance which will then pipeline a relevant structure from the BLoC
   * system.
   *
   * Another thing to note is that the middleware should only be used internally
   * to the services.
   */

  static Future<User> fromResponse(Response response) async {
    if(!response.result){
      throw ResponseException(response.message);
    } else {
      User user = User.fromJson(response.payload);

      return user;
    }
  }
  static Future<User> fromSave() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user;
    Type type = User;

    try{
      String data = preferences.getString(type.toString());

      if(data != null)
        user = User.fromJson(jsonDecode(data));
    } catch(e) {
      throw e;
    }
    return user;
  }
  static Future<void> toSave(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Type type = User;

    preferences.setString(type.toString(), jsonEncode(user.toJson()));
  }
  static Future<void> clearSave() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Type type = User;

    try{
      preferences.remove(type.toString());
    } catch(e) {
      return;
    }
  }
}