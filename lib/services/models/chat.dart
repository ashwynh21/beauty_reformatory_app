import 'Attaches.dart';
import 'Message.dart';

class Chat {
    Attaches attachment; // Attachment
    Map<String, dynamic> date; // DateTime
    String id; // String
    Message message; // Message
    String type; // String

    Chat({this.attachment, this.date, this.id, this.message, this.type});

    factory Chat.fromJson(Map<String, dynamic> json) {
        return Chat(
            attachment: json['attachment'], 
            date: json['date'], 
            id: json['id'], 
            message: json['message'], 
            type: json['type'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['attachment'] = this.attachment;
        data['date'] = this.date;
        data['id'] = this.id;
        data['message'] = this.message;
        data['type'] = this.type;
        return data;
    }
}