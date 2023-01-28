import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'constants.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({
    super.key,
    required this.password,
    required this.isLock,
    required this.isLockFirstTime,
    required this.setPassword,
    required this.setIsLock,
  });

  final String password;
  final bool isLock;
  final bool isLockFirstTime;
  final void Function(bool) setIsLock;
  final void Function(String) setPassword;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool _isLock = true;
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
        widget.setPassword(matchedText);
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
      correctString: widget.password,
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
    if (!widget.isLockFirstTime) {
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
    _isLock = widget.isLock;
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
                    widget.setIsLock(_isLock);
                    if (widget.isLockFirstTime && _isLock) {
                      _setNewPassword();
                    }
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
                        widget.setIsLock(value);
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
