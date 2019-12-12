
import 'dart:convert';

import 'user.dart';

class Emotion {
    Map<String, dynamic> date; // DateTime
    String id; // String
    String mood; // double
    User user; // User

    Emotion({this.date, this.id, this.mood, this.user});

    factory Emotion.fromJson(Map<String, dynamic> json) {
        return Emotion(
            date: json['date'], 
            id: json['id'], 
            mood: json['mood'],
            user: (json.containsKey('user') && json['user'] != null) ? User.fromJson(json['user']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['id'] = this.id;
        data['mood'] = this.mood;
        data['user'] = (this.user != null) ? this.user.toJson() : null;
        return data;
    }

    Map<String, dynamic> toSQL() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = jsonEncode(this.date);
        data['id'] = this.id;
        data['mood'] = this.mood;
        data['user'] = (this.user != null) ? jsonEncode(this.user.toJson()) : null;
        return data;
    }
}