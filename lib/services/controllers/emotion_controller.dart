import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/emotion_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

class EmotionController {
  String branch = 'users/emotions/';
  List<String> endpoints = [
    'get',
    'create',
  ];

  Future<Emotion> create({
    @required String mood,
  }) async {
    if(mood == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      User user = await UserMiddleware.fromSave();
      return _request(<String, String> {
        'email': user.email,
        'token': user.token,
        'mood' : mood,
      }, end: endpoints[1]).then((Response response) async {
        response.payload['user'] = user.toJson();

        Emotion emotion = await EmotionMiddleware.fromResponse(response);
        await EmotionMiddleware.toSave(emotion);

        return emotion;
      });
    }
  }

  Future<List<Emotion>> get({
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
        List<Emotion> emotions = await EmotionMiddleware.listFromResponse(response);
        await EmotionMiddleware.listToSave(emotions);

        return emotions;
      });
    }
  }

  Future<Response> _request(Map<String, dynamic> data,
      {String end, int timeout = 8}) async {
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