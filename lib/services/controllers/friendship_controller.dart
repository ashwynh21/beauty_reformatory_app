import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/utilities/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';

class FriendshipController {
  String branch = 'users/friends/';
  List<String> endpoints = [
    'get',
    'getinitiated',
    'getsubjected',
    'block',
    'remove',
    'add',
    'cancel',
    'approve',
    'getuser',
  ];

  Future<Friendship> approve({
    @required email,
    @required token,
    @required subject
  }) async {
    if(token == null || email == null || subject == null  || !isEmail(email) || !isEmail(subject)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'subject': subject,
      }, end: endpoints[7]).then((Response response) async {
        Friendship friends = await FriendshipMiddleware.fromResponse(response);
        await FriendshipMiddleware.toSave(friends);

        return friends;
      });
    }
  }
  Future<Friendship> cancel({
    @required email,
    @required token,
    @required subject
  }) async {
    if(token == null || email == null || subject == null  || !isEmail(email) || !isEmail(subject)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'subject': subject,
      }, end: endpoints[6]).then((Response response) async {
        Friendship friends = await FriendshipMiddleware.fromResponse(response);
        await FriendshipMiddleware.toSave(friends);

        return friends;
      });
    }
  }
  Future<Friendship> add({
    @required email,
    @required token,
    @required subject
  }) async {
    if(token == null || email == null || subject == null  || !isEmail(email) || !isEmail(subject)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'subject': subject,
      }, end: endpoints[5]).then((Response response) async {
        Friendship friends = await FriendshipMiddleware.fromResponse(response);
        await FriendshipMiddleware.toSave(friends);

        return friends;
      });
    }
  }
  Future<Friendship> remove({
    @required email,
    @required token,
    @required subject
  }) async {
    if(token == null || email == null || subject == null  || !isEmail(email) || !isEmail(subject)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'subject': subject,
      }, end: endpoints[4]).then((Response response) async {
        Friendship friends = await FriendshipMiddleware.fromResponse(response);
        await FriendshipMiddleware.toSave(friends);

        return friends;
      });
    }
  }
  Future<Friendship> block({
    @required email,
    @required token,
    @required subject
  }) async {
    if(token == null || email == null || subject == null  || !isEmail(email) || !isEmail(subject)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'subject': subject,
      }, end: endpoints[3]).then((Response response) async {
        Friendship friends = await FriendshipMiddleware.fromResponse(response);
        await FriendshipMiddleware.toSave(friends);

        return friends;
      });
    }
  }
  Future<List<Friendship>> get({
    @required email,
    @required token,
  }) async {
    if(token == null || email == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[0]).then((Response response) async {
        List<Friendship> friends = await FriendshipMiddleware.listFromResponse(response);
        await FriendshipMiddleware.listToSave(friends);

        return friends;
      });
    }
  }
  Future<List<Friendship>> getinitiated({
    @required email,
    @required token,
  }) async {
    if(token == null || email == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[1]).then((Response response) async {
        List<Friendship> friends = await FriendshipMiddleware.listFromResponse(response);
        await FriendshipMiddleware.listToSave(friends);

        return friends;
      });
    }
  }
  Future<List<Friendship>> getsubjected({
    @required email,
    @required token,
  }) async {
    if(token == null || email == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[2]).then((Response response) async {
        List<Friendship> friends = await FriendshipMiddleware.listFromResponse(response);
        await FriendshipMiddleware.listToSave(friends);

        return friends;
      });
    }
  }

  Future<Response> _request(Map<String, dynamic> data,
      {String end, int timeout = env.timeout.normal}) async {
    return http.post(env.root + branch + end,
        body: data)
        .timeout(Duration(seconds: timeout))
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
        .catchError((error) async {
          throw ConnectionException('Oops, a request error has occured!');
        });
  }
}