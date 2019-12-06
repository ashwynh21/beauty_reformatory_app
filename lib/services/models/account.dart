
import 'User.dart';

class Account {
    DateTime date; // Date
    String name; // String
    User user; // String

    Account({this.date, this.name, this.user});

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            date: json.containsKey('date') ? DateTime.parse(json['date']['date'].toString()) : DateTime.now(),
            name: json['name'],
            user: json['user'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if(data['date'] != null) data['date'] = this.date.toString();
        if(data['name'] != null) data['name'] = this.name;
        if(data['user'] != null) data['user'] = this.user.toJson();
        return data;
    }
}