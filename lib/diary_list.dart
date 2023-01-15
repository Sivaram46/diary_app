import 'package:flutter/material.dart';
import 'diary_model.dart';
import 'constants.dart';
import 'diary_page.dart';

class DiaryListEntry extends StatefulWidget {
  const DiaryListEntry({
    super.key,
    required this.diaryEntry,
    required this.updateDiaryEntry,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
  });

  final Diary diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary) updateDiaryEntry;

  @override
  State<DiaryListEntry> createState() => _DiaryListEntryState();
}

class _DiaryListEntryState extends State<DiaryListEntry> {
  @override
  Widget build(BuildContext context) {
    String title = widget.diaryEntry.title;
    DateTime createdDate = widget.diaryEntry.createdDate;
    // since body can contain many newlines and that shouldn't be showed in diary
    // entry.
    String body = widget.diaryEntry.body.replaceAll(RegExp(r"[\n ]+"), " ");
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryPage(
              diaryEntry: widget.diaryEntry,
              addDiaryEntry: widget.addDiaryEntry,
              updateDiaryEntry: widget.updateDiaryEntry,
              deleteDiaryEntry: widget.deleteDiaryEntry,
              isEdit: false,
            ),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        height: 100,
        child: Row(
          children: <Widget>[
            // date display
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 2
                      ),
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                        createdDate.day.toString().padLeft(2, '0'),
                        style: Theme.of(context).textTheme.titleLarge
                    ),
                    Text(
                      monthMap[createdDate.month] ?? "",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color
                      ),
                    ),
                    Text(
                      createdDate.year.toString(),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // display diary content
            Expanded(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // diary title
                    title.isNotEmpty ? Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold
                        )
                    ) : Container(height: 0,),

                    // diary body
                    Text(
                      body,
                      maxLines: title.isNotEmpty ? 3 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 1.3),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class DiaryList extends StatefulWidget {
  const DiaryList({
    super.key,
    required this.diaryEntries,
    required this.updateDiaryEntry,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
  });

  final List<Diary> diaryEntries;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary) updateDiaryEntry;

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return DiaryListEntry(
            diaryEntry: widget.diaryEntries[index],
            updateDiaryEntry: widget.updateDiaryEntry,
            addDiaryEntry: widget.addDiaryEntry,
            deleteDiaryEntry: widget.deleteDiaryEntry,
          );
        },

        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: widget.diaryEntries.length
    );
  }
}
