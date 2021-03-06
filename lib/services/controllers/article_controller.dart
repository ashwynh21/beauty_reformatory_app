import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/article_middleware.dart';
import 'package:beautyreformatory/services/models/article.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

class ArticleController {

  String branch = 'users/articles';
  List<String> endpoints = [
    '',
  ];

  static StreamController stream = new StreamController<List<Article>>.broadcast();

  Future<List<Article>> get({
    @required String email,
    @required String token,
  }) {

    if(token == null || email == null) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token
      }, end: endpoints[0]).then((Response response) async {
        List<Article> articles = await ArticleMiddleware.listFromResponse(response);
        await ArticleMiddleware.listToSave(articles);

        return articles;
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
      throw ConnectionException('Oops, a request error has occured!' + error.toString());
    });
  }
}