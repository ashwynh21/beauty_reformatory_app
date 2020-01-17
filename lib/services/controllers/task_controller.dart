
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';

import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

class TaskController {

  String branch = 'users/journal/tasks';
  List<String> endpoints = [
    'get',
  ];

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