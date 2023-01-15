import 'package:diary_app/diary_share.dart';
import 'package:flutter/material.dart';

 import 'diary_model.dart';
 import 'date_select.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({
    super.key,
    required this.diaryEntry,
    required this.deleteDiaryEntry,
    required this.setIsEdit,
  });

  final Diary diaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(bool) setIsEdit;

  Future<bool> _showAlertDialog(BuildContext parentContext) async {
    return await showDialog<bool>(
      context: parentContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this diary entry?'),
        content: const Text('Are you really want to delete this entry. It will be deleted forever'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context, [bool mounted=true]) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memoir"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setIsEdit(true);
              },
          ),

          DiaryShare(diaryEntry: diaryEntry),

          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final res = await _showAlertDialog(context);
                if (res) {
                  deleteDiaryEntry(diaryEntry);
                  // same reason as that of stateful widget. Passing mounted
                  // to build is a workaround to avoid warnings.
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DateSelect(
              createdDate: diaryEntry.createdDate,
              isView: true,
              onDateTap: () {},
              onEmojiTap: () {},
            ),

            const Divider(height: 7,),

            // Show title only when it is not empty
            diaryEntry.title.isNotEmpty
            ? Text(
                diaryEntry.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ) : Container(height: 0,),

            const SizedBox(height: 7,),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  diaryEntry.body,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.3
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

