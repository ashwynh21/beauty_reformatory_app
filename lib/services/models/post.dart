import 'package:beautyreformatory/services/models/Comment.dart';
import 'package:beautyreformatory/services/models/user.dart';

import 'Tag.dart';

class Post {
    List<Comment> comments; // List<Comment>
    String content; // String
    Map<String, dynamic> date; // DateTime
    String id; // String
    List<Tag> tags; // List<Tag>
    String title; // String
    User user; // User

    Post({this.comments, this.content, this.date, this.id, this.tags, this.title, this.user});

    factory Post.fromJson(Map<String, dynamic> json) {
        return Post(
            comments: json['comments'], 
            content: json['content'], 
            date: json['date'], 
            id: json['id'], 
            tags: json['tags'], 
            title: json['title'], 
            user: json['user'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['comments'] = this.comments;
        data['content'] = this.content;
        data['date'] = this.date;
        data['id'] = this.id;
        data['tags'] = this.tags;
        data['title'] = this.title;
        data['user'] = this.user;
        return data;
    }
}