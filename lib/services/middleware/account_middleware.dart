import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/account.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountMiddleware {

    AccountMiddleware();

    /*
     * This class middleware will be responsible for keeping and recording the
     * external login accounts should the user decide to login using an
     * external account such as google or facebook in this case. This format
     * or structure of handling of external OAuth2.0 logins allows us to create
     * clean environments for each account type that the application supports.
     *
     */
    static Future<Account> fromResponse(Response response) async {
        if(!response.result){
            throw ResponseException(response.message);
        } else {
            Account account = Account.fromJson(response.payload);

            return account;
        }
    }

    static Future<void> toSave(User user) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();

        Type type = User;

        preferences.setString(type.toString(), jsonEncode(user.toJson()));
    }
    static Future<void> clearSave() async {
        SharedPreferences preferences = await SharedPreferences.getInstance();

        Type type = Account;

        try {
            preferences.remove(type.toString());
        } catch (e) {
            return;
        }
    }
}