import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import 'set_password.dart';
import 'package:diary_app/database_access/diary_database.dart';
import 'package:diary_app/models/diary_model.dart';
import 'package:diary_app/utils/constants.dart';

class DiaryDrawer extends StatefulWidget {
  const DiaryDrawer({
    super.key,
    required this.theme,
    required this.setTheme,
    required this.sharedPref,
  });

  final bool theme;
  final void Function(bool) setTheme;
  final SharedPreferences sharedPref;

  @override
  State<DiaryDrawer> createState() => _DiaryDrawerState();
}

class _DiaryDrawerState extends State<DiaryDrawer> {
  bool _isNotif = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _importExport(BuildContext parentContext) async {
    await showDialog<bool>(
      context: parentContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Export/Import Entries"),
        content: FutureBuilder<List<Diary>>(
          future: getDiariesFromDB(),
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                      text: "Export Note: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Your memories will be saved in a file named "
                          "Memoir-<timestamp>.txt in Documents folder.",
                      style: DefaultTextStyle.of(context).style,
                    ),
                  ]),
                ),

                // Export functionality
                ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      // If permission not granted, request it.
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      } else {
                        // TODO: use external_path library to get correct paths
                        if (Platform.isAndroid && snapshot.hasData) {
                          final diaryEntries = snapshot.data ?? [];
                          String fileName =
                              DateTime.now().toString().split(".")[0];
                          fileName = fileName
                              .replaceAll(" ", "--")
                              .replaceAll(":", "-");
                          fileName =
                              "/storage/emulated/0/Download/Memoir-$fileName.txt";

                          final backupFile = File(fileName);

                          String result = "";
                          for (final entry in diaryEntries) {
                            result += "${entry.toCSVLine()}$nextLineDelim";
                          }
                          backupFile.writeAsString(result);
                        }
                      }
                    },
                    label: const Text("Export")),

                RichText(
                  text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                      text: "Import Note: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          "Import will work only if the file is exported using this app. "
                          "Look for exported file under the Downloads folder. After importing, ",
                      style: DefaultTextStyle.of(context).style,
                    ),
                    TextSpan(
                      text: "ALL EXISTING DATA WOULD BE LOST.",
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),

                // Import functionality
                ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      // If permission not granted, request it.
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      } else {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ["txt"],
                        );
                        if (result != null) {
                          // Read diary contents from backup file
                          // TODO: File name format check
                          String path = result.files.first.path ?? "";
                          if (path.isNotEmpty) {
                            File backupFile = File(path);
                            String contents =
                                await backupFile.readAsString();

                            List<String> lines = contents.split(nextLineDelim);
                            lines.removeLast();

                            List<Diary> diaryEntries = lines
                                .map((e) => Diary.fromCSVLine(e))
                                .toList();

                            // Wipe out existing data and write to database
                            await wipeAndInsertIntoDB(diaryEntries);
                            setState(() {});
                          }
                        }
                      }
                    },
                    label: const Text("Import")),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    child: Icon(
                      Icons.edit_note,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Memoir",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: widget.theme
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.brightness_6),
            title: const Text("Change Theme"),
            onTap: () {
              widget.setTheme(!widget.theme);
              widget.sharedPref.setBool("theme", !widget.theme);
            },
          ),
          const Divider(),

          // Pass word setter
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('App Lock'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SetPassword(sharedPref: widget.sharedPref)),
              );
            },
          ),
          const Divider(),

          // set reminder
          // TODO: Feature to set reminder
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
            onTap: () {
              _importExport(context);
            },
          ),
        ],
      ),
    );
  }
}
