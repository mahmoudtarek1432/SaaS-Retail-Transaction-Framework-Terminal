import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';
import 'package:terminal/Models/Order.dart';
import 'package:terminal/Models/OrdersPostRequest.dart';
import 'package:terminal/Models/Settings.dart';
import 'package:terminal/Components/CartItems.dart';
import 'package:terminal/Components/CategoriesBlock.dart';
import 'package:terminal/Components/ImageBlock.dart';
import 'package:terminal/Components/ItemBlock.dart';
import 'package:terminal/Components/RoundedRectangleButton.dart';
import 'package:terminal/Components/SectionName.dart';
import 'package:terminal/Screens/ItemPage.dart';
import 'package:terminal/Screens/Loading.dart';
import 'package:terminal/Screens/Login.dart';
import 'package:terminal/Screens/OrderPlaced.dart';
import 'package:terminal/Controllers//HTTPServices.dart';
import 'package:terminal/Models/Category.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Controllers/ProcessingControllers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class MainMenu extends StatefulWidget {
  const MainMenu({Key key}) : super(key: key);
  static const String id = 'mainMenu';

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  DateTime date;
  HTTPServices httpServices = new HTTPServices();
  ProcessingControllers services = new ProcessingControllers();
  SqliteController sqliteController = new SqliteController();
  List<Item> _items = [];
  List<Order> _orders = [];
  int totalRounded = 0;
  Map userData = {};
  bool checkoutVisibility = false;
  int clicks = 0;

  @override
  void initState() {
    super.initState();
    updateCart();
    updateTotal();
    startMenuWebSocket();
  }

  @override
  Widget build(BuildContext context) {

    userData = userData.isNotEmpty
        ? userData
        : ModalRoute.of(context).settings.arguments;

    Settings _settings = userData['Settings'];
    List<Category> _category = userData['Category'];
    Color primaryColor = services.colorConvert(_settings.primaryColor);
    Color secondaryColor = services.colorConvert(_settings.secondaryColor);
    Color textColor = services.colorConvert(_settings.textColor);
    Color accentColor = services.colorConvert(_settings.accentColor);
    Color labelColor = services.colorConvert(_settings.labelColor);
    String brandName = _settings.brandName;
    String icon = _settings.icon;

    return Scaffold(
        body: SafeArea(
      child: Row(
        children: [
          // Left Area
          Expanded(
            flex: 1,
            child: Container(
              color: primaryColor,
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Column(
                          children: [
                            ImageBlock(
                                height: 70,
                                width: 70,
                                secondaryColor: secondaryColor,
                                image: icon),
                            SizedBox(
                              height: 30,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                brandName,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        clicks++;
                        if (clicks == 4) {
                          await services.logOut();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      child: Container(
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Middle Area
          Expanded(
            flex: 8,
            child: Container(
              color: secondaryColor,
              child: Column(
                children: [
                  //1st Section
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: SectionName(
                                labelColor: labelColor,
                                sectionLabel: 'Category'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //2nd Section
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Expanded(
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _category.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CategoryBlock(
                                      primaryColor: primaryColor,
                                      secondaryColor: secondaryColor,
                                      textColor: textColor,
                                      categoryID: _category[i].categoryID,
                                      categoryName: _category[i].categoryName,
                                      categoryImage: _category[i].categoryImage,
                                      onPressed: () async {
                                        List<Item> newItems =
                                            await sqliteController.selectItems(
                                                _category[i].categoryID);
                                        setState(() {
                                          _items = newItems;
                                        });
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //3rd Section
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: SectionName(
                                  labelColor: labelColor,
                                  sectionLabel: 'Category Item')),
                        ],
                      ),
                    ),
                  ),
                  //4th Section
                  Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: GridView.count(
                          mainAxisSpacing: 20,
                          crossAxisCount: 4,
                          scrollDirection: Axis.vertical,
                          children: List.generate(_items.length, (i) {
                            return Center(
                              child: ItemBlock(
                                primaryColor: primaryColor,
                                secondaryColor: secondaryColor,
                                labelColor: labelColor,
                                textColor: textColor,
                                itemID: _items[i].itemID,
                                itemName: _items[i].itemName,
                                itemPrice: _items[i].itemPrice,
                                itemImage: _items[i].itemImage,
                                onPressed: () async {
                                  List<ItemExtra> itemExtras = await sqliteController
                                      .selectItemExtras(_items[i].itemID);
                                  List<ItemOption> itemOptions = await sqliteController
                                      .selectItemOptions(_items[i].itemID);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemPage(
                                            item: _items[i],
                                            itemExtras: itemExtras,
                                            itemOptions: itemOptions,
                                            primaryColor: primaryColor,
                                            secondaryColor: secondaryColor,
                                            accentColor: accentColor,
                                            labelColor: labelColor,
                                            textColor: textColor)),
                                  ).then(onGoBack);
                                },
                              ),
                            );
                          }),
                        ),
                      ))
                ],
              ),
            ),
          ),
          // Right Area
          Expanded(
            flex: 4,
            child: Container(
                color: primaryColor,
                child: Container(
                  child: Column(
                    children: [
                      Row(children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(40, 30, 0, 35),
                            child: SectionName(
                              sectionLabel: 'Cart',
                              labelColor: labelColor,
                            )),
                        Visibility(
                          visible: checkoutVisibility,
                          child: Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                iconSize: 50,
                                color: Colors.white,
                                onPressed: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: primaryColor,
                                          content: Text("Start a new basket ?",
                                              style: TextStyle(
                                                color: textColor,
                                              )),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                sqliteController.clearsOrder();
                                                setState(() {
                                                  _orders = [];
                                                  totalRounded = 0;
                                                  checkoutVisibility = false;
                                                });
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                              child: Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: Text('No'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Expanded(
                        flex: 10,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _orders.length,
                            itemBuilder: (context, i) {
                              return CartItems(
                                order: Order(
                                  orderID: _orders[i].orderID,
                                  itemID: _orders[i].itemID,
                                  itemName: _orders[i].itemName,
                                  itemImage: _orders[i].itemImage,
                                  itemOptionID: _orders[i].itemOptionID,
                                  itemOptionName: _orders[i].itemOptionName,
                                  itemExtrasIDs: _orders[i].itemExtrasIDs,
                                  additionalInfo: _orders[i].additionalInfo,
                                  price: _orders[i].price,
                                  quantity: _orders[i].quantity,
                                ),
                                secondaryColor: secondaryColor,
                                textColor: textColor,
                                labelColor: labelColor,
                                accentColor: accentColor,
                                onPressed: () async {
                                  await sqliteController.deleteOrder(_orders[i].orderID);
                                  setState(() {
                                    _orders.remove(_orders[i]);
                                    updateTotal();
                                    if (_orders.isEmpty == true) {
                                      checkoutVisibility = false;
                                    }
                                  });
                                },
                              );
                            }),
                      ),
                      Divider(
                        height: 0,
                        thickness: 2,
                        color: accentColor,
                      ),
                      Expanded(
                        flex: 2,
                        child: Visibility(
                          visible: checkoutVisibility,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Sub Total : $totalRounded \$",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: checkoutVisibility,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: RoundedRectangleButton(
                              text: "Checkout",
                              accentColor: accentColor,
                              onPressed: () async {
                                date = DateTime.now();
                                bool orderPosted = await httpServices
                                    .postOrder(OrdersPostRequestObject(
                                  userId: "",
                                  posSerial: "",
                                  terminalSerial: "",
                                  table: await sqliteController.getTableNumber(),
                                  date: date.toIso8601String(),
                                  additionalInfo: await services.extractAdditionalInfo(),
                                  orderItem: await services.extractOrderItems(_orders),
                                ));
                                if (orderPosted == true) {
                                  sqliteController.clearsOrder();
                                    _orders = [];
                                    totalRounded = 0;
                                    checkoutVisibility = false;
                                  Navigator.pushReplacementNamed(
                                      context, OrderPlaced.id,
                                      arguments: {
                                        'Settings': _settings,
                                      });
                                } else {
                                  print("Order not placed");
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    )
    );
  }

  Future startMenuWebSocket() async {
    final channel =
        WebSocketChannel.connect(Uri.parse("ws://192.168.43.118:84"));
    channel.stream.listen((data) {
      String message = data;
      String connectionID = "";
      if (message.substring(0, 7) == "ConnID:") {
        connectionID = message.substring(7);
        httpServices.webSocketConfirm(connectionID);
      } else {
        Map response = json.decode(message);
        int code = response['type'];
        if (code == 5) {
          Navigator.pushNamed(context, Loading.id);
        } else if (code == 6) {
          Navigator.pushNamed(context, Loading.id);
        }
      }
    });
  }

  Future updateCart() async {
    _orders = await sqliteController.getOrders();
    if (_orders.length >= 1) {
      checkoutVisibility = true;
    }
  }

  Future updateTotal() async {
    double total = 0.0;
    for (var x in _orders) {
      total = total + double.parse(x.price);
    }
    totalRounded = total.ceil();
  }

  Future onGoBack(dynamic value) async {
    await updateCart();
    await updateTotal();
    setState(() {});
  }

}
