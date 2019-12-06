
import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/account_middleware.dart';
import 'package:beautyreformatory/services/models/account.dart';
import 'package:beautyreformatory/utilities/environment.dart' as env;
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AccountController {
  String branch = 'users/external/';
  List<String> endpoints = [
    'google_signup',
    'google_signin',
    'facebook_signup',
    'facebook_signin',
  ];

  Future<Account> facebook_signin({
    @required token,
  }) async {
    if(token == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'token': token
      }, end: endpoints[3]).then((Response response) async {
        Account account = (await AccountMiddleware.fromResponse(response));
        await AccountMiddleware.toSave(account);

        return account;
      });
    }
  }
  Future<Account> facebook_signup({
    @required token,
  }) async {
    if(token == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'token': token
      }, end: endpoints[2]).then((Response response) async {
        Account account = (await AccountMiddleware.fromResponse(response));
        await AccountMiddleware.toSave(account);

        return account;
      });
    }
  }
  Future<Account> google_signup({
    @required email,
    @required token,
  }) async {
    if(email == null || token == null || !isEmail(email)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[0]).then((Response response) async {
        Account account = (await AccountMiddleware.fromResponse(response));
        await AccountMiddleware.toSave(account);

        return account;
      });
    }
  }
  Future<Account> google_signin({
    @required email,
    @required token,
  }) async {
    if(email == null || token == null || !isEmail(email)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[1]).then((Response response) async {
        Account account = (await AccountMiddleware.fromResponse(response));
        await AccountMiddleware.toSave(account);

        return account;
      });
    }
  }

  Future<Response> _request(Map<String, dynamic> data, {String end}) async {
    return http.post(env.root + branch + end,
        body: data)
        .timeout(Duration(seconds: env.timeout))
        .then((http.Response response) {

      switch(response.statusCode) {
        case 200:
        case 401:
        case 404:
          return Response.fromJson(jsonDecode(response.body.toString()));
          break;
        default:
          throw ConnectionException('Oops, Response format not the same as defined in Response class!');
          break;
      }
    })
        .catchError((error) {
      if (error.runtimeType == TimeoutException) {
        return this._request(data, end: end);
      }

      throw ConnectionException('Oops, a request error has occured!');
    });
  }
}