class OrderFields {
  static final List<String> values = [
    /// Add all fields
    orderID,itemID,itemName, itemImage, itemOptionID,
    itemOptionName,itemExtrasIDs, quantity , price,additionalInfo
  ];

  static final String orderID = 'orderID';
  static final String itemID = 'itemID';
  static final String itemName = 'ItemName';
  static final String itemImage = 'itemImage';
  static final String itemOptionID = 'itemOptionID';
  static final String itemOptionName = 'itemOptionName';
  static final String itemExtrasIDs = 'itemExtrasListIDs';
  static final String quantity = 'quantity';
  static final String price = 'price';
  static final String additionalInfo = 'additionalInfo';
}

class Order {
  final int orderID;
  final String itemID;
  final String itemName;
  final String itemImage;
  final String itemOptionID;
  final String itemOptionName;
  final String itemExtrasIDs;
  final String quantity;
  final String price;
  final String additionalInfo;

  Order(
      {
        this.orderID,
        this.itemID,
        this.itemName,
        this.itemImage,
        this.itemOptionID,
        this.itemOptionName,
        this.itemExtrasIDs,
        this.quantity,
        this.price,
        this.additionalInfo

      });

  static Order fromJson(Map<String, Object> json) => Order(
      orderID: json[OrderFields.orderID] as int,
      itemID: json[OrderFields.itemID] as String,
      itemName: json[OrderFields.itemName] as String,
      itemImage: json[OrderFields.itemImage] as String,
      itemOptionID: json[OrderFields.itemOptionID] as String,
      itemOptionName: json[OrderFields.itemOptionName] as String,
      itemExtrasIDs: json[OrderFields.itemExtrasIDs] as String,
      quantity: json[OrderFields.quantity] as String,
      price: json[OrderFields.price] as String,
      additionalInfo: json[OrderFields.additionalInfo] as String

  );

  Map<String, Object> toJson() => {
    OrderFields.orderID: orderID,
    OrderFields.itemID: itemID,
    OrderFields.itemName: itemName,
    OrderFields.itemImage: itemImage,
    OrderFields.itemOptionID: itemOptionID,
    OrderFields.itemOptionName: itemOptionName,
    OrderFields.itemExtrasIDs: itemExtrasIDs,
    OrderFields.quantity: quantity,
    OrderFields.price: price,
    OrderFields.additionalInfo: additionalInfo
  };

}




