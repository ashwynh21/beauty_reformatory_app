import 'Message.dart';

class Attaches {
    String attachment; // String
    Map<String, dynamic> date; // DateTime
    String id; // String
    Message message; // Message
    String type; // String

    Attaches({this.attachment, this.date, this.id, this.message, this.type});

    factory Attaches.fromJson(Map<String, dynamic> json) {
        return Attaches(
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