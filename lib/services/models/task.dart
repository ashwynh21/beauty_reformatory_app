import 'package:beautyreformatory/services/models/Note.dart';

import 'Journal.dart';

class Task {
    bool completed; // bool
    Map<String, dynamic> date; // DateTime
    String description; // String
    Map<String, dynamic> due; // DateTime
    Map<String, dynamic> finish; // DateTime
    String id; // String
    Journal journal; // Journal
    List<Note> notes; // List<Note>
    String title; // String

    Task({this.completed, this.date, this.description, this.due, this.finish, this.id, this.journal, this.notes, this.title});

    factory Task.fromJson(Map<String, dynamic> json) {
        return Task(
            completed: json['completed'], 
            date: json['date'], 
            description: json['description'], 
            due: json['due'], 
            finish: json['finish'], 
            id: json['id'], 
            journal: json['journal'], 
            notes: json['notes'], 
            title: json['title'], 
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
        data['notes'] = this.notes;
        data['title'] = this.title;
        return data;
    }
}