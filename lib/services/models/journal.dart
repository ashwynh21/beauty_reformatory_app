
import 'Entry.dart';
import 'Goal.dart';
import 'Task.dart';
import 'User.dart';
import 'daily.dart';

class Journal {
    List<Daily> dailies; // List<Daily>
    Map<String, dynamic> date; // DateTime
    List<Entry> entries; // List<Entry>
    List<Goal> goals; // List<Goal>
    String id; // String
    List<Task> tasks; // List<Task>
    User user; // User
    bool viewing; // bool

    Journal({this.dailies, this.date, this.entries, this.goals, this.id, this.tasks, this.user, this.viewing});

    factory Journal.fromJson(Map<String, dynamic> json) {
        return Journal(
            dailies: json['dailies'], 
            date: json['date'], 
            entries: json['entries'], 
            goals: json['goals'], 
            id: json['id'], 
            tasks: json['tasks'], 
            user: json['user'], 
            viewing: json['viewing'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['dailies'] = this.dailies;
        data['date'] = this.date;
        data['entries'] = this.entries;
        data['goals'] = this.goals;
        data['id'] = this.id;
        data['tasks'] = this.tasks;
        data['user'] = this.user;
        data['viewing'] = this.viewing;
        return data;
    }
}