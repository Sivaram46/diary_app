import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'utils.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key, required this.sharedPref,});

  final SharedPreferences sharedPref;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool _isLock = false;
  String _password = "";
  bool _isLockFirstTime = false;

  void _setNewPassword() {
    final controller = InputController();
    screenLockCreate(
      title: const Text("Please enter new password"),
      confirmTitle: const Text("Please confirm new password"),
      useBlur: false,
      config: ScreenLockConfig(
        backgroundColor: Theme.of(context).backgroundColor,
        buttonStyle: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0),
          side: BorderSide.none,
        ),
      ),
      context: context,
      inputController: controller,

      onConfirmed: (matchedText) {
        // set confirmed password and pop out the dialog
        widget.sharedPref.setString("password", matchedText);
        Navigator.of(context).pop();
      },

      footer: TextButton(
        onPressed: () {
          // Release the confirmation state and return to the initial input state.
          controller.unsetConfirmed();
        },
        child: const Text('Reset input'),
      ),
    );
  }

  void _verifyOldPassword(BuildContext context) {
    screenLock(
      title: const Text("Please enter old password"),
      context: context,
      correctString: _password,
      useBlur: false,
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
      },

    );
  }

  void _setPassword(BuildContext context) {
    if (!_isLockFirstTime) {
      // TODO: Find out why it is not showing in the order defined
      _setNewPassword();
      _verifyOldPassword(context);
    }
    else {
      _setNewPassword();
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLock = widget.sharedPref.getBool("isLock") ?? false;
    });

    setState(() {
      _password = widget.sharedPref.getString("password") ?? "";
    });

    if (_password.isEmpty) {
      _isLockFirstTime = true;
    }

    // print("is locked (set pwd): $_isLock");
    // print("password (set pwd): $_password");
    // print("is lock first time (set pwd) $_isLockFirstTime");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Set Diary Lock"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(diaryViewPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Switch to enable/disable password
              InkWell(
                onTap: () {
                  setState(() {
                    _isLock = !_isLock;
                    if (_isLockFirstTime && _isLock) {
                      _setNewPassword();
                    }
                    widget.sharedPref.setBool("isLock", _isLock);
                  });
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Enable Password",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Switch(
                      value: _isLock,
                      onChanged: (bool value) {
                        setState(() {
                          _isLock = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Set password manually
              InkWell(
                onTap: () {
                  _setPassword(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Set Password",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "Set or change password",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const Divider(),
            ],
          ),
        ));
  }
}
