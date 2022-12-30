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
    String dateString = createdDate.toString();
    return 'Diary create on: $dateString with title: $title';
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