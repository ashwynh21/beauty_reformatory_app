
import 'dart:async';
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/message_middleware.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:beautyreformatory/utilities/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:beautyreformatory/utilities/environment.dart' as env;

class MessageController {
  String branch = 'users/friends/messaging/';
  List<String> endpoints = [
    'send',
    'poll',
    'paged',
    'read',
  ];

  static StreamController stream = new StreamController<List<Message>>.broadcast();

  MessageController() {
    MessageMiddleware.listFromSave().then((List<Message> messages) {
      if(messages != null && messages.length > 0)
        stream.sink.add(messages);
    });
  }

  Future<Message> read({
    @required email,
    @required token,
    @required Message message
  }) async {
    if(token == null || email == null || !isEmail(email)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      message.state = env.read;
      await MessageMiddleware.toSave(message);

      return _request(<String, String> {
        'email': email,
        'token': token,
        'id': message.id,
      }, end: endpoints[3], timeout: env.timeout.normal).then((Response response) async {

        return message;
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }

  Future<List<Message>> paged({
    @required email,
    @required token,
    @required friend,
    int page = 0,
    int size = 10,
  }) async {
    if(token == null || email == null || friend == null || !isEmail(email) || !isEmail(friend)) {
      throw ValidationException('Oops, invalid field format!');
    } else {

      return _request(<String, String> {
        'email': email,
        'token': token,
        'friend': friend,
        'size': size.toString(),
        'page': page.toString()
      }, end: endpoints[2], timeout: 60).then((Response response) async {
        List<Message> m = await MessageMiddleware.listFromResponse(response);

        await MessageMiddleware.listToSave(m);

        return m;
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }

  Future<List<Message>> poll({
    @required email,
    @required token,
    @required friend,
  }) async {
    if(token == null || email == null || friend == null || !isEmail(email) || !isEmail(friend)) {
      throw ValidationException('Oops, invalid field format!');
    } else {

      return _request(<String, String> {
        'email': email,
        'token': token,
        'friend': friend,
      }, end: endpoints[1], timeout: 60).then((Response response) async {
        List<Message> m = await MessageMiddleware.listFromResponse(response);

        await MessageMiddleware.listToSave(m);

        return m;
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }

  /*
  This function is responsible for sending messages in a way that it does not
  count on the message being send to the server but just makes the request to
  it regardless, and if it does send then it will update the state of the
  message appropriately
   */
  Future<Message> send({
    @required email,
    @required token,
    @required friend,
    @required message,
  }) async {
    if(token == null || email == null || friend == null || message == null || !isEmail(email) || !isEmail(friend)) {
      throw ValidationException('Oops, invalid field format!');
    } else {

      Message m = MessageMiddleware.fromMessageData(<String, String> {
        'email': email,
        'token': token,
        'friend': friend,
        'message' : message,
      });

      await MessageMiddleware.toSave(m);
      stream.sink.add(await MessageMiddleware.listFromSave());

      _request(<String, dynamic> {
        'id': m.id,
        'email': email,
        'token': token,
        'friend': friend,
        'message' : message,
        'date' : m.date['date'].toString(),
      }, end: endpoints[0], timeout: 60).then((Response response) async {
        if(!response.result)
          throw ResponseException(response.message);

        m.state = env.sent;

        await MessageMiddleware.toSave(m);

        return m;
      }).catchError((error) {
        return m;
      });

      return m;
    }
  }

  Future<Message> resend({
    @required email,
    @required token,
    @required friend,
    @required Message message,
  }) async {
    if(token == null || email == null || friend == null || message == null || !isEmail(email) || !isEmail(friend)) {
      throw ValidationException('Oops, invalid field format!');
    } else {
      return _request(<String, dynamic> {
        'id': message.id,
        'email': email,
        'token': token,
        'friend': friend,
        'message' : message.message,
        'date' : message.date['date'].toString(),
      }, end: endpoints[0], timeout: 60).then((Response response) async {
        if(!response.result)
          throw ResponseException(response.message);

        message.state = env.sent;

        await MessageMiddleware.toSave(message);

        return message;
      }).catchError((error) {
        debugPrint(error.toString());
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
