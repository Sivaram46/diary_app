import 'dart:convert';

class Diary {
  final DateTime createdDate;
  final String? title;
  final String body;
  final String? mood;

  const Diary({
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
}