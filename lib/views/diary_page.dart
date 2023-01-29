import 'package:flutter/material.dart';

import 'diary_view.dart';
import 'diary_edit.dart';
import 'package:diary_app/models/diary_model.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({
    super.key,
    required this.diaryEntry,
    required this.updateDiaryEntry,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
    required this.isEdit,
  });

  final Diary diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary) updateDiaryEntry;
  final bool isEdit;

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {

  bool isEdit = false;
  Diary diary = Diary(createdDate: DateTime.now());

  @override
  void initState() {
    super.initState();
    isEdit = widget.isEdit;
    diary = widget.diaryEntry;
  }

  void setIsEdit(bool newIsEdit) {
    setState(() {
      isEdit = newIsEdit;
    });
  }

  void setDiaryEntry(Diary newDiaryEntry) {
    setState(() {
      diary = newDiaryEntry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    // TODO: Add some animation when switching from one to other
      isEdit ?
      DiaryEdit(
        diaryEntry: widget.diaryEntry,
        updateDiaryEntry: widget.updateDiaryEntry,
        addDiaryEntry: widget.addDiaryEntry,
        setIsEdit: setIsEdit,
        setDiaryEntry: setDiaryEntry,
      ) :
      DiaryView(
        diaryEntry: widget.diaryEntry,
        deleteDiaryEntry: widget.deleteDiaryEntry,
        setIsEdit: setIsEdit,
      );
  }
}
