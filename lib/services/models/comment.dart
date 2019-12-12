
import 'Post.dart';
import 'User.dart';

class Comment {
    Map<String, dynamic> date; // DateTime
    String id; // String
    Post post; // Post
    String text; // String
    User user; // User

    Comment({this.date, this.id, this.post, this.text, this.user});

    factory Comment.fromJson(Map<String, dynamic> json) {
        return Comment(
            date: json['date'], 
            id: json['id'], 
            post: json['post'], 
            text: json['text'], 
            user: json['user'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['id'] = this.id;
        data['post'] = this.post;
        data['text'] = this.text;
        data['user'] = this.user;
        return data;
    }
}