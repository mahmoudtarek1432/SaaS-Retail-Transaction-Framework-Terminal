import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/Order.dart';
import 'package:terminal/Components/ImageBlock.dart';
import 'package:terminal/Controllers/SqliteController.dart';

class CartItems extends StatefulWidget {
  const CartItems({
    Key key,
    @required this.order,
    @required this.textColor,
    @required this.labelColor,
    @required this.accentColor,
    @required this.secondaryColor,
    @required this.onPressed,
  }) : super(key: key);

  final Order order;
  final Color textColor;
  final Color secondaryColor;
  final Color labelColor;
  final Color accentColor;
  final Function onPressed;

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {

  SqliteController queries = new SqliteController();
  List<String> itemExtraIDs;
  List<ItemExtra> itemExtrasList = [];
  String itemExtrasString = "";

  Text orderName() {
    if (widget.order.itemExtrasIDs == "" && widget.order.itemOptionID != "") {
      return Text("${widget.order.itemName} ${widget.order.itemOptionName}",
          style: TextStyle(color: widget.textColor));
    }
    else if(widget.order.itemExtrasIDs != "" && widget.order.itemOptionName == ""  ){
      return Text("${widget.order.itemName} with $itemExtrasString",
          style: TextStyle(color: widget.textColor));
    }else if (widget.order.itemOptionName != "" && widget.order.itemExtrasIDs != ""){
      return Text("${widget.order.itemName} ${widget.order.itemOptionName} with $itemExtrasString",
          style: TextStyle(color: widget.textColor));
    }
    return Text("${widget.order.itemName}",
        style: TextStyle(color: widget.textColor));

  }

  Future setupExtras() async{
    if(widget.order.itemExtrasIDs != ""){
      itemExtraIDs = widget.order.itemExtrasIDs.split(",");
      for (var id in itemExtraIDs){
        ItemExtra temp = await queries.selectItemExtra(id);
        itemExtrasList.add(temp);
        itemExtrasString = itemExtrasString  + temp.itemExtraName + " , ";
      }
      setState(() {
        itemExtrasString =itemExtrasString.substring(0,itemExtrasString.length-2);
      });
    }

  }

  @override
  void initState() {
    super.initState();
    setupExtras();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  //Item Image
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageBlock(
                        height: 60,
                        width: 70,
                        image: widget.order.itemImage,
                        secondaryColor: widget.secondaryColor),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderName(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.order.quantity + "x",
                              style: TextStyle(
                                fontSize: 15,
                                color: widget.labelColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.order.price} \$",
                              style: TextStyle(
                                fontSize: 15,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  // Delete Button
                  icon: Icon(Icons.delete),
                  iconSize: 30,
                  color: widget.accentColor,
                  onPressed: widget.onPressed,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
