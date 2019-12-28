final String root = 'https://br.ashio.me/';//'http://192.168.43.223:4000/';//

final String database = 'beautyreformatory.db';

class timeout {
  static const int short = 8,
      normal = 16,
      long = 24;
}

const int
  //  Friend Requests states
  blocked = 3,
  removed = 5,
  cancelled = 4,
  accepted = 1,
  pending = 0,
  unapproved = 6,
  declined = 2,
  //  Messages states
  sending = 0,
  sent = 5,
  delivered = 6,
  recieved = 8,
  read = 7;