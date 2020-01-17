
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/validators.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

class VideoController {
  String branch = 'users/articles/videos/';
  List<String> endpoints = [
    'count',
  ];

  Future<int> count({
    @required email,
    @required token,
    @required article,
  }) async {
    if(token == null || email == null || article == null || !isEmail(email)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'article': article,
      }, end: endpoints[0]).then((Response response) async {

        return response.payload as int;
      }).catchError((e) => debugPrint(e.toString()));
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