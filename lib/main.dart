import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'themes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<TimerProvider>(create: (_) => TimerProvider()),
    ],

      child: MyApp(),),


  );
}
//for check the internet or wifi is on or off
class ConnectivityCheckScreen extends StatefulWidget {
  @override
  _ConnectivityCheckScreenState createState() => _ConnectivityCheckScreenState();
}

class _ConnectivityCheckScreenState extends State<ConnectivityCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // Connected to the internet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthCheck()),
      );
    } else {
      // Not connected to the internet
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkConnectivity(); // Retry checking connectivity
              },
              child: Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading indicator while checking connectivity
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState()
  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'News App',
          theme: themeProvider.getTheme(),
          home:ConnectivityCheckScreen(),
        );
      },
    );
  }
}

//first check user are login or not
class AuthCheck extends StatefulWidget {
  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  @override
  void initState()
  {
    super.initState();
    Refresh();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          //return selectCountry();
          return homeScreen();
        } else {
          return loginPage();
        }
      },
    );
  }
}

