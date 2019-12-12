
import 'dart:convert';

import 'member.dart';
import 'message.dart';
import 'user.dart';

class Friendship {
    String id; // String
    User initiator; // User
    int state; // int
    User subject; // User
    List<Member> memberships; // Member
    List<Message> messages; // List<Message>
    Map<String, dynamic> date;

    Friendship({this.id, this.initiator, this.memberships, this.messages, this.state, this.subject, this.date});

    factory Friendship.fromJson(Map<String, dynamic> json) {
        return Friendship(
            id: json['id'],
            initiator:  (json.containsKey('initiator') && json['initiator'] != null) ? User.fromJson(json['initiator']) : null,
            subject:  (json.containsKey('subject') && json['subject'] != null) ? User.fromJson(json['subject']) : null,
            memberships: json['memberships'],
            messages:  json['messages'],
            state: json['state'],
            date: json['date'],
        );
    }

    Map<String, dynamic> toSQL() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['initiator'] = (this.initiator != null) ? jsonEncode(this.initiator.toJson()) : null;
        data['subject'] = (this.subject != null) ? jsonEncode(this.subject.toJson()) : null;
        data['memberships'] = this.memberships;
        data['messages'] = this.messages;
        data['state'] = jsonEncode(this.state);
        data['date'] = jsonEncode(this.date);
        return data;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['initiator'] = (this.initiator != null) ? this.initiator.toJson() : null;
        data['subject'] = (this.subject != null) ? this.subject.toJson() : null;
        data['memberships'] = this.memberships;
        data['messages'] = this.messages;
        data['state'] = this.state;
        data['date'] = this.date;
        return data;
    }
}