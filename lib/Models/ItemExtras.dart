class ItemExtraFields {
  static final List<String> values = [
    /// Add all fields
    itemExtraID, itemID, itemExtraName, itemExtraPrice, itemExtraImage,
    itemExtraCode ,display
  ];

  static final String itemExtraID = 'itemExtraID';
  static final String itemID = 'itemID';
  static final String itemExtraName = 'itemExtraName';
  static final String itemExtraPrice = 'itemExtraPrice';
  static final String itemExtraImage = 'itemExtraImage';
  static final String itemExtraCode = 'itemExtraCode';
  static final String display = 'display';
}

class ItemExtra {
  String itemExtraID;
  String itemID;
  String itemExtraName;
  String itemExtraPrice;
  String itemExtraImage;
  String itemExtraCode;
  String display;

  ItemExtra({
    this.itemExtraID,
    this.itemID,
    this.itemExtraName,
    this.itemExtraPrice,
    this.itemExtraImage,
    this.itemExtraCode,
    this.display,
  });

  static ItemExtra fromJson(Map<String, Object> json) => ItemExtra(
      itemExtraID: json[ItemExtraFields.itemExtraID] as String,
      itemID: json[ItemExtraFields.itemID] as String,
      itemExtraName: json[ItemExtraFields.itemExtraName] as String,
      itemExtraPrice: json[ItemExtraFields.itemExtraPrice] as String,
      itemExtraImage: json[ItemExtraFields.itemExtraImage] as String,
      itemExtraCode: json[ItemExtraFields.itemExtraCode] as String,
      display: json[ItemExtraFields.display] as String);

  Map<String, Object> toJson() => {
        ItemExtraFields.itemExtraID: itemExtraID,
        ItemExtraFields.itemID: itemID,
        ItemExtraFields.itemExtraName: itemExtraName,
        ItemExtraFields.itemExtraPrice: itemExtraPrice,
        ItemExtraFields.itemExtraImage: itemExtraImage,
        ItemExtraFields.itemExtraCode: itemExtraCode,
        ItemExtraFields.display: display
      };
}
