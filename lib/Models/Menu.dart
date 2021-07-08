import 'package:terminal/Models/Category.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';


class MenuFields {
  static final List<String> values = [
    /// Add all fields
    menuID,version
  ];

  static final String menuID = 'menuID';
  static final String version = 'version';
}

class Menu {

  String menuID ;
  List<Category> categories;
  List<Item> items;
  List<ItemExtra> itemExtras;
  List<ItemOption> itemOption;
  int version ;

  Menu({
    this.menuID,
    this.categories,
    this.items,
    this.itemExtras,
    this.itemOption,
    this.version
  });

  static Menu fromJson(Map<String, Object> json) => Menu(
    menuID: json[MenuFields.menuID] as String,
    version: json[MenuFields.version] as int,
  );

  Map<String, Object> toJson() => {
    MenuFields.menuID:menuID ,
    MenuFields.version: version
  };

}