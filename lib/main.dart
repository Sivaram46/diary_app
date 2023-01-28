import 'package:diary_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'diary_homepage.dart';

// TODO: Bug - Read password from shared prefs not working
void readPasswordPrefs(void Function(bool) setPasswordStatus,
    void Function(String) setPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool("passwordStatus") ?? false;
  String pwd = prefs.getString("password") ?? "";
  setPasswordStatus(status);
  setPassword(pwd);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool _isDark = true;
  bool _isLock = false;
  bool _isLockFirstTime = false;
  String _password = "0000";

  void setTheme(bool mode) {
    setState(() {
      _isDark = mode;
    });
  }

  void setIsLock(bool isLock) {
    setState(() {
      _isLock = isLock;
    });
  }

  void setIsLockFirstTime(bool isLockFirstTime) {
    setState(() {
      _isLockFirstTime = isLockFirstTime;
    });
  }

  void setPassword(String password) {
    setState(() {
      _password = password;
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
      title: "Memoir",
      theme: _isDark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: _isLock
          ? LoginPage(
              password: _password,
              theme: _isDark,
              isLock: _isLock,
              isLockFirstTime: _isLockFirstTime,
              setPassword: setPassword,
              setTheme: setTheme,
              setIsLock: setIsLock,
            )
          : DiaryHomePage(
              title: "Memoir",
              password: _password,
              theme: _isDark,
              isLock: _isLock,
              isLockFirstTime: _isLockFirstTime,
              setPassword: setPassword,
              setTheme: setTheme,
              setIsLock: setIsLock,
            ),
    );
  }
}
