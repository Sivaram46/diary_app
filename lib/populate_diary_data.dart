import 'diary_model.dart';

/*
First diary entry
-----------------
This is my first diary entry I had written in this app. I am so glad to develop such app.

Looking forward to make changes in the app and make it working.

About by day
------------
Today I went to work as usual, they assigned me a bug and tried to fix the bug.

Although that bug can be fixed in like 2 hours, I took almost the day. Played carrom, TT...

*/

final _someValues = <Diary>[
  Diary(createdDate: DateTime(2022, 1, 15), body: """At the same time that the scale and accuracy of deep networks has increased, so has the complexity of the tasks that they can solve. Goodfellow et al. (2014d) showed that neural networks could learn to output an entire sequence of characters transcribed from an image, rather than just identifying a single object. Previously, it was widely believed that this kind of learning required labeling of the individual elements of the sequence (Gülçehre and Bengio, 2013). Recurrent neural networks, such as the LSTM sequence model mentioned above, are now used to model relationships between sequences and other sequences rather than just fixed inputs.
This sequence-to-sequence learning seems to be on the cusp of revolutionizing another application: machine translation (Sutskever et al., 2014; Bahdanau et al.,
2015).
      """, title: "Deep learning", mood: "happy"),
  Diary(createdDate: DateTime(2021, 13, 4), body: """
  Map<String, int> numMoons, moreMoons;
  numMoons = const <String,int>{ 'Mars' : 2, 'Jupiter' : 27 };
  List<String> planets, morePlanets;

you can use .from() like this:

  moreMoons = new Map<String,int>.from(numMoons)
    ..addAll({'Saturn' : 53 });
  planets = new List<String>.from(numMoons.keys);
  morePlanets = new List<String>.from(planets)
    ..add('Pluto');

      """, title: "Cloning in Dart", mood: "sad"),
  Diary(createdDate: DateTime(2022, 31, 3), body: """
      Often, you not only want to navigate to a new screen, but also pass data to the screen as well. For example, you might want to pass information about the item that’s been tapped.

Remember: Screens are just widgets. In this example, create a list of todos. When a todos is tapped, navigate to a new screen (widget) that displays information about the todoss This recipe uses the following steps:

    Define a todos class.
    Display a list of todos.
    Create a detail screen that can display information about a todos.
    Navigate and pass data to the detail screen.

      """),
  Diary(createdDate: DateTime(30, 4, 2020), body: """
      Google Fonts is a library of 1474 open source font families and APIs for convenient use via CSS and Android. The library also has delightful and beautifully crafted icons for common actions and items. Download them for use in your digital products for Android, iOS, and web.
      """, title: "Google fonts")
];

List<String> getDiaryData() {
  return _someValues.map((diary) => Diary.toJSONString(diary)).toList();
}



