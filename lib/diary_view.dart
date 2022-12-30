import 'package:flutter/material.dart';
import 'diary_model.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({
    super.key,
    required this.diaryEntry,
    required this.addDiaryEntry,
    required this.updateDiaryEntry,
    required this.deleteDiaryEntry,
    required this.setIsEdit,
  });

  final Diary diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary, Diary) updateDiaryEntry;
  final void Function(bool) setIsEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary App"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setIsEdit(true);
              },
          ),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          // TODO: Better date show UI
          Text("${diaryEntry.createdDate.day}-${diaryEntry.createdDate.month}-${diaryEntry.createdDate.year}"),

          Text(
            diaryEntry.title ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),

          Text(
            diaryEntry.body,
          ),
        ],
      ),
    );
  }
}

