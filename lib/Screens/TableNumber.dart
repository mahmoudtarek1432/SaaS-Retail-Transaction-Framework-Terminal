import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:terminal/Components/RoundedRectangleButton.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Models/User.dart';
import 'package:terminal/Screens/Loading.dart';

class TableNumber extends StatefulWidget {
  static const String id = 'tableNumber';

  @override
  _TableNumberState createState() => _TableNumberState();
}

class _TableNumberState extends State<TableNumber> {

  var tableNumberController = TextEditingController();
  int tableNumber = 0;

  bool isVisible = false;
  String errorMessage = '';

  SqliteController sqliteController = new SqliteController();

  @override
  void initState() {
    super.initState();
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
                          'Enter Table Number ',
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
                          child:Container(
                            width: 400,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              controller: tableNumberController,
                              style: TextStyle(color: Colors.black54),
                              decoration: InputDecoration(
                                hintText: 'Table Number',
                                hintStyle: TextStyle(color: Colors.black54),
                                icon: Icon(
                                  Icons.add_to_queue,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        RoundedRectangleButton(
                          text: "Proceed to menu",
                          accentColor: Colors.pinkAccent,
                          onPressed: () async{
                            if (tableNumberController.text.isNotEmpty) {
                              tableNumber = int.parse(tableNumberController.text);
                              User user = await sqliteController.getUser();
                              await sqliteController.updateTableNumber(tableNumber, user.token);
                              Navigator.pushReplacementNamed(context, Loading.id);
                              }
                            else if (tableNumberController.text.isEmpty) {
                              setState(() {
                                isVisible = true;
                                errorMessage = 'Table number field is empty';
                              });
                            }else {
                              setState(() {
                                isVisible = true;
                                tableNumberController.text = "";
                                errorMessage =
                                '    Something went wrong \ncontact customer support';
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
