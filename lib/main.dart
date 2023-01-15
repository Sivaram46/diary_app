import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

import 'diary_homepage.dart';
import 'lock_screen.dart';

// TODO: Bug - Read password from shared prefs not working
void readPasswordPrefs(
  void Function(bool) setPasswordStatus,
  void Function(String) setPassword
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool("passwordStatus") ?? false;
  String pwd = prefs.getString("password") ?? "";
  setPasswordStatus(status);
  setPassword(pwd);
}

void main({
  Duration backgroundLockLatency = const Duration(seconds: 1),
}) {
  // Set default password status and password
  String password = "0000";
  bool enabled = false;
  void setPasswordStatus(bool status) { enabled = status; }
  void setPassword(String pwd) { password = pwd; }
  // Read it from disk
  readPasswordPrefs(setPasswordStatus, setPassword);

  runApp(AppLock(
    builder: (arg) => const MyApp(
      key: Key('MyApp'),
    ),
    lockScreen: LockScreen(
      key: const Key('LockScreen'),
      password: password,
    ),
    enabled: enabled,
    backgroundLockLatency: backgroundLockLatency,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool _isDark = true;

  void setTheme(bool mode) {
    setState(() {
      _isDark = mode;
    });
  }

  void readTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool theme = prefs.getBool('theme') ?? true;
    setTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Diary App',
        theme: _isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
        home: DiaryHomePage(
          title: "Diary App",
          theme: _isDark,
          setTheme: setTheme,
        ),
    );
  }
}

