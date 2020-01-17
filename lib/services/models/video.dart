import 'dart:convert';

class Video {
    String article; // String
    Map<String, dynamic> date; // Date
    String id; // String
    String title; // String
    String video; // String

    Video({this.article, this.date, this.id, this.title, this.video});

    factory Video.fromJson(Map<String, dynamic> json) {
        return Video(
            article: json['article'], 
            date: json['date'], 
            id: json['id'], 
            title: json['title'], 
            video: json['video'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['article'] = this.article;
        data['date'] = jsonEncode(this.date);
        data['id'] = this.id;
        data['title'] = this.title;
        data['video'] = this.video;
        return data;
    }
}