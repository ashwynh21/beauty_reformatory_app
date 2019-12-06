import 'package:beautyreformatory/services/models/Chat.dart';

class Upload {
    Chat chat; // Chat
    DateTime date; // DateTime
    String id; // String
    String type; // String
    String upload; // String

    Upload({this.chat, this.date, this.id, this.type, this.upload});

    factory Upload.fromJson(Map<String, dynamic> json) {
        return Upload(
            chat: json['chat'], 
            date: json['date'], 
            id: json['id'], 
            type: json['type'], 
            upload: json['upload'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['chat'] = this.chat;
        data['date'] = this.date;
        data['id'] = this.id;
        data['type'] = this.type;
        data['upload'] = this.upload;
        return data;
    }
}