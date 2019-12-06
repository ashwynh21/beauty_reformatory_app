
import 'User.dart';

class Emotion {
    DateTime date; // DateTime
    String id; // String
    double mood; // double
    User user; // User

    Emotion({this.date, this.id, this.mood, this.user});

    factory Emotion.fromJson(Map<String, dynamic> json) {
        return Emotion(
            date: json['date'], 
            id: json['id'], 
            mood: json['mood'], 
            user: json['user'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['id'] = this.id;
        data['mood'] = this.mood;
        data['user'] = this.user;
        return data;
    }
}