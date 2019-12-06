import 'Account.dart';
import 'Circle.dart';
import 'Comment.dart';
import 'Emotion.dart';
import 'Journal.dart';
import 'Post.dart';

class User {
    List<Account> accounts; // List<Account>
    List<Circle> circles; // List<Circle>
    List<Comment> comments; // List<Comment>
    DateTime date; // DateTime
    String email; // String
    List<Emotion> emotions; // List<Emotion>
    String fullname; // String
    String handle; // String
    String id; // String
    String image; // String
    List<User> initiated; // List<User>
    Journal journal; // Journal
    String location; // Map
    String mobile; // String
    String password; // String
    List<Post> posts; // List<Post>
    String secret; // String
    String state; // String
    String status; // String
    List<User> subjected; // List<User>
    String token; // String

    User({this.accounts, this.circles, this.comments, this.date, this.email, this.emotions, this.fullname, this.handle, this.id, this.image, this.initiated, this.journal, this.location, this.mobile, this.password, this.posts, this.secret, this.state, this.status, this.subjected, this.token});

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            accounts: json['accounts'],
            circles: json['circles'],
            comments: json['comments'],
            date: json.containsKey('date') ? DateTime.parse(json['date']['date'].toString()) : DateTime.now(),
            email: json['email'],
            emotions: json['emotions'],
            fullname: json['fullname'],
            handle: json['handle'],
            id: json['id'],
            image: json['image'],
            initiated: json['initiated'],
            journal: json['journal'],
            location: json['location'],
            mobile: json['mobile'],
            password: json['password'],
            posts: json['posts'],
            secret: json['secret'],
            state: json['state'],
            status: json['status'],
            subjected: json['subjected'],
            token: json['token'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if(data['accounts'] != null) data['accounts'] = this.accounts;
        if(data['circles'] != null) data['circles'] = this.circles;
        if(data['comments'] != null) data['comments'] = this.comments;
        if(data['date'] != null) data['date'] = this.date.toString();
        if(data['email'] != null) data['email'] = this.email;
        if(data['emotions'] != null) data['emotions'] = this.emotions;
        if(data['fullname'] != null) data['fullname'] = this.fullname;
        if(data['handle'] != null)  data['handle'] = this.handle;
        if(data['id'] != null) data['id'] = this.id;
        if(data['image'] != null) data['image'] = this.image;
        if(data['initiated'] != null) data['initiated'] = this.initiated;
        if(data['journal'] != null) data['journal'] = this.journal;
        if(data['location'] != null) data['location'] = this.location;
        if(data['mobile'] != null) data['mobile'] = this.mobile;
        if(data['password'] != null) data['password'] = this.password;
        if(data['posts'] != null) data['posts'] = this.posts;
        if(data['secret'] != null) data['secret'] = this.secret;
        if(data['state'] != null) data['state'] = this.state;
        if(data['status'] != null) data['status'] = this.status;
        if(data['subjected'] != null) data['subjected'] = this.subjected;
        if(data['token'] != null) data['token'] = this.token;
        return data;
    }
}