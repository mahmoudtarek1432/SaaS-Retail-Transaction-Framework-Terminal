import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terminal/constant.dart';

class ItemBlock extends StatelessWidget {
  const ItemBlock({
    Key key,
    @required this.primaryColor,
    @required this.secondaryColor,
    @required this.labelColor,
    @required this.textColor,
    @required this.itemID,
    @required this.itemName,
    @required this.itemPrice,
    @required this.itemImage,
    @required this.onPressed,

  }) : super(key: key);

  final Color primaryColor;
  final Color secondaryColor;
  final Color labelColor;
  final Color textColor;
  final String itemID;
  final String itemName;
  final String itemPrice;
  final String itemImage;
  final Function onPressed;


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:Alignment.topCenter,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 190.0,
          width: 160.0,
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0))),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Padding( //Image
                      padding: const EdgeInsets.only(top: 20,bottom: 5),
                      child: Container(
                          height: 80.0,
                          width: 80.0,
                          color: Colors.transparent,
                          child: itemImage == "" ? CircleAvatar(
                            backgroundColor: secondaryColor,
                          ) :CircleAvatar(
                            backgroundImage: NetworkImage("$baseurl/images/$itemImage"),
                            backgroundColor: textColor,
                            radius: 30.0,
                          )
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          '$itemName',
                          style: TextStyle(
                              fontSize: 20,
                              color:labelColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                   Container(
                     alignment: Alignment.bottomCenter,
                     child: Text(
                      "$itemPrice \$",
                      style: TextStyle(
                          fontSize: 15, color: textColor
                      ),
                      textAlign: TextAlign.center,
                  ),
                   ),
                ],
              )),
        ),
      ),
    );
  }
}