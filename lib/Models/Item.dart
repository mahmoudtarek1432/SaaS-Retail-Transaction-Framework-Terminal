class ItemsFields {
  static final List<String> values = [
    /// Add all fields
    itemID, categoryID, itemName, itemDescription, itemPrice, itemImage,
    hasOption, itemCode, display
  ];

  static final String itemID = 'itemID';
  static final String categoryID = 'categoryID';
  static final String itemName = 'ItemName';
  static final String itemDescription = 'itemDescription';
  static final String itemPrice = 'itemPrice';
  static final String itemImage = 'itemImage';
  static final String hasOption = 'hasOption';
  static final String itemCode = 'itemCode';
  static final String display = 'display';
}

class Item {
  String itemID;
  String categoryID;
  String itemName;
  String itemDescription;
  String itemPrice;
  String itemImage;
  String hasOption;
  String itemCode;
  String display;

  Item(
      {this.itemID,
      this.categoryID,
      this.itemName,
      this.itemDescription,
      this.itemPrice,
      this.itemImage,
      this.hasOption,
      this.itemCode,
      this.display});

  static Item fromJson(Map<String, Object> json) => Item(
      itemID: json[ItemsFields.itemID] as String,
      categoryID: json[ItemsFields.categoryID] as String,
      itemName: json[ItemsFields.itemName] as String,
      itemDescription: json[ItemsFields.itemDescription] as String,
      itemPrice: json[ItemsFields.itemPrice] as String,
      itemImage: json[ItemsFields.itemImage] as String,
      hasOption: json[ItemsFields.hasOption] as String,
      itemCode: json[ItemsFields.itemCode] as String,
      display: json[ItemsFields.display] as String);

  Map<String, Object> toJson() => {
        ItemsFields.itemID: itemID,
        ItemsFields.categoryID: categoryID,
        ItemsFields.itemName: itemName,
        ItemsFields.itemDescription: itemDescription,
        ItemsFields.itemPrice: itemPrice,
        ItemsFields.itemImage: itemImage,
        ItemsFields.hasOption: hasOption,
        ItemsFields.itemCode: itemCode,
        ItemsFields.display: display
      };
}
