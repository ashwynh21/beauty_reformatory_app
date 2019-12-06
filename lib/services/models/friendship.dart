
import 'Member.dart';
import 'Message.dart';
import 'User.dart';

class Friendship {
    String id; // String
    User initiator; // User
    List<Member> memberships; // Member
    List<Message> messages; // List<Message>
    int state; // int
    User subject; // User

    Friendship({this.id, this.initiator, this.memberships, this.messages, this.state, this.subject});

    factory Friendship.fromJson(Map<String, dynamic> json) {
        return Friendship(
            id: json['id'], 
            initiator: json['initiator'], 
            memberships: json['memberships'], 
            messages: json['messages'], 
            state: json['state'], 
            subject: json['subject'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['initiator'] = this.initiator;
        data['memberships'] = this.memberships;
        data['messages'] = this.messages;
        data['state'] = this.state;
        data['subject'] = this.subject;
        return data;
    }
}