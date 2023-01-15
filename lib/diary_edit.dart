import 'package:flutter/material.dart';
import 'dart:developer';

import 'diary_model.dart';
import 'date_select.dart';
import 'diary_database.dart';

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
  String titleText = "";
  String bodyText = "";
  String mood = "";
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
      titleText = widget.diaryEntry?.title ?? "";
      bodyText = widget.diaryEntry?.body ?? "";
      mood = widget.diaryEntry?.mood ?? "";
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
    final newDiary = Diary(
        createdDate: selectedDate,
        body: bodyText,
        title: titleText,
        mood: mood
    );

    widget.addDiaryEntry(newDiary);

    // if (widget.diaryEntry != null) {
    //   widget.updateDiaryEntry(
    //       widget.diaryEntry ?? Diary(createdDate: DateTime.now(), body: ""),
    //       newDiary
    //   );
    // }
    // else {
    //   widget.addDiaryEntry(newDiary);
    // }
  }

  Future<bool> _showAlertDialog() async {
    return await showDialog<bool>(
      // return values info: DISCARD - true; CANCEL - false.
      // And it'll enable cancel by default
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Do you want to discard the changes?'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // popping from dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('DISCARD'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope is to show alert message even when pressing back button while
    // editing diary.
    return WillPopScope(
      onWillPop: _showAlertDialog,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Diary App"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            // When cancel is pressed and if there are any text in state show dialog
            // or else don't show alert dialog, just pop to the home page.
            onPressed:
              // Condition to show alert dialog
              (bodyText.isNotEmpty && bodyText != widget.diaryEntry?.body) ?
              () async {
                final discarded = await _showAlertDialog();
                // This is to avoid using context in async tasks. (Referred SO)
                if (!mounted) return;

                if (discarded) {
                  // return to home page when creating a diary. Otherwise return to
                  // diary view by setting up isEdit false.
                  // TODO: Bug - Keyboard pop up and down when navigator is popped
                  if (widget.diaryEntry == null) {
                    Navigator.pop(context); // popping from dialog
                  }
                  else {
                    widget.setIsEdit(false);
                  }
                }
              } : () => Navigator.pop(context),
          ),

          actions: <Widget> [
            IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  _saveDiaryEntry();
                  widget.setIsEdit(false);
                  // TODO: Think of any other way to avoid popping to diary list done creating a diary
                  // Popping to diary list when creating an entry.
                  if (widget.diaryEntry == null) {
                    Navigator.pop(context);
                  }
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

              DateSelect(
                createdDate: selectedDate,
                isView: false,
                onDateTap: () {
                  _selectDate(context);
                },
                onEmojiTap: () {},
              ),

              const Divider(),

              // Title text field
              Container(
                padding: const EdgeInsets.only(bottom: 3),
                child: TextField(
                  controller: titleController,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: "Title",
                  ),
                ),
              ),

              // Diary body text field
              Container(
                padding: const EdgeInsets.only(top: 3),
                child: Expanded(
                  // maxLines: null,
                  child: TextField(
                    controller: bodyController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.3
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: "Write here..."
                    ),
                    maxLines: null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

