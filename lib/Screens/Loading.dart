import 'package:flutter/material.dart';
import 'package:terminal/Models/User.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Screens/Login.dart';
import 'package:terminal/Screens/MainMenu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terminal/Controllers/HTTPServices.dart';

class Loading extends StatefulWidget {
  static const String id = 'loading';
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  SqliteController sqliteController = new SqliteController();
  HTTPServices httpServices = new HTTPServices();

  User user;
  bool checkToken;
  bool validateToken;
  int checkCode;

  Future startUpTerminal() async {
    checkToken = await sqliteController.checkUserToken();
    if (checkToken == true) {
      user = await sqliteController.getUser();
      validateToken = await httpServices.validateToken();
      if (validateToken == true) {
        checkCode = await httpServices.checkForUpdates();
        await determinationAction(checkCode);
      } else if (validateToken == false) {
        logOut();
        Navigator.pushReplacementNamed(context, Login.id);
      }
    } else if (checkToken == false) {
      Navigator.pushReplacementNamed(context, Login.id);
    }
  }

  Future setupMenu() async {
    final settings = await sqliteController.getSettings();
    final categories = await sqliteController.getAllCategories();

    new Future.delayed(const Duration(seconds: 0), () {
      Navigator.pushReplacementNamed(context, MainMenu.id, arguments: {
        'Settings': settings,
        'Category': categories,
      });
    });
  }

  Future determinationAction(int code) async {
    try {
      //all is fine
      if (code == 1) {
        await setupMenu();
      }
      //If menu is outdated
      else if (code == 2) {
        sqliteController.clearMenu();
        final menu = await httpServices.getMenu();
        await sqliteController.insertMenu(menu);
        await setupMenu();
      }
      //If settings is outdated
      else if (code == 3) {
        sqliteController.clearSettings();
        final settings = await httpServices.getUserSettings();
        await sqliteController.insertSettings(settings);
        await setupMenu();
      }
      //If both settings and menu outdated
      else if (code == 4) {
        sqliteController.clearSettings();
        sqliteController.clearMenu();
        final settings = await httpServices.getUserSettings();
        final menu = await httpServices.getMenu();
        await sqliteController.insertSettings(settings);
        await sqliteController.insertMenu(menu);
        await setupMenu();
      }else if (code == 5){
        print("Something went wrong code 5");
      }else{
        print("Error");
      }
    } catch (e) {
      print('error caught: $e');
    }
  }

  Future logOut() async{
     sqliteController.deleteUser();
     sqliteController.clearMenu();
     sqliteController.clearSettings();
     sqliteController.clearsOrder();
  }

  @override
  void initState() {
    super.initState();
    startUpTerminal();
  }

  @override
  void dispose(){
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitWave(
          color: Colors.green,
          size: 200.0,
        ),
      ),
    );
  }
}
