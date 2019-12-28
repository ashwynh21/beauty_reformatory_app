
import 'circle.dart';
import 'comment.dart';
import 'emotion.dart';
import 'friendship.dart';
import 'journal.dart';
import 'post.dart';
import 'account.dart';

class User {
  List<Account> accounts; // List<Account>
  List<Circle> circles; // List<Circle>
  List<Comment> comments;// List<Comment>
  Map<String, dynamic> date; // DateTime
  String email; // String
  List<Emotion> emotions; // List<Emotion>
  String fullname; // String
  String handle; // String
  String id; // String
  String image; // String
  List<Friendship> initiated; // List<Friendship>
  Journal journal; // Journal
  String location; // Map
  String mobile; // String
  String password; // String
  List<Post> posts; // List<Post>
  String secret; // String
  int state; // String
  String firebase;
  String status; // String
  List<Friendship> subjected; // List<Friendship>
  String token; // String

  User({this.accounts, this.firebase, this.circles, this.comments, this.date, this.email, this.emotions, this.fullname, this.handle, this.id, this.image, this.initiated, this.journal, this.location, this.mobile, this.password, this.posts, this.secret, this.state, this.status, this.subjected, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accounts: (json.containsKey('accounts') && json['accounts'] != null && json['accounts'].length > 0) ? (json['accounts'] as Iterable).map((a) => Account.fromJson(a)).toList() : null,
      initiated: (json.containsKey('initiated') && json['initiated'] != null && json['initiated'].length > 0) ? (json['initiated'] as Iterable).map((f) => Friendship.fromJson(f)).toList() : null,
      subjected: (json.containsKey('subjected') && json['subjected'] != null && json['subjected'].length > 0) ? (json['subjected'] as Iterable).map((f) => Friendship.fromJson(f)).toList() : null,
      circles: json['circles'],
      comments: json['comments'],
      date: json['date'],
      email: json['email'],
      emotions: json['emotions'],
      fullname: json['fullname'],
      handle: json['handle'],
      id: json['id'],
      image: json['image'],
      journal: json['journal'],
      firebase: json['firebase'],
      location: json['location'],
      mobile: json['mobile'],
      password: json['password'],
      posts: json['posts'],
      secret: json['secret'],
      state: json['state'],
      status: json['status'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accounts'] = (this.accounts != null) ? this.accounts.map((account) => account.toJson()).toList() : null;
    data['initiated'] = (this.initiated != null) ? this.initiated.map((initiated) => initiated.toSQL()).toList() : null;
    data['subjected'] = (this.subjected != null) ? this.subjected.map((subjected) => subjected.toSQL()).toList() : null;
    data['circles'] = (this.circles != null) ? this.circles.map((circle) => circle.toJson()).toList() : null;
    data['comments'] = (this.comments != null) ? this.comments.map((comment) => comment.toJson()).toList() : null;
    data['date'] = this.date;
    data['email'] = this.email;
    data['emotions'] = (this.emotions != null) ? this.emotions.map((emotion) => emotion.toJson()).toList() : null;
    data['fullname'] = this.fullname;
    data['handle'] = this.handle;
    data['id'] = this.id;
    data['image'] = this.image;
    data['journal'] = this.journal;
    data['firebase'] = this.firebase;
    data['location'] = this.location;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['posts'] = (this.posts != null) ? this.posts.map((post) => post.toJson()).toList() : null;
    data['secret'] = this.secret;
    data['state'] = this.state;
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}