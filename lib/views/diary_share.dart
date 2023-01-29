import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:diary_app/models/diary_model.dart';

class DiaryShare extends StatelessWidget {
  const DiaryShare({super.key, required this.diaryEntry});

  final Diary diaryEntry;

  void _onShareData(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    String datePart = '${diaryEntry.createdDate.day.toString().padLeft(2, '0')}/'
                      '${diaryEntry.createdDate.month.toString().padLeft(2, '0')}/'
                      '${diaryEntry.createdDate.year.toString()}';
    await Share.share(
      diaryEntry.toString(),
      subject: 'Diary ON $datePart',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
    );
  }

  // TODO: Enable sharing for Whatsapp, FB...
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
            onPressed: () => _onShareData(context),
            icon: const Icon(Icons.share)
        );
      }
    );
  }
}
