
import 'Chat.dart';
import 'Circle.dart';
import 'Friendship.dart';

class Member {
    List<Chat> chats; // List<Chat>
    Circle circle; // Circle
    DateTime date; // DateTime
    Friendship friendship; // Friendship
    String id; // String
    int state; // int

    Member({this.chats, this.circle, this.date, this.friendship, this.id, this.state});

    factory Member.fromJson(Map<String, dynamic> json) {
        return Member(
            chats: json['chats'], 
            circle: json['circle'], 
            date: json['date'], 
            friendship: json['friendship'], 
            id: json['id'], 
            state: json['state'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['chats'] = this.chats;
        data['circle'] = this.circle;
        data['date'] = this.date;
        data['friendship'] = this.friendship;
        data['id'] = this.id;
        data['state'] = this.state;
        return data;
    }
}