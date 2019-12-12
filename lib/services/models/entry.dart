import 'Journal.dart';

class Entry {
    Map<String, dynamic> date; // DateTime
    String entry; // String
    String id; // String
    Journal journal; // Journal

    Entry({this.date, this.entry, this.id, this.journal});

    factory Entry.fromJson(Map<String, dynamic> json) {
        return Entry(
            date: json['date'], 
            entry: json['entry'], 
            id: json['id'], 
            journal: json['journal'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['entry'] = this.entry;
        data['id'] = this.id;
        data['journal'] = this.journal;
        return data;
    }
}