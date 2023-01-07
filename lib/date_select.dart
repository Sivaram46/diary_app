import 'package:diary_app/constants.dart';
import 'package:flutter/material.dart';

class DateSelect extends StatelessWidget {
  const DateSelect({
    super.key,
    required this.createdDate,
    required this.isView,
    required this.onDateTap,
    required this.onEmojiTap,
  });

  final DateTime createdDate;
  final bool isView;
  final void Function()? onDateTap;
  final void Function()? onEmojiTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // date select
          InkWell(
            onTap: onDateTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  createdDate.day.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                Text(
                  " ${monthMap[createdDate.month] ?? ""}, ${createdDate.year}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                !isView ? const Icon(Icons.arrow_drop_down) : Container(height: 0,),
              ],
            ),
          ),

          // emoji select
          const Icon(
            Icons.emoji_emotions,
            size: 30,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }
}
