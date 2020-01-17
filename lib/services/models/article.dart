import 'dart:convert';

import 'package:beautyreformatory/services/models/user.dart';

class Article {
    String id;
    Map<String, dynamic> date; // Date
    String title; // String
    String description; // String

    String bookmarked; // Boolean
    String comments; // List<String>
    String images; // List<String>
    String reactions; // List<String>
    User user; // User
    String videos; // List<String>

    Article({this.id, this.bookmarked, this.comments, this.date, this.description, this.images, this.reactions, this.title, this.user, this.videos});

    factory Article.fromJson(Map<String, dynamic> json) {
        return Article(
            id: json['id'],
            bookmarked: json['bookmarked'],
            comments: json['comments'], 
            date: json['date'], 
            description: json['description'], 
            images: json['images'],
            reactions: json['reactions'], 
            title: json['title'],
            user:  (json.containsKey('user') && json['user'] != null) ? User.fromJson(json['user']) : null,
            videos: json['videos'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['bookmarked'] = this.bookmarked;
        data['comments'] = this.comments;
        data['date'] = jsonEncode(this.date);
        data['description'] = this.description;
        data['images'] = this.images;
        data['reactions'] = this.reactions;
        data['title'] = this.title;
        data['user'] = (this.user != null) ? jsonEncode(this.user.toJson()) : null;
        data['videos'] = this.videos;
        return data;
    }
    Map<String, dynamic> toSQL() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['date'] = jsonEncode(this.date);
        data['description'] = this.description;
        data['user'] = (this.user != null) ? jsonEncode(this.user.toJson()) : null;
        data['title'] = this.title;
        return data;
    }
}