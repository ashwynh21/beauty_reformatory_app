import 'dart:convert';

import 'package:beautyreformatory/services/models/user.dart';

class Abuse {
    Map<String, dynamic> date; // Date
    String description; // String
    String id; // String
    User user; // String

    Abuse({this.date, this.description, this.id, this.user});

    factory Abuse.fromJson(Map<String, dynamic> json) {
        return Abuse(
            date: json['date'], 
            description: json['desrciption'],
            id: json['id'], 
            user: (json.containsKey('user') && json['user'] != null) ? User.fromJson(json['user']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['desrciption'] = this.description;
        data['id'] = this.id;
        if(data['user'] == null) data['user'] = (user != null) ? this.user.toJson() : null;
        return data;
    }

    Map<String, dynamic> toSQL() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['user'] = (this.user != null) ? jsonEncode(this.user.toJson()) : null;
        data['description'] = this.description;
        data['date'] = jsonEncode(this.date);
        return data;
    }
}