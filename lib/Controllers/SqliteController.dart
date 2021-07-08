import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';
import 'package:terminal/Models/Order.dart';
import 'package:terminal/Models/User.dart';
import 'package:terminal/DB/Database.dart';
import 'package:terminal/Models/Settings.dart';
import 'package:terminal/Models/Category.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/Menu.dart';

final dbHelper = DatabaseHelper.instance;

class SqliteController {

  Future insertUser(User user) async {
    await dbHelper.insertUser(user);
  }

  Future updateTableNumber(int tableNumber ,String token) async{
    await dbHelper.updateTableNumber(tableNumber, token);
  }

  Future<int> getTableNumber() async{
    final entries = await dbHelper.getUser();
    return entries[0].tableNumber;
  }

  Future<bool> checkUserToken() async {
    final entries = await dbHelper.getUser();
    if (entries.length > 0 && entries[0].token != null){
      return true;
    }
    return false;
  }

  Future<User> getUser() async {
    final entries = await dbHelper.getUser();
    return entries[0];
  }

  void deleteUser() async {
    await dbHelper.clearUser();
  }

  Future insertSettings(Settings settings) async {
    await dbHelper.insertSettings(settings);
  }

  Future<Settings> getSettings() async {
    final entries = await dbHelper.getSettings();
    return entries[0];
  }

  Future<int> getSettingsVersion() async{
    final entries = await dbHelper.getSettings();
    if (entries.length > 0){
      return(entries[0].version);
    }
    return 0;
  }

  void clearSettings() async {
    await dbHelper.clearSettings();
  }

  Future insertMenu(Menu menu) async {
    await dbHelper.insertMenu(menu);

    for (var x in menu.categories) {
      await dbHelper.insertCategory(x);
    }
    for (var x in menu.items) {
      await dbHelper.insertItem(x);
    }
    for (var x in menu.itemExtras) {
      await dbHelper.insertItemExtras(x);
    }
    for (var x in menu.itemOption) {
      await dbHelper.insertItemOption(x);
    }
  }

  void clearMenu() async {
    await dbHelper.clearMenu();
    await dbHelper.clearCategories();
    await dbHelper.clearItems();
    await dbHelper.clearItemExtras();
    await dbHelper.clearItemOptions();
  }

  Future<int> getMenuVersion() async{
    final entries = await dbHelper.getMenu();

     if (entries.length > 0){
      return(entries[0].version);
    }
    return 0;
}

  Future<List<Category>> getAllCategories() async {
    final entries = await dbHelper.getAllCategories();
    return entries;
  }

  Future<List<Item>> selectAllItems() async {
    final entries = await dbHelper.getAllItems();
    return entries;
  }

  Future<List<Item>> selectItems(String categoryID) async {
    final entries = await dbHelper.selectItems(categoryID);
    return entries;
  }

  Future<bool> checkIfCatHasItems(String categoryID) async{
    final entries = await dbHelper.selectItems(categoryID);
    if(entries.isNotEmpty==true){
      return true;
    }
    return false;
  }

  Future<Item> selectItem(String itemID) async {
    final entries = await dbHelper.selectItems(itemID);
    return entries[0];
  }

  Future<List<ItemExtra>> selectItemExtras(String itemID) async {
    final entries = await dbHelper.selectItemExtras(itemID);
    return entries;
  }

  Future<ItemExtra> selectItemExtra(String itemExtraID) async {
    final entries = await dbHelper.selectItemExtra(itemExtraID);
    return entries[0];
  }

  Future<List<ItemOption>> selectItemOptions(String itemID) async {
    final entries = await dbHelper.selectItemOptions(itemID);
    return entries;
  }

  Future<ItemOption> selectItemOption(String itemOptionID) async {
    final entries = await dbHelper.selectItemOption(itemOptionID);
    return entries[0];
  }

  Future insertOrder(Order order) async {
    await dbHelper.insertOrder(order);
  }


  Future<List<Order>> getOrders() async {
    final entries = await dbHelper.getAllOrders();
    return entries;
  }

  void clearsOrder() async {
    await dbHelper.clearOrders();
  }

  Future deleteOrder(int orderID) async {
    await dbHelper.clearSelectedOrder(orderID);
  }





}
