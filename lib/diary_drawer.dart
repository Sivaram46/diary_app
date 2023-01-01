import 'package:diary_app/diary_model.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class DiaryDrawer extends StatefulWidget {
  const DiaryDrawer({Key? key}) : super(key: key);

  @override
  State<DiaryDrawer> createState() => _DiaryDrawerState();
}

class _DiaryDrawerState extends State<DiaryDrawer> {
  bool _lightTheme = true;
  bool _isLock = false;
  bool _isNotif = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          // Drawer header
          Container(
            alignment: Alignment.bottomLeft,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
              'Diary App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(),

          ListTile(
            leading: _lightTheme
                ? const Icon(Icons.brightness_6)
                : const Icon(Icons.dark_mode),
            title: const Text("Change Theme"),
            onTap: () {
              setState(() {
                _lightTheme = !_lightTheme;
              });
            },
          ),
          const Divider(),

          // Pass word setter
          ListTile(
            leading: _isLock
                ? const Icon(Icons.lock)
                : const Icon(Icons.lock_open),
            title: const Text('App Lock'),
            onTap: () {},
          ),
          const Divider(),


          // set reminder
          ListTile(
            leading: _isNotif
                ? const Icon(Icons.notifications_active)
                : const Icon(Icons.notifications_off),
            title: const Text('Set Daily Reminder'),
            onTap: () {},
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text("Export/Import Entries"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
