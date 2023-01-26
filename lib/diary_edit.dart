import 'package:flutter/material.dart';
import 'package:sqflite/sqflite_dev.dart';

import 'diary_model.dart';
import 'date_select.dart';
import 'constants.dart' show diaryViewPadding;

class DiaryEdit extends StatefulWidget {
  const DiaryEdit({
    super.key,
    required this.diaryEntry,
    required this.addDiaryEntry,
    required this.updateDiaryEntry,
    required this.setIsEdit,
    required this.setDiaryEntry,
  });

  final Diary diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) updateDiaryEntry;
  final void Function(bool) setIsEdit;
  final void Function(Diary) setDiaryEntry;

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
      titleText = widget.diaryEntry.title;
      bodyText = widget.diaryEntry.body;
      mood = widget.diaryEntry.mood;
      selectedDate = widget.diaryEntry.createdDate;
    });

    titleController.text = widget.diaryEntry.title;
    titleController.addListener(() {
      setState(() {
        titleText = titleController.text;
      });
    });

    bodyController.text = widget.diaryEntry.body;
    bodyController.addListener(() {
      setState(() {
        bodyText = bodyController.text;
      });
    });
  }

  void _saveDiaryEntry() {
    final newDiary = Diary(
      createdDate: selectedDate,
      body: bodyText.trim(),
      title: titleText.trim(),
      mood: mood,
      id: widget.diaryEntry.id
    );

    widget.setDiaryEntry(newDiary);

    if (widget.diaryEntry.body.isNotEmpty) {
      widget.updateDiaryEntry(newDiary);
    }
    else {
      widget.addDiaryEntry(newDiary);
    }
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
      onWillPop: (bodyText.isNotEmpty && bodyText != widget.diaryEntry.body) ? _showAlertDialog : null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Memoir"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            // When cancel is pressed and if there are any text in state show dialog
            // or else don't show alert dialog, just pop to the home page.
            onPressed:
              // Condition to show alert dialog
              (bodyText.isNotEmpty && bodyText != widget.diaryEntry.body) ?
              () async {
                final discarded = await _showAlertDialog();
                // This is to avoid using context in async tasks. (Referred SO)
                if (!mounted) return;

                if (discarded) {
                  // return to home page when creating a diary. Otherwise return to
                  // diary view by setting up isEdit false.
                  // TODO: Bug - Keyboard pop up and down when navigator is popped
                  if (widget.diaryEntry.body.isEmpty) {
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
                  Navigator.pop(context);
                },
            ),
          ]
        ),

        body: Padding(
          padding: const EdgeInsets.all(diaryViewPadding,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              DateSelect(
                createdDate: selectedDate,
                isView: false,
                onDateTap: () {
                  _selectDate(context);
                },
                onEmojiTap: () {},
              ),

              const Divider(height: diaryViewPadding,),

              // Title text field
               TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  hintText: "Title",
                ),
              ),

              const SizedBox(height: diaryViewPadding/2,),

              // Diary body text field
              // TODO: Body font size can be increased
              Expanded(
                // maxLines: null,
                child: TextField(
                  controller: bodyController,
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
            ],
          ),
        ),
      ),
    );
  }
}

