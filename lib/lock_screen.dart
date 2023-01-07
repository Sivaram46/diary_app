// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({
    super.key,
    required this.password
  });

  final String password;

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  late final TextEditingController _textEditingController;
  final List<int> _password = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  TextButton _getNumberButton(int num) {
    return TextButton(
        onPressed: () {
          setState(() {
            if (_password.length < 4) {
              _password.add(num);
            }
          });
        },
        style: TextButton.styleFrom(
            shape: const CircleBorder(),
            textStyle: const TextStyle(
              fontSize: 40,
            )
        ),
        child: Text(num.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> numButtons = [];
    for (int i = 1; i < 10; i++) {
      numButtons.add(_getNumberButton(i));
    }

    // adding delete button
    numButtons.add(
      TextButton(
        onPressed: () {
          setState(() {
            _password.removeLast();
          });
        },
        onLongPress: () {
          setState(() {
            _password.clear();
          });
        },
        style: TextButton.styleFrom(
            shape: const CircleBorder(),
            textStyle: const TextStyle(
              fontSize: 40,
            )
        ),
        child: const Icon(Icons.backspace_outlined, size: 35,),
      )
    );

    // adding 0 number
    numButtons.add(_getNumberButton(0));

    // adding done button
    numButtons.add(
      TextButton(
        onPressed: () {
          setState(() {
            String enteredPwd = _password.join();
            if (enteredPwd == widget.password) {
              AppLock.of(context)!.didUnlock('some data');
            }
            else {
              const incorrectPwdSnackbar = SnackBar(
                content: Text('Incorrect Password'),
              );
              ScaffoldMessenger.of(context).showSnackBar(incorrectPwdSnackbar);
            }
          });
        },
        style: TextButton.styleFrom(
            foregroundColor: Colors.green,
            shape: const CircleBorder(),
            textStyle: const TextStyle(
              fontSize: 40,
            )
        ),
        child: const Icon(Icons.done, size: 40,),
      )
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                (_password.isNotEmpty) ? const Icon(Icons.circle) : const Icon(Icons.circle_outlined),
                (_password.length > 1) ? const Icon(Icons.circle) : const Icon(Icons.circle_outlined),
                (_password.length > 2) ? const Icon(Icons.circle) : const Icon(Icons.circle_outlined),
                (_password.length > 3) ? const Icon(Icons.circle) : const Icon(Icons.circle_outlined),
              ],
            ),
            SizedBox(
              height: 520,
              child: GridView.count(
                crossAxisCount: 3,
                children: numButtons,
              ),
            ),

            // TextField(
            //   key: const Key('PasswordField'),
            //   controller: _textEditingController,
            // ),
            // ElevatedButton(
            //   key: const Key('UnlockButton'),
            //   child: const Text('Go'),
            //   onPressed: () {
            //     if (_textEditingController.text == '0000') {
            //       AppLock.of(context)!.didUnlock('some data');
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
