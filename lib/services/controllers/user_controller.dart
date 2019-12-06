import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:beautyreformatory/utilities/environment.dart' as env;
import 'package:http/http.dart' as http;

class UserController {
  String branch = 'users/';
  List<String> endpoints = [
    'authenticate',
    'create',
    'recover',
    'profile/get',
    'profile/update',
  ];
  /*
   * This class will be used as the outgoing interface to the API.
   *
   * Here the request will be constructed and sent to the server for a response.
   * We will create a generic request function and use it to the server API.
   *
   * Since each controller method will be accessed from the upper layers and
   * they will require a certain input from this layer, we then need to validate
   * this input.
   */
  Future<String> recover({
    @required email,
  }) async {
    if(email == null || !isEmail(email)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
      }, end: endpoints[2]).then((Response response) async {
        if(!response.result) {
          throw ResponseException(response.message);
        }
        return response.message;
      });
    }
  }
  Future<User> update({
    @required email,
    @required token,
    password,
    fullname,
    location,
    mobile
  }) async {
    if(email == null || token == null || (isEmail(email))) {
      throw ValidationException('Oops, invalid authentication data!');
    } else {
      Map<String, String> data = <String, String> {
        'email': email,
        'token': token,
      };

      if(password != null) data.putIfAbsent('password', () => password);
      if(fullname != null) data.putIfAbsent('fullname', () => fullname);
      if(mobile != null) data.putIfAbsent('mobile', () => mobile);
      if(location != null) data.putIfAbsent('location', () => location);

      return _request(data, end: endpoints[4]).then((Response response) async {
        User user = await UserMiddleware.fromResponse(response);
        return user;
      });
    }
  }
  Future<User> getprofile({
    @required email,
    @required token,
  }) async {
    if(email == null || token == null || !(isEmail(email))) {
      throw ValidationException('Oops, invalid authentication data!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[3]).then((Response response) async {
        User user = await UserMiddleware.fromResponse(response);
        await UserMiddleware.toSave(user);

        return user;
      });
    }
  }
  Future<User> create({
    @required email,
    @required password,
    @required fullname,
    @required location,
    @required mobile
  }) async {
    if(email == null || password == null || fullname == null || location == null || mobile == null
        ||
        !isEmail(email) || !isPassword(password) || !isNumber(mobile)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'password': password,
        'fullname': fullname,
        'mobile': mobile,
        'location': location
      }, end: endpoints[1]).then((Response response) async {
        User user = await UserMiddleware.fromResponse(response);
        await UserMiddleware.toSave(user);

        return user;
      });
    }

  }
  Future<User> authenticate({
    @required email,
    @required password,
  }) async {
    if(email == null || password == null || !isEmail(email) || !isPassword(password)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'password': password
      }, end: endpoints[0]).then((Response response) async {
        User user = (await UserMiddleware.fromResponse(response));
        await UserMiddleware.toSave(user);

        return user;
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