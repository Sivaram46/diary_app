import 'dart:convert';

class Diary {
  DateTime createdDate;
  String body;
  String? title;
  String? mood;

  Diary({
    required this.createdDate,
    required this.body,
    this.title,
    this.mood
  });

  Diary.fromJSON(Map<String, dynamic> diaryMap)
      : createdDate = DateTime.parse(diaryMap['createdDate']),
        body = diaryMap['body'],
        title = diaryMap['title'],
        mood = diaryMap['mood'];

  static String toJSONString(Diary diary) => jsonEncode({
    'createdDate': diary.createdDate.toString(),
    'body': diary.body,
    'title': diary.title,
    'mood': diary.mood
  });

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
    String titlePart = title != null ? "${'-' * 60}\n$title\n${'-' * 60}" : "";
    String result = "$datePart\n"
                    "$titlePart${titlePart.isNotEmpty ? '\n' : ''}"
                    "$body\n\n"
                    "- Diary App";

    return result;
  }

  @override
  bool operator ==(other) => (
    other is Diary &&
    createdDate == other.createdDate &&
    body == other.body &&
    title == other.title &&
    mood == other.mood
  );

  @override
  int get hashCode => Object.hash(createdDate, body, title, mood);
}