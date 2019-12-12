import 'package:beautyreformatory/services/models/Friendship.dart';
import 'package:beautyreformatory/services/models/attaches.dart';
import 'package:beautyreformatory/services/models/user.dart';

class Message {
    List<Attaches> attachments; // List<Attaches>
    Map<String, dynamic> date; // DateTime
    Friendship friendship; // Friendship
    String id; // String
    String message; // String
    User recipient; // User
    User sender; // User
    String state; // int

    Message({this.attachments, this.date, this.friendship, this.id, this.message, this.recipient, this.sender, this.state});

    factory Message.fromJson(Map<String, dynamic> json) {
        return Message(
            attachments: json['attachments'], 
            date: json['date'], 
            friendship: json['friendship'], 
            id: json['id'], 
            message: json['message'], 
            recipient: json['recipient'], 
            sender: json['sender'], 
            state: json['state'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['attachments'] = this.attachments;
        data['date'] = this.date;
        data['friendship'] = this.friendship;
        data['id'] = this.id;
        data['message'] = this.message;
        data['recipient'] = this.recipient;
        data['sender'] = this.sender;
        data['state'] = this.state;
        return data;
    }
}