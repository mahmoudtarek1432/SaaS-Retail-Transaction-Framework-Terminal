import 'package:flutter/material.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Models/Order.dart';
import 'package:terminal/Models/OrdersPostRequest.dart';

class ProcessingControllers{
SqliteController queries = new SqliteController();

  Color x = Colors.red;
  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    } else {
      return x;
    }
  }

  Future updateCart(List<Order> _orders ,bool checkoutVisibility) async {
    _orders = await queries.getOrders();
    if (_orders.length >= 1) {
      checkoutVisibility = true;
    }
  }

  Future updateTotal(List<Order> _orders ,int totalRounded) async {
    double total = 0.0;
    for (var x in _orders) {
      total = total + double.parse(x.price);
    }
    totalRounded = total.ceil();
  }

  Future logOut() async {
    queries.clearsOrder();
    queries.deleteUser();
    queries.clearMenu();
    queries.clearSettings();
    queries.clearsOrder();
  }

  List<String> extractExtrasIDs(String itemExtrasIDs) {
    List<String> itemExtraIDsList;
    if (itemExtrasIDs != "") {
      itemExtraIDsList = itemExtrasIDs.split(",");
    }
    return itemExtraIDsList;
  }

  Future<String> extractAdditionalInfo() async {
    String wholeAdditionalInfo = "";
    List<Order> orders = await queries.getOrders();
    for (var x in orders) {
      wholeAdditionalInfo = wholeAdditionalInfo + x.additionalInfo + ",";
    }

    if (wholeAdditionalInfo.length > 2) {
      return wholeAdditionalInfo.substring(0, wholeAdditionalInfo.length - 2);
    }
    return wholeAdditionalInfo;
  }

  Future<List<OrderItem>> extractOrderItems(List<Order> orders) async {
    List<OrderItem> orderItemList = [];
    List<OrderExtra> orderExtraList = [];
    List<String> itemExtraIDsList = [];
    OrderItem itemTemp;
    OrderExtra extraTemp;

    for (var x in orders) {
      if (x.itemExtrasIDs != "") {
        itemExtraIDsList = extractExtrasIDs(x.itemExtrasIDs);
        for (var y in itemExtraIDsList) {
          extraTemp = OrderExtra(orderItemId: x.itemID, itemExtraId: y);
          orderExtraList.add(extraTemp);
        }
      }

      itemTemp = OrderItem(
        orderId: "",
        itemId: x.itemID,
        itemOptionId: x.itemOptionID,
        quantity: int.parse(x.quantity),
        orderExtra: orderExtraList,
      );
      orderItemList.add(itemTemp);
    }
    return orderItemList;
  }

}