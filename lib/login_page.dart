import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'diary_homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.password,
    required this.theme,
    required this.isLock,
    required this.isLockFirstTime,
    required this.setPassword,
    required this.setTheme,
    required this.setIsLock,
  });

  final String password;
  final bool theme;
  final bool isLock;
  final bool isLockFirstTime;
  final void Function(String) setPassword;
  final void Function(bool) setTheme;
  final void Function(bool) setIsLock;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Use Future.delayed to show the lock menu instead of using onPressed on the button
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text("You are not logged in. Please login to continue"),
          ElevatedButton(
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
                              title: "Memoir",
                              password: widget.password,
                              theme: widget.theme,
                              isLock: widget.isLock,
                              isLockFirstTime: widget.isLockFirstTime,
                              setPassword: widget.setPassword,
                              setTheme: widget.setTheme,
                              setIsLock: widget.setIsLock,
                            )));
                  },
                );
              },
              child: const Text("Login")),
        ],
      ),
    );
  }
}

/*
ElevatedButton(
  onPressed: () => screenLock(
    context: context,
    correctString: '1234',
    onUnlocked: () {
      Navigator.pop(context);
      NextPage.show(context);
    },
  ),
  child: const Text('Next page with unlock'),
),

ElevatedButton(
  onPressed: () {
    // Define it to control the confirmation state with its own events.
    final controller = InputController();
    screenLockCreate(
      context: context,
      inputController: controller,
      onConfirmed: (matchedText) =>
          Navigator.of(context).pop(),
      footer: TextButton(
        onPressed: () {
          // Release the confirmation state and return to the initial input state.
          controller.unsetConfirmed();
        },
        child: const Text('Reset input'),
      ),
    );
  },
  child: const Text('Confirm mode'),
),

ElevatedButton(
  onPressed: () => screenLock(
    context: context,
    correctString: '1234',
    useBlur: false,
    config: const ScreenLockConfig(
      /// If you don't want it to be transparent, override the config
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(fontSize: 24),
    ),
  ),
  child: const Text('Not blur'),
),

*/
