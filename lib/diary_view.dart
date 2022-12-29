import 'package:flutter/material.dart';
import 'diary_model.dart';
import 'constants.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key, required this.diaryEntry, required this.setDiaryEntries});
  final Diary diaryEntry;
  final void Function(Diary, Mode, [int]) setDiaryEntries;

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
              onPressed: () {},
              icon: const Icon(Icons.edit)
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share)
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete)
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

