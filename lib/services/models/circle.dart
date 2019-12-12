import 'Member.dart';
import 'User.dart';

class Circle {
    String cover; // String
    User creator; // User
    Map<String, dynamic> date; // DateTime
    String id; // String
    List<Member> members; // Member
    String name; // String
    int status; // int

    Circle({this.cover, this.creator, this.date, this.id, this.members, this.name, this.status});

    factory Circle.fromJson(Map<String, dynamic> json) {
        return Circle(
            cover: json['cover'], 
            creator: json['creator'], 
            date: json['date'], 
            id: json['id'], 
            members: json['members'], 
            name: json['name'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['cover'] = this.cover;
        data['creator'] = this.creator;
        data['date'] = this.date;
        data['id'] = this.id;
        data['members'] = this.members;
        data['name'] = this.name;
        data['status'] = this.status;
        return data;
    }
}