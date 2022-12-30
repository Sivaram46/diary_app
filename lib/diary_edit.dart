import 'package:flutter/material.dart';
import 'diary_model.dart';

class DiaryEdit extends StatefulWidget {
  const DiaryEdit({
    super.key,
    this.diaryEntry,
    required this.addDiaryEntry,
    required this.updateDiaryEntry,
    required this.deleteDiaryEntry,
    required this.setIsEdit,
  });

  final Diary? diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary, Diary) updateDiaryEntry;
  final void Function(bool) setIsEdit;

  @override
  State<DiaryEdit> createState() => _DiaryEditState();
}

class _DiaryEditState extends State<DiaryEdit> {
  String? titleText;
  String bodyText = "";
  String? mood;
  DateTime selectedDate = DateTime.now();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  // function to show a dialog to pick date
  void _selectDate(BuildContext context, [DateTime? initialDate]) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // setting state variables
    setState(() {
      titleText = widget.diaryEntry?.title;
      bodyText = widget.diaryEntry?.body ?? "";
      mood = widget.diaryEntry?.mood;
      selectedDate = widget.diaryEntry?.createdDate ?? DateTime.now();
    });

    titleController.text = widget.diaryEntry?.title ?? "";
    titleController.addListener(() {
      setState(() {
        titleText = titleController.text;
      });
    });

    bodyController.text = widget.diaryEntry?.body ?? "";
    bodyController.addListener(() {
      setState(() {
        bodyText = bodyController.text;
      });
    });
  }

  void _saveDiaryEntry() {
    // Make a diary entry held by selectedDate, bodyText... and create/update
    // a new diary entry in `diaryEntries`.
    // Returns the index of newly created or updated diary entry item in `diaryEntries`.
    final newDiary = Diary(
        createdDate: selectedDate,
        body: bodyText,
        title: titleText,
        mood: mood
    );

    if (widget.diaryEntry != null) {
      widget.updateDiaryEntry(
          widget.diaryEntry ?? Diary(createdDate: DateTime.now(), body: ""),
          newDiary
      );
    }
    else {
      widget.addDiaryEntry(newDiary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary App"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // TODO: show a dialog to confirm like save or discard changes
            // Navigator.pop(context);
          },
        ),

        actions: <Widget> [
          // TODO: Bug - diary view not showing anything when creating new entry
          IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                _saveDiaryEntry();
                widget.setIsEdit(false);
              },
          ),
        ]
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            //  add top bar here which will hold Save, Go back, Pin/Star buttons
            // Container(),

            // TODO: Display date picker as good
            //  TODO: Mood picker at right
            ElevatedButton(
                onPressed: () => _selectDate(context, selectedDate),
                child: Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}")
            ),

            // Title text field
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),

            // Diary body text field
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Write here..."
              ),
              maxLines: null,
            ),
          ],
        ),
      )
    );
  }
}

