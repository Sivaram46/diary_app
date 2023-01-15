import 'dart:io';

import 'package:diary_app/diary_database.dart';
import 'package:diary_app/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import 'constants.dart';

class DiaryDrawer extends StatefulWidget {
  const DiaryDrawer({
    super.key,
    required this.theme,
    required this.setTheme,
  });

  final bool theme;
  final void Function(bool) setTheme;

  @override
  State<DiaryDrawer> createState() => _DiaryDrawerState();
}

class _DiaryDrawerState extends State<DiaryDrawer> {
  bool _isLock = false;
  bool _isNotif = false;
  String _oldPassword = "";
  String _password = "";
  String _retypePassword = "";

  @override
  void initState() {
    super.initState();
    readPasswordPrefs();
    _password = "";
    _retypePassword = "";
  }

  void readPasswordPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool enabled = prefs.getBool("passwordStatus") ?? false;
    String oldPassword = prefs.getString("password") ?? "";
    setState(() {
      _isLock = enabled;
      _oldPassword = oldPassword;
    });
  }

  void writePasswordPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("passwordStatus", _isLock);
    await prefs.setString("password", _password);
  }

  void writeTheme(bool theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', theme);
  }

  Future<void> _setPassword(BuildContext parentContext) async {
    return await showDialog<void>(
      context: parentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Set Password'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Switch to enable/disable password
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLock = !_isLock;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          const Expanded(child: Text('Enable Password')),
                          Switch(
                            value: _isLock,
                            onChanged:(bool value) {
                              setState(() {
                                _isLock = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // If switch is enabled, show form to fill up password
                    _isLock ? Column(
                      children: <Widget>[
                        TextField(
                          maxLength: 4,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Password'
                          ),
                          onChanged: (text) {
                            setState(() {
                              _password = text;
                            });
                          },
                        ),
                        TextField(
                          maxLength: 4,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                              hintText: 'Retype Password'
                          ),
                          onChanged: (text) {
                            setState(() {
                              _retypePassword = text;
                            });
                          },
                        ),

                        (_password.length == 4 && _retypePassword.isNotEmpty && _password != _retypePassword) ? const Text(
                          "Passwords mismatch!",
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ) : Container(height: 0,)
                      ],
                    ) : Container(height: 0,),
                  ],
                ),

                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_password.length == 4 && (_password == _retypePassword)) {
                        setState(() {
                          _isLock = true;
                        });
                        // Save password to disk
                        writePasswordPrefs();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('SET'),
                  ),
                ],
              );
            },
        );
      },
    );
  }

  Future<void> _importExport(BuildContext parentContext) async {
    await showDialog<bool>(
      context: parentContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Import/Export Diary Entries'),
        content: FutureBuilder<List<Diary>>(
          future: getDiariesFromDB(),
          builder: (context, snapshot) {
            // TODO: Better UI for import and exporting
            return Column(
              children: <Widget>[
                // Export functionality
                ElevatedButton(
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      // If permission not granted, request it.
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      }
                      else {
                        // TODO: use external_path library to get correct paths
                        if (Platform.isAndroid && snapshot.hasData) {
                          final diaryEntries = snapshot.data ?? [];
                          String fileName = DateTime.now().toString().split(".")[0];
                          fileName = fileName.replaceAll(" ", "--").replaceAll(":", "-");
                          fileName = "/storage/emulated/0/Download/Memoir-$fileName.txt";

                          final backupFile = File(fileName);

                          String result = "";
                          for (final entry in diaryEntries) {
                            result += "${entry.toCSVLine()}\n";
                          }
                          backupFile.writeAsString(result);
                        }
                      }
                    },
                    child: const Text("Export")
                ),

                // Import functionality
                ElevatedButton(
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      // If permission not granted, request it.
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      }
                      else {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          dialogTitle:  "Pick a file to import. "
                                        "Filename in the form of Memoir-<timestamp>.csv. "
                                        "By importing, ALL existing data would be LOST",
                          type: FileType.custom,
                          allowedExtensions: ["txt"],
                        );
                        if (result != null) {
                          // Read diary contents from backup file
                          // TODO: File name format check
                          String path = result.files.first.path ?? "";
                          if (path.isNotEmpty) {
                            File backupFile = File(path);
                            List<String> contents = await backupFile.readAsLines();
                            List<Diary> diaryEntries = contents.map(
                              (e) => Diary.fromCSVLine(e)
                            ).toList();

                            // Wipe out existing data and write to database
                            wipeAndInsertIntoDB(diaryEntries);
                            setState(() {});
                          }
                        }
                      }
                    },
                    child: const Text("Import")
                ),
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
          Container(
            alignment: Alignment.bottomLeft,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
              'Memoir',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(),

          ListTile(
            leading: widget.theme
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.brightness_6),
            title: const Text("Change Theme"),
            onTap: () {
              widget.setTheme(!widget.theme);
              writeTheme(!widget.theme);
            },
          ),
          const Divider(),

          // Pass word setter
          ListTile(
            leading:
                _isLock ? const Icon(Icons.lock) : const Icon(Icons.lock_open),
            title: const Text('App Lock'),
            onTap: () {
              _setPassword(context);
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
