import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terminal/Models/Settings.dart';
import 'package:terminal/Components/RoundedRectangleButton.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Screens/Loading.dart';
import 'package:terminal/Controllers/HTTPServices.dart';
import 'package:terminal/Controllers/ProcessingControllers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';



class OrderPlaced extends StatefulWidget {
  static const String id = 'OrderPlaced';
  const OrderPlaced({Key key}) : super(key: key);

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {

  String orderStatus = "Pending";
  Color orderStatusColor = Colors.yellow;
  Map userData={};
  Settings settings;
  bool buttonVisible =false;
  HTTPServices httpServices = new HTTPServices();
  ProcessingControllers services = new ProcessingControllers();
  SqliteController sqliteController = new SqliteController();


  Future startOrderWebSocket () async{
    final channel = WebSocketChannel.connect(Uri.parse("ws://192.168.43.118:84"));
    channel.stream.listen((data) {
      String message = data;
      String connectionID = "";
      if(message.substring(0,7) == "ConnID:"){
        connectionID = message.substring(7);
        httpServices.webSocketConfirm(connectionID);
      }else{
        Map response = json.decode(message);
        int code = response['type'];
        if (code == 10){
          setState(() {
            orderStatus = "Confirmed";
            orderStatusColor = Colors.green;
          });
        }else if(code == 11){
          setState(() {
            orderStatus = "Completed";
            orderStatusColor = Colors.green;
            buttonVisible = true;
          });
        }else if(code == 12){
          setState(() {
            orderStatus = "Canceled";
            orderStatusColor = Colors.red;
            buttonVisible =true;
          });
        }
      }
    });

  }

  @override
  void initState() {
    super.initState();
    startOrderWebSocket();
  }

  @override
  Widget build(BuildContext context) {

    userData = userData.isNotEmpty
        ? userData
        : ModalRoute.of(context).settings.arguments;

    Settings _settings = userData['Settings'];

    Color primaryColor = services.colorConvert(_settings.primaryColor);
    // Color secondaryColor = services.colorConvert(_settings.secondaryColor);
    Color textColor = services.colorConvert(_settings.textColor);
    // Color accentColor = services.colorConvert(_settings.accentColor);
    // Color labelColor = services.colorConvert(_settings.labelColor);


    return Scaffold(
      body: SafeArea(
        child: Container(
          color: primaryColor,
          child: Center(
                  child : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 900,
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.all(
                                Radius.circular(30.0))
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Order has been placed",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: textColor,
                                ),
                              ),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Status : ",
                                   style: TextStyle(
                                     fontSize: 30,
                                     color: textColor,
                                   ),
                                 ),
                                 Text(orderStatus,
                                   style: TextStyle(
                                     fontSize: 30,
                                     color: orderStatusColor,
                                   ),
                                 ),
                               ],
                             ),
                              SizedBox(height: 20,),
                              Visibility(
                                visible: buttonVisible,
                                  child: RoundedRectangleButton(
                                      text: 'Back to menu',
                                      accentColor: orderStatusColor,
                                       onPressed: (){
                                        Navigator.pushReplacementNamed(context, Loading.id);
                                    },
                                  )
                              ),
                            ],
                          ),
                      ),



                    ],

                  )
          ),
        ),
      ),
    );
  }
}
