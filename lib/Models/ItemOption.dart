class ItemOptionFields {
  static final List<String> values = [
    /// Add all fields
    itemOptionID, itemID, itemOptionName, itemOptionPrice,itemOptionCode,display
  ];

  static final String itemOptionID = 'itemOptionID';
  static final String itemID = 'itemID';
  static final String itemOptionName = 'itemOptionName';
  static final String itemOptionPrice = 'itemOptionPrice';
  static final String itemOptionCode = 'itemOptionCode';
  static final String display = 'display';

}

class ItemOption {
  String itemOptionID;
  String itemID;
  String itemOptionName;
  String itemOptionPrice;
  String itemOptionCode;
  String display;

  ItemOption({
    this.itemOptionID,
    this.itemID,
    this.itemOptionName,
    this.itemOptionPrice,
    this.itemOptionCode,
    this.display

  });

  static ItemOption fromJson(Map<String, Object> json) => ItemOption(
    itemOptionID: json[ItemOptionFields.itemOptionID] as String,
      itemID: json[ItemOptionFields.itemID] as String,
    itemOptionName: json[ItemOptionFields.itemOptionName] as String,
    itemOptionPrice: json[ItemOptionFields.itemOptionPrice] as String,
    itemOptionCode: json[ItemOptionFields.itemOptionCode] as String,
    display: json[ItemOptionFields.display] as String,
  );

  Map<String, Object> toJson() => {
    ItemOptionFields.itemOptionID: itemOptionID,
    ItemOptionFields.itemID: itemID,
    ItemOptionFields.itemOptionName: itemOptionName,
    ItemOptionFields.itemOptionPrice: itemOptionPrice,
    ItemOptionFields.itemOptionCode: itemOptionCode,
    ItemOptionFields.display: display,

  };
}
