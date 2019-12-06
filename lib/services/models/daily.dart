import 'Journal.dart';

class Daily {
    DateTime date; // DateTime
    String description; // String
    DateTime duration; // DateTime
    String id; // String
    Journal journal; // Journal
    DateTime time; // DateTime

    Daily({this.date, this.description, this.duration, this.id, this.journal, this.time});

    factory Daily.fromJson(Map<String, dynamic> json) {
        return Daily(
            date: json['date'], 
            description: json['description'], 
            duration: json['duration'], 
            id: json['id'], 
            journal: json['journal'], 
            time: json['time'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['description'] = this.description;
        data['duration'] = this.duration;
        data['id'] = this.id;
        data['journal'] = this.journal;
        data['time'] = this.time;
        return data;
    }
}