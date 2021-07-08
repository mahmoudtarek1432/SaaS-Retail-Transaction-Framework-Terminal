import 'package:flutter/material.dart';
import 'package:terminal/Screens/Loading.dart';
import 'package:terminal/Screens/LoadingDev.dart';
import 'package:terminal/Screens/MainMenu.dart';
import 'package:terminal/Screens/Login.dart';
import 'package:terminal/Screens/OrderPlaced.dart';
import 'package:terminal/Screens/TableNumber.dart';

void main() async {
  runApp(Terminal());
  WidgetsFlutterBinding.ensureInitialized();
}

class Terminal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        toggleableActiveColor: Colors.red[900],
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Loading.id,
      routes: {
        Loading.id: (context) => Loading(),
        Login.id: (context) => Login(),
        TableNumber.id: (context) => TableNumber(),
        MainMenu.id: (context) => MainMenu(),
        OrderPlaced.id: (context) => OrderPlaced(),
        LoadingDev.id: (context) => LoadingDev()
      },
    );
  }
}
