import 'package:flutter/material.dart';

class DiaryEntryToShow {
  final String title;
  final String body;
  final String date;
  DiaryEntryToShow(this.title, this.body, this.date);
}

class DiaryListEntry extends StatefulWidget {
  const DiaryListEntry({super.key, required this.diaryEntryToShow});

  final DiaryEntryToShow diaryEntryToShow;

  @override
  State<DiaryListEntry> createState() => _DiaryListEntryState();
}

class _DiaryListEntryState extends State<DiaryListEntry> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.diaryEntryToShow.title),
      subtitle: Text(widget.diaryEntryToShow.body),
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(widget.diaryEntryToShow.date),
      ),
    );
  }
}


class DiaryList extends StatefulWidget {
  const DiaryList({Key? key}) : super(key: key);

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  final List<String> _diaryEntries = <String>["First entry", "Second one", "This is the third one"];
  final List<String> _dates = <String>["1", "2", "2"];
  final List<String> _bodies = <String>["Some body here", "other bodies are here", "some more bodies are here"];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return DiaryListEntry(
              diaryEntryToShow: DiaryEntryToShow(
                _diaryEntries[index],
                _bodies[index],
                _dates[index],
              ));
        },

        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: _diaryEntries.length
    );
  }
}
