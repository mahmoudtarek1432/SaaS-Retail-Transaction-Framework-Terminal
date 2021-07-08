import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/Order.dart';
import 'package:terminal/Components/RoundedIconButton.dart';
import 'package:terminal/constant.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';
import 'package:terminal/components/RadioTextButton.dart';
import 'package:terminal/components/SectionName.dart';
import 'package:terminal/Components/RoundedRectangleButton.dart';

class ItemPage extends StatefulWidget {
  static const String id = 'Item';

  const ItemPage(
      {@required this.item,
      @required this.itemExtras,
      @required this.itemOptions,
      @required this.primaryColor,
      @required this.secondaryColor,
      @required this.textColor,
      @required this.accentColor,
      @required this.labelColor});

  final Item item;
  final List<ItemExtra> itemExtras;
  final List<ItemOption> itemOptions;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color accentColor;
  final Color labelColor;

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int x = 0;
  List<ItemExtra> selectedItemExtra = [];
  List<String> selectedItemExtrasIDsList = [];
  String selectedItemExtrasIDsString = "";
  List<String> selected = [];
  bool isChecked = false;
  SqliteController sqliteController = new SqliteController();
  int selectedRadio;
  int quantity = 1;

  var additionalInfoController = TextEditingController();
  bool optionsSectionVisible = false;
  bool extrasSectionVisible = false;
  String itemOptionID = "";
  String itemOptionName = "";

  void itemPageStartup() {
    if (widget.itemExtras.isNotEmpty) {
      extrasSectionVisible = true;
    }
    if (widget.itemOptions.isNotEmpty) {
      optionsSectionVisible = true;
    }
  }

  void _onSelected(selected, itemExtra) {
    if (selected == true) {
      setState(() {
        selectedItemExtra.add(itemExtra);
      });
    } else {
      setState(() {
        selectedItemExtra.remove(itemExtra);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    itemPageStartup();
    selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: widget.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.item.itemName,
          style: kItemNameStyle.copyWith(fontSize: 25.0),
        ),
        iconTheme: IconThemeData(
          color: widget.accentColor,
        ),
        backgroundColor: widget.secondaryColor,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250.0,
                    width: 250.0,
                    decoration: widget.item.itemImage == ""
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.secondaryColor)
                        : BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "$baseurl/images/${widget.item.itemImage}")),
                            borderRadius: BorderRadius.circular(10),
                            color: widget.secondaryColor),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.item.itemName,
                              style: kItemNameStyle,
                            ),
                            Text(
                              widget.item.itemPrice + " \$",
                              style: kItemNameStyle.copyWith(fontSize: 30.0),
                            ),
                          ],
                        ),
                        width: 900.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          widget.item.itemDescription,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 20.0,
                            wordSpacing: 2.0,
                            height: 1.5,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              //Option Section
              Visibility(
                visible: optionsSectionVisible,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    SectionName(
                        sectionLabel: 'Option', labelColor: widget.labelColor),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: Container(
                        width: 1000,
                        height: widget.itemOptions.length.toDouble() * 70,
                        padding: EdgeInsets.only(left: 30, right: 30) ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: widget.secondaryColor,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.itemOptions.length,
                                  itemBuilder: (context, int x) {
                                    return Column(
                                      children: [
                                        RadioTextButton(
                                          value: x,
                                          id: widget
                                              .itemOptions[x].itemOptionID,
                                          label: widget.itemOptions[x]
                                                  .itemOptionName +
                                              " " +
                                              widget.itemOptions[x]
                                                  .itemOptionPrice +
                                              " \$",
                                          textColor: widget.textColor,
                                          accentColor: widget.accentColor,
                                          selectedRadio: selectedRadio,
                                          onPressed: (val) {
                                            this.x = x;
                                            setState(() {
                                              selectedRadio = val;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Extra Section
              Visibility(
                  visible: extrasSectionVisible,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      SectionName(
                          sectionLabel: 'Extras',
                          labelColor: widget.labelColor),
                      SizedBox(
                        height: 30.0,
                      ),
                      Center(
                        child: Container(
                          width: 1000,
                          height: widget.itemExtras.length.toDouble() * 70,
                          padding: EdgeInsets.only(left: 30, right: 30) ,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.secondaryColor,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.itemExtras.length,
                                    itemBuilder: (context, int index) {
                                      return Container(
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                            "${ widget.itemExtras[index].itemExtraName} ${widget.itemExtras[index].itemExtraPrice} \$",
                                              style: kItemNameStyle.copyWith(
                                                  fontSize: 25.0,
                                                  color: widget.textColor),
                                            ),
                                            Transform.scale(
                                              scale: 1.5,
                                              child: Checkbox(
                                                value: selectedItemExtra.contains(
                                                    widget.itemExtras[index]),
                                                checkColor: widget.accentColor,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    _onSelected(selected,
                                                        widget.itemExtras[index]);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 40.0,
              ),
              SectionName(
                  sectionLabel: 'Additional info',
                  labelColor: widget.labelColor),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(30.0),
                      child: TextField(
                        controller: additionalInfoController,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: widget.textColor,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          fillColor: widget.secondaryColor,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding:
                              EdgeInsets.only(left: 20.0, top: 50.0),
                        ),
                      ),
                      width: 1000,
                    ),
                  )
                ],
              ),
              Row(
                //Quantity Buttons
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundIconButton(
                    accentColor: widget.accentColor,
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        color: widget.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RoundIconButton(
                    accentColor: widget.accentColor,
                    icon: Icons.remove,
                    onPressed: () {
                      setState(() {
                        quantity--;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70.0,
                width: MediaQuery.of(context).size.width - 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedRectangleButton(
                        text: 'Add to cart ',
                        accentColor: widget.accentColor,
                        onPressed: () async {

                          if (widget.itemOptions.length > 0) {
                            itemOptionID = widget.itemOptions[x].itemOptionID;
                            itemOptionName = widget.itemOptions[x].itemOptionName;
                          }
                          for(var x in selectedItemExtra){
                            selectedItemExtrasIDsList.add(x.itemExtraID.toString()) ;
                          }
                          selectedItemExtrasIDsString = selectedItemExtrasIDsList.join(",");

                          await sqliteController.insertOrder(Order(
                            itemID: widget.item.itemID,
                            itemName: widget.item.itemName,
                            itemImage: widget.item.itemImage,
                            itemOptionID: itemOptionID,
                            itemOptionName: itemOptionName,
                            itemExtrasIDs: selectedItemExtrasIDsString,
                            additionalInfo: additionalInfoController.text,
                            quantity: quantity.toString(),
                            price: calculatePrice().toString(),
                          ));
                          Navigator.pop(context, 'Item added.');
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  double calculatePrice() {
    double price = 0.0;
    double itemExtraTotal = 0.0;

    if (selectedItemExtra.isNotEmpty) {
      for (var x in selectedItemExtra) {
        itemExtraTotal = itemExtraTotal + double.parse(x.itemExtraPrice);
      }
    }
    if (widget.itemOptions.isEmpty && widget.itemExtras.isEmpty) {
      price = double.parse(widget.item.itemPrice) * quantity;
    } else if (widget.itemOptions.isNotEmpty && widget.itemExtras.isEmpty) {
      price = double.parse(widget.item.itemPrice) +
          double.parse(widget.itemOptions[x].itemOptionPrice) * quantity;
    } else if (widget.itemOptions.isEmpty && widget.itemExtras.isNotEmpty) {
      price = double.parse(widget.item.itemPrice) + itemExtraTotal * quantity;
    } else {
      price = double.parse(widget.item.itemPrice) +
          double.parse(widget.itemOptions[x].itemOptionPrice) +
          itemExtraTotal * quantity;
    }
    return price;
  }
}
