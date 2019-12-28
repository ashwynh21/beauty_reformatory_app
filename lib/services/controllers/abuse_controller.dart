
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/abuse_middleware.dart';
import 'package:beautyreformatory/services/models/abuse.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/validators.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

class AbuseController {
  String branch = 'users/abuse/';
  List<String> endpoints = [
    'report',
  ];

  Future<Abuse> report({
    @required email,
    @required token,
    @required subject,
    @required description,
  }) async {
    if(token == null || email == null || subject == null || description == null
        || !isEmail(email) || !isEmail(subject)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, String> {
        'email': email,
        'token': token,
        'subject': subject,
        'description': description,
      }, end: endpoints[0]).then((Response response) async {
        Abuse abuse = await AbuseMiddleware.fromResponse(response);
        await AbuseMiddleware.toSave(abuse);

        return abuse;
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