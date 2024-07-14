import 'package:flutter/material.dart';
import 'userselection.dart';
import 'dart:async';

// Define light theme
final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  // Define other light mode specific properties
);

// Define dark theme
final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  // Define other dark mode specific properties
);





class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkTheme; // Initialize with a default theme
  ThemeData getTheme() => _themeData;//_themeData


  void toggleTheme() {
    _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    user.isdark=!user.isdark;
    notifyListeners();
  }

}


//for search bar looping hint text
class TimerProvider with ChangeNotifier {
  late Timer _timer;
  int _hintIndex = 0;
  final List<String> _hints = ["search", "keyword", "Modi", "Trump"];
  static bool isSearching=true;

  TimerProvider() {
    // Constructor without starting timer directly
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      _hintIndex = (_hintIndex + 1) % _hints.length;
      notifyListeners(); // Notify listeners after updating state
    });
  }

  int get hintIndex => _hintIndex;

  List<String> get hints => _hints;
  bool get searching=> isSearching;

  void stopSearchbar()
  {
    isSearching=false;
    notifyListeners();
  }
  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer if it's not null
    super.dispose();
  }
}
