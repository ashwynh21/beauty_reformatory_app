
import 'User.dart';

class Account {
    Map<String, dynamic> date; // Date
    String name; // String
    User user; // String

    Account({this.date, this.name, this.user});

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            date: json['date'],
            name: json['name'],
            user: json['user'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if(data['date'] == null) data['date'] = this.date;
        if(data['name'] == null) data['name'] = this.name;
        if(data['user'] == null) data['user'] = (user != null) ? this.user.toJson() : null;
        return data;
    }
}