import 'dart:convert';

class Diary {
  DateTime createdDate;
  String title;
  String body;
  String mood;
  int id;

  Diary({
    required this.createdDate,
    this.body = "",
    this.title = "",
    this.mood = "",
    this.id = 0,
  });

  Diary.fromJSON(Map<String, dynamic> diaryMap)
      : createdDate = DateTime.parse(diaryMap['created_date']),
        title = diaryMap['title'],
        body = diaryMap['body'],
        mood = diaryMap['mood'],
        id = diaryMap['id'];

  static String toJSONString(Diary diary) => jsonEncode({
        'created_date': diary.createdDate.toString(),
        'title': diary.title,
        'body': diary.body,
        'mood': diary.mood,
      });

  Map<String, dynamic> toMap() {
    return {
      'created_date': createdDate.toString(),
      'title': title,
      'body': body,
      'mood': mood,
    };
  }

  @override
  String toString() {
    /*
      For a diary with
      {createdDate: 1/1/2022, title: "Sample title", body: "This is a brief summary..."}
      the output will be like,

      CREATED ON: 01/01/2022
      ------------
      Sample title
      ------------
      This is a brief summary...

      - Diary App

    */
    String datePart = 'CREATED ON: '
        '${createdDate.day.toString().padLeft(2, '0')}/'
        '${createdDate.month.toString().padLeft(2, '0')}/'
        '${createdDate.year.toString()}';
    String titlePart =
        title.isNotEmpty ? "${'-' * 60}\n$title\n${'-' * 60}" : "";
    String result = "$datePart\n"
        "$titlePart${titlePart.isNotEmpty ? '\n' : ''}"
        "$body\n\n"
        "- Diary App";

    return result;
  }

  @override
  bool operator ==(other) => (other is Diary &&
      createdDate == other.createdDate &&
      body == other.body &&
      title == other.title &&
      mood == other.mood);

  @override
  int get hashCode => Object.hash(createdDate, body, title, mood);
}
