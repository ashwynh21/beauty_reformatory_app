import 'package:beautyreformatory/services/models/Post.dart';

class Tag {
    DateTime date; // DateTime
    String id; // String
    Post post; // Post
    String tag; // String

    Tag({this.date, this.id, this.post, this.tag});

    factory Tag.fromJson(Map<String, dynamic> json) {
        return Tag(
            date: json['date'], 
            id: json['id'], 
            post: json['post'], 
            tag: json['tag'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['id'] = this.id;
        data['post'] = this.post;
        data['tag'] = this.tag;
        return data;
    }
}