import 'package:flutter/material.dart';
import 'diary_model.dart';
import 'diary_view.dart';
import 'diary_edit.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({
    super.key,
    this.diaryEntry,
    required this.updateDiaryEntry,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
    required this.isEdit,
  });

  final Diary? diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary, Diary) updateDiaryEntry;
  final bool isEdit;

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isEdit = widget.isEdit;
    });
  }

  void setIsEdit(bool newIsEdit) {
    setState(() {
      isEdit = newIsEdit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      isEdit ?
      DiaryEdit(
        diaryEntry: widget.diaryEntry,
        updateDiaryEntry: widget.updateDiaryEntry,
        addDiaryEntry: widget.addDiaryEntry,
        deleteDiaryEntry: widget.deleteDiaryEntry,
        setIsEdit: setIsEdit,
      ) :
      DiaryView(
        diaryEntry: widget.diaryEntry ?? Diary(createdDate: DateTime.now(), body: ""),
        updateDiaryEntry: widget.updateDiaryEntry,
        addDiaryEntry: widget.addDiaryEntry,
        deleteDiaryEntry: widget.deleteDiaryEntry,
        setIsEdit: setIsEdit,
      );
  }
}
