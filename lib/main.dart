import 'package:flutter/material.dart';
import 'diary_edit.dart';
import 'diary_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DiaryHomePage(title: "Diary App")
    );
  }
}

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({super.key, required this.title});

  final String title;

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),

        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      body: const Center(
        child: DiaryList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Calendar"
          ),
        ],
      ),
    );
  }
}
