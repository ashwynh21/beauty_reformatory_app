import 'dart:convert';

import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/attaches.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/cupertino.dart';

class Message {
    List<Attaches> attachments; // List<Attaches>
    Map<String, dynamic> date; // DateTime
    Friendship friendship; // Friendship
    String id; // String
    String message; // String
    User recipient; // User
    User sender; // User
    int state; // int

    Message({this.attachments, this.date, this.friendship, this.id, this.message, this.recipient, this.sender, this.state});

    factory Message.fromJson(Map<String, dynamic> json) {
        Message message =  Message(
            attachments: json['attachments'],
            friendship:  (json.containsKey('friendship') && json['friendship'] != null) ? Friendship.fromJson(json['friendship']) : null,
            id: json['id'],
            message: json['message'],
            recipient:  (json.containsKey('recipient') && json['recipient'] != null) ? User.fromJson(json['recipient']) : null,
            sender:  (json.containsKey('sender') && json['sender'] != null) ? User.fromJson(json['sender']) : null,
            state: int.parse(json['state'].toString()),
            date: json['date'],
        );
        return message;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['attachments'] = this.attachments;
        data['friendship'] = (this.friendship != null) ? jsonEncode(this.friendship.toJson()) : null;
        data['id'] = this.id;
        data['message'] = this.message;
        data['recipient'] = (this.recipient != null) ? jsonEncode(this.recipient.toJson()) : null;
        data['sender'] = (this.sender != null) ? jsonEncode(this.sender.toJson()) : null;
        data['state'] = this.state.toString();
        data['date'] = jsonEncode(this.date);
        return data;
    }
    Map<String, dynamic> toSQL() {
        final Map<String, dynamic> data = new Map<String, dynamic>();

        data['friendship'] = (this.friendship != null) ? jsonEncode(this.friendship.toJson()) : null;
        data['id'] = this.id;
        data['message'] = this.message;
        data['recipient'] = (this.recipient != null) ? jsonEncode(this.recipient.toJson()) : null;
        data['sender'] = (this.sender != null) ? jsonEncode(this.sender.toJson()) : null;
        data['state'] = this.state.toString();
        data['date'] = jsonEncode(this.date);
        return data;
    }
}