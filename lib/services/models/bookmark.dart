import 'dart:convert';

class Bookmark {
    String article; // String
    Map<String, dynamic> date; // Date
    String id; // String
    String user; // String
    bool value; // Boolean

    Bookmark({this.article, this.date, this.id, this.user, this.value});

    factory Bookmark.fromJson(Map<String, dynamic> json) {
        return Bookmark(
            article: json['article'], 
            date: json['date'], 
            id: json['id'], 
            user: json['user'], 
            value: json['value'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['article'] = this.article;
        data['date'] = jsonEncode(this.date);
        data['id'] = this.id;
        data['user'] = this.user;
        data['value'] = this.value;
        return data;
    }
}