import 'Task.dart';

class Note {
    DateTime date; // DateTime
    String id; // String
    String note; // String
    Task task; // Task

    Note({this.date, this.id, this.note, this.task});

    factory Note.fromJson(Map<String, dynamic> json) {
        return Note(
            date: json['date'], 
            id: json['id'], 
            note: json['note'], 
            task: json['task'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['id'] = this.id;
        data['note'] = this.note;
        data['task'] = this.task;
        return data;
    }
}