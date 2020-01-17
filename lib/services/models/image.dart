import 'dart:convert';

class Image {
    String article; // String
    Map<String, dynamic> date; // Date
    String id; // String
    String image; // String
    String type; // String

    Image({this.article, this.date, this.id, this.image, this.type});

    factory Image.fromJson(Map<String, dynamic> json) {
        return Image(
            article: json['article'], 
            date: json['date'], 
            id: json['id'], 
            image: json['image'], 
            type: json['type'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['article'] = this.article;
        data['date'] = jsonEncode(this.date);
        data['id'] = this.id;
        data['image'] = this.image;
        data['type'] = this.type;
        return data;
    }
}