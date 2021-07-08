import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:terminal/Components/RoundedRectangleButton.dart';
import 'package:terminal/Controllers/HTTPServices.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Controllers/ProcessingControllers.dart';
import 'package:terminal/Screens/TableNumber.dart';


class Login extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var id = TextEditingController();
  String readyId = "4fbdc789-2a67-4063-ad4b-091047d9e0fc";

  int checkCode;
  bool authentication;

  bool isVisible = false;
  String errorMessage = '';

  ProcessingControllers services = new ProcessingControllers();
  HTTPServices httpServices = new HTTPServices();
  SqliteController sqliteController = new SqliteController();


  void startup() async {
    sqliteController.clearsOrder();
    services.logOut();
  }

  @override
  void initState() {
    super.initState();
    startup();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/main_top.png',
                      )
                    ],
                  )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter Terminal Pairing ID ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 400,
                            child: TextFormField(
                              controller: id,
                              style: TextStyle(color: Colors.black54),
                              decoration: InputDecoration(
                                hintText: 'ID',
                                hintStyle: TextStyle(color: Colors.black54),
                                icon: Icon(
                                  Icons.account_circle_rounded,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        RoundedRectangleButton(
                          text: "Sign In",
                          accentColor: Colors.pinkAccent,
                          onPressed: () async {
                            if (id.text.isNotEmpty) {
                              bool response =
                                  await httpServices.authenticate(readyId);
                              if (response == true) {
                                Navigator.pushReplacementNamed(
                                    context, TableNumber.id);
                              } else if (response == false) {
                                setState(() {
                                  isVisible = true;
                                  id.text = "";
                                  errorMessage = 'Wrong ID';
                                });
                              }
                              else {
                                setState(() {
                                  isVisible = true;
                                  id.text = "";
                                  errorMessage =
                                  '    Something went wrong \ncontact customer support';
                                });
                              }
                            }else if (id.text.isEmpty) {
                              setState(() {
                                isVisible = true;
                                id.text = "";
                                errorMessage = 'ID Field is Empty';
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Visibility(
                            visible: isVisible,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset('assets/login_bottom.png'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
