import 'dart:convert';

OrdersPostRequestObject ordersPostRequestObjectFromJson(String str) => OrdersPostRequestObject.fromJson(json.decode(str));

String ordersPostRequestObjectToJson(OrdersPostRequestObject data) => json.encode(data.toJson());

class OrdersPostRequestObject {
  OrdersPostRequestObject({
    this.userId,
    this.posSerial,
    this.terminalSerial,
    this.table,
    this.date,
    this.additionalInfo,
    this.orderItem,
  });

  final String userId;
  final String posSerial;
  final String terminalSerial;
  final int table;
  final String date;
  final String additionalInfo;
  final List<OrderItem> orderItem;

  factory OrdersPostRequestObject.fromJson(Map<String, dynamic> json) => OrdersPostRequestObject(
    userId: json["userId"],
    posSerial: json["posSerial"],
    terminalSerial: json["terminalSerial"],
    table: json["table"],
    date: json["date"],
    additionalInfo: json["additionalInfo"],
    orderItem: List<OrderItem>.from(json["orderItem"].map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "posSerial": posSerial,
    "terminalSerial": terminalSerial,
    "table": table,
    "date": date,
    "additionalInfo": additionalInfo,
    "orderItem": List<dynamic>.from(orderItem.map((x) => x.toJson())),
  };
}


OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));
String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  OrderItem({
    this.orderId,
    this.itemId,
    this.itemOptionId,
    this.quantity,
    this.orderExtra,
  });

  final String orderId;
  final String itemId;
  final String itemOptionId;
  final int quantity;
  final List<OrderExtra> orderExtra;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    orderId: json["orderId"],
    itemId: json["itemId"],
    itemOptionId: json["itemOptionId"],
    quantity: json["quantity"],
    orderExtra: List<OrderExtra>.from(json["orderExtra"].map((x) => OrderExtra.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "itemId": itemId,
    "itemOptionId": itemOptionId,
    "quantity": quantity,
    "orderExtra": List<dynamic>.from(orderExtra.map((x) => x.toJson())),
  };
}

class OrderExtra {
  OrderExtra({
    this.orderItemId,
    this.itemExtraId,
  });

  final String orderItemId;
  final String itemExtraId;

  factory OrderExtra.fromJson(Map<String, dynamic> json) => OrderExtra(
    orderItemId: json["orderItemId"],
    itemExtraId: json["itemExtraId"],
  );

  Map<String, dynamic> toJson() => {
    "orderItemId": orderItemId,
    "itemExtraId": itemExtraId,
  };
}

OrderComment orderCommentFromJson(String str) => OrderComment.fromJson(json.decode(str));
String orderCommentToJson(OrderComment data) => json.encode(data.toJson());

class OrderComment {
  OrderComment({
    this.orderId,
    this.comment,
    this.date,
  });

  String orderId;
  String comment;
  String date;

  factory OrderComment.fromJson(Map<String, dynamic> json) => OrderComment(
    orderId: json["orderId"],
    comment: json["comment"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "comment": comment,
    "date": date,
  };
}
