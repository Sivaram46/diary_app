import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/diary_homepage.dart';
import 'views/login_page.dart';
import 'utils/constants.dart';

// TODO: Bug - Read password from shared prefs not working
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPref: sharedPref));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.sharedPref});

  final SharedPreferences sharedPref;

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool _isDark = true;

  bool _isLock = false;
  String _password = "";

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
  void initState() {
    super.initState();

    // widget.sharedPref.clear();

    setState(() {
      _isLock = widget.sharedPref.getBool("isLock") ?? false;
    });

    setState(() {
      _password = widget.sharedPref.getString("password") ?? "";
    });

    // print("Is lock (main): $_isLock");
    // print("password (main): $_password");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: _isDark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: _isLock
          ? LoginPage(
              password: _password,
              sharedPref: widget.sharedPref,
              theme: _isDark,
              setTheme: setTheme,
            )
          : DiaryHomePage(
              sharedPref: widget.sharedPref,
              theme: _isDark,
              setTheme: setTheme,
            ),
    );
  }
}
