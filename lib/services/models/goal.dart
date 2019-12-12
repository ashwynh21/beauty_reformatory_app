import 'Journal.dart';

class Goal {
    bool completed; // bool
    Map<String, dynamic> date; // DateTime
    String description; // String
    Map<String, dynamic> due; // DateTime
    Map<String, dynamic> finish; // DateTime
    String id; // String
    Journal journal; // Journal

    Goal({this.completed, this.date, this.description, this.due, this.finish, this.id, this.journal});

    factory Goal.fromJson(Map<String, dynamic> json) {
        return Goal(
            completed: json['completed'], 
            date: json['date'], 
            description: json['description'], 
            due: json['due'], 
            finish: json['finish'], 
            id: json['id'], 
            journal: json['journal'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['completed'] = this.completed;
        data['date'] = this.date;
        data['description'] = this.description;
        data['due'] = this.due;
        data['finish'] = this.finish;
        data['id'] = this.id;
        data['journal'] = this.journal;
        return data;
    }
}