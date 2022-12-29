import 'package:flutter/material.dart';
import 'constants.dart';
import 'diary_model.dart';

class DiaryEdit extends StatefulWidget {
  const DiaryEdit({super.key, required this.setDiaryEntries});

  final void Function(Diary, Mode, [int]) setDiaryEntries;

  @override
  State<DiaryEdit> createState() => _DiaryEditState();
}

class _DiaryEditState extends State<DiaryEdit> {
  String? titleText;
  String bodyText = "";
  String? mood;
  DateTime selectedDate = DateTime.now();

/*  AppBar getAppBar({required bool isEdit, required BuildContext context}) {
    List<Widget> appBarActions = isEdit
        ?
        : [
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
    ];

    return AppBar(
        title: const Text("Diary App"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        actions: appBarActions
    );
  }*/

  // DateTime selectedDate = DateTime.now();

  // function to show a dialog to pick date
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary App"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // TODO: show a dialog to confirm like save or discard changes
            Navigator.pop(context);
          },
        ),

        actions: <Widget> [
          IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                final newDiary = Diary(
                  createdDate: selectedDate,
                  body: bodyText,
                  title: titleText,
                  mood: mood
                );
                widget.setDiaryEntries(newDiary, Mode.add);
                Navigator.pop(context);
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
                onPressed: () => _selectDate(context),
                child: Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}")
            ),

            // Title text field
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),

              onChanged: (text) {
                setState(() {
                  titleText = text;
                });
              },
            ),

            // Diary body text field
            // TODO: The typing text should wrap the screen
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Write here..."
              ),

              onChanged: (text) {
                setState(() {
                  bodyText = text;
                });
              },
            ),
          ],
        ),
      )
    );
  }
}

