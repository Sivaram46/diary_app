import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'diary_homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.theme,
    required this.setTheme,
    required this.password,
    required this.sharedPref,
  });

  final bool theme;
  final String password;
  final void Function(bool) setTheme;
  final SharedPreferences sharedPref;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Use Future.delayed to show the lock menu instead of using onPressed on the button
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Theme.of(context).cardColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircleAvatar(
                      backgroundColor: Color(0xffa1ade1),
                      radius: 18,
                      child: Icon(
                        Icons.edit_note,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.compare_arrows,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.lock,
                      size: 30,
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                Text(
                  "Memoir is password protected.\nPlease enter your password to continue!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 10,),


                TextButton(
                    onPressed: () {
                      screenLock(
                        context: context,
                        correctString: widget.password,
                        useBlur: false,
                        title: const Text("Please enter your password"),
                        config: ScreenLockConfig(
                          backgroundColor: Theme.of(context).backgroundColor,
                          buttonStyle: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(0),
                            side: BorderSide.none,
                          ),
                        ),
                        onUnlocked: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DiaryHomePage(
                                    theme: widget.theme,
                                    setTheme: widget.setTheme,
                                    sharedPref: widget.sharedPref,
                                  )));
                        },
                      );
                    },
                    child: Text("Enter Password",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.fontSize))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
