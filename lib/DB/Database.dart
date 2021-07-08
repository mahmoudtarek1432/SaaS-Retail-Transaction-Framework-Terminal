import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/Category.dart';
import 'package:terminal/Models/Menu.dart';
import 'package:terminal/Models/Settings.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';
import 'package:terminal/Models/Order.dart';
import 'package:terminal/Models/User.dart';

class DatabaseHelper {

  static final dbName = 'Test1.18';
  static final settingsTableName = 'settingsTable';
  static final menuTableName = 'menuTable';
  static final categoryTableName = 'categoriesTable';
  static final itemTableName = 'tableItems';
  static final itemExtraTableName = 'tableItemExtra';
  static final itemOptionTableName = 'tableItemOption';
  static final orderTableName = 'tableOrder';
  static final userTableName = 'tableUser';



  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB(dbName);
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {

    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final textTypeNull = 'TEXT';
    // final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final integerTypeNull = 'INTEGER';


    await db.execute('''
CREATE TABLE $userTableName (
  ${UserFields.token} $textType,
  ${UserFields.tableNumber} $integerTypeNull
  )
''');

    await db.execute('''
CREATE TABLE $settingsTableName (
  ${SettingsFields.primaryColor} $textType,
  ${SettingsFields.secondaryColor} $textType,
  ${SettingsFields.accentColor} $textType,
  ${SettingsFields.labelColor} $textType,
  ${SettingsFields.textColor} $textType,
  ${SettingsFields.brandName} $textType,
  ${SettingsFields.icon} $textType,
  ${SettingsFields.terminalMode} $integerType,
  ${SettingsFields.version} $integerType
  )
''');

    await db.execute('''
CREATE TABLE $menuTableName ( 
  ${MenuFields.menuID} $textType,
  ${MenuFields.version} $integerType
  )
''');

    await db.execute('''
CREATE TABLE $categoryTableName ( 
  ${CategoryFields.categoryID} $textType,
  ${CategoryFields.categoryName} $textType,
  ${CategoryFields.categoryImage} $textTypeNull,
  ${CategoryFields.display} $textType
  )
''');



    await db.execute('''
CREATE TABLE $itemTableName ( 
  ${ItemsFields.itemID} $textTypeNull,
  ${ItemsFields.categoryID} $textTypeNull,
  ${ItemsFields.itemName} $textTypeNull,
  ${ItemsFields.itemDescription} $textTypeNull,
  ${ItemsFields.itemPrice} $textTypeNull,
  ${ItemsFields.itemImage} $textTypeNull,
  ${ItemsFields.hasOption} $textTypeNull,
  ${ItemsFields.itemCode} $textTypeNull,
  ${ItemsFields.display} $textTypeNull
  )
''');

    await db.execute('''
    CREATE TABLE $itemExtraTableName (
        ${ItemExtraFields.itemExtraID} $textTypeNull,
        ${ItemExtraFields.itemID} $textTypeNull,
        ${ItemExtraFields.itemExtraName} $textTypeNull,
        ${ItemExtraFields.itemExtraPrice} $textTypeNull,
        ${ItemExtraFields.itemExtraImage} $textTypeNull,
        ${ItemExtraFields.itemExtraCode} $textTypeNull,
        ${ItemExtraFields.display} $textTypeNull
    )
    ''');

    await db.execute('''
    CREATE TABLE $itemOptionTableName (
        ${ItemOptionFields.itemOptionID} $textTypeNull,
        ${ItemOptionFields.itemID} $textTypeNull,
        ${ItemOptionFields.itemOptionName} $textTypeNull,
        ${ItemOptionFields.itemOptionPrice} $textTypeNull,
        ${ItemOptionFields.itemOptionCode} $textTypeNull,
        ${ItemExtraFields.display} $textTypeNull
    )
    ''');

    await db.execute('''
CREATE TABLE $orderTableName ( 
  ${OrderFields.orderID} $idType,
  ${OrderFields.itemID} $textTypeNull,
  ${OrderFields.itemName} $textTypeNull,
  ${OrderFields.itemImage} $textTypeNull,
  ${OrderFields.itemOptionID} $textTypeNull,
  ${OrderFields.itemOptionName} $textTypeNull,
  ${OrderFields.itemExtrasIDs} $textTypeNull,
  ${OrderFields.additionalInfo} $textTypeNull,
  ${OrderFields.quantity} $textTypeNull,
  ${OrderFields.price} $textTypeNull
  )
''');

  }

  Future insertUser(User user) async {
    final db = await instance.database;
    await db.insert(userTableName, user.toJson());
  }

  Future updateTableNumber(int tableNumber,String token) async {
    final db = await instance.database;
    await db.rawQuery("UPDATE $userTableName SET ${UserFields.tableNumber} = $tableNumber "
    );
  }

  Future<List<User>> getUser() async {
    final db = await instance.database;
    final result = await db.query(userTableName);
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future clearUser() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $userTableName');
  }

  Future insertSettings(Settings settings) async {
    final db = await instance.database;
    await db.insert(settingsTableName, settings.toJson());
  }

  Future<List<Settings>> getSettings() async {
    final db = await instance.database;
    final result = await db.query(settingsTableName);
    return result.map((json) => Settings.fromJson(json)).toList();
  }

  Future clearSettings() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $settingsTableName');
  }

  Future insertMenu(Menu menu) async {
    final db = await instance.database;
    await db.insert(menuTableName, menu.toJson());
  }

  Future<List<Menu>> getMenu() async {
    final db = await instance.database;
    final result = await db.query(menuTableName);
    return result.map((json) => Menu.fromJson(json)).toList();
  }

  Future clearMenu() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $menuTableName');
  }

  Future insertCategory(Category category) async {
    final db = await instance.database;
    await db.insert(categoryTableName, category.toJson());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.query(categoryTableName,
    where: '${CategoryFields.display} = ?' , whereArgs:['true']
    );
    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future clearCategories() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $categoryTableName');
  }

  Future insertItem(Item item) async {
    final db = await instance.database;
    await db.insert(itemTableName, item.toJson());
  }

  Future<List<Item>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query(itemTableName);
    return result.map((json) => Item.fromJson(json)).toList();
  }

  Future<List<Item>> selectItems(String categoryID) async {
    final db = await instance.database;
    final result = await db.query(itemTableName,
        where: '${ItemsFields.categoryID} = ? AND ${ItemsFields.display} = ?' , whereArgs: [categoryID,'true']);
    return result.map((json) => Item.fromJson(json)).toList();
  }

  Future<List<Item>> selectItem(String itemID) async {
    final db = await instance.database;
    final result = await db.query(itemTableName,
        where: '${ItemsFields.itemID} = ? ' , whereArgs: [itemID]);
    return result.map((json) => Item.fromJson(json)).toList();
  }

  Future clearItems() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $itemTableName');
  }

  Future insertItemExtras(ItemExtra itemExtra) async {
    final db = await instance.database;
    await db.insert(itemExtraTableName, itemExtra.toJson());
  }

  Future<List<ItemExtra>> getAllItemExtras() async {
    final db = await instance.database;
    final result = await db.query(itemExtraTableName);
    return result.map((json) => ItemExtra.fromJson(json)).toList();
  }

  Future<List<ItemExtra>> selectItemExtras(String itemID) async {
    final db = await instance.database;
    final result = await db.query(itemExtraTableName,
        where: '${ItemExtraFields.itemID} = ? AND ${ItemsFields.display} = ?' , whereArgs: [itemID,'true']);
    return result.map((json) => ItemExtra.fromJson(json)).toList();
  }

  Future<List<ItemExtra>> selectItemExtra(String itemExtraID) async {
    final db = await instance.database;
    final result = await db.query(itemExtraTableName,
        where: '${ItemExtraFields.itemExtraID} = ? ' , whereArgs: [itemExtraID]);
    return result.map((json) => ItemExtra.fromJson(json)).toList();
  }

  Future clearItemExtras() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $itemExtraTableName');
  }

  Future insertItemOption(ItemOption itemOption) async {
    final db = await instance.database;
    await db.insert(itemOptionTableName, itemOption.toJson());
  }

  Future<List<ItemOption>> getAllItemOptions() async {
    final db = await instance.database;
    final result = await db.query(itemOptionTableName);
    return result.map((json) => ItemOption.fromJson(json)).toList();
  }

  Future<List<ItemOption>> selectItemOptions(String itemID) async {
    final db = await instance.database;
    final result = await db.query(itemOptionTableName,
        where: '${ItemOptionFields.itemID} = ? AND ${ItemOptionFields.display} = ?' , whereArgs: [itemID,'true']);
    return result.map((json) => ItemOption.fromJson(json)).toList();
  }

  Future<List<ItemOption>> selectItemOption(String optionID) async {
    final db = await instance.database;
    final result = await db.query(itemOptionTableName,
        where: '${ItemOptionFields.itemID} = ? AND ${ItemOptionFields.display} = ?' , whereArgs: [optionID,'true']);
    return result.map((json) => ItemOption.fromJson(json)).toList();
  }

  Future clearItemOptions() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $itemOptionTableName');
  }

  Future insertOrder(Order order) async {
    final db = await instance.database;
    await db.insert(orderTableName, order.toJson());
  }


  Future<List<Order>> getAllOrders() async {
    final db = await instance.database;
    final result = await db.query(orderTableName);
    return result.map((json) => Order.fromJson(json)).toList();
  }

  Future clearOrders() async {
    final db = await instance.database;
    return await db.rawQuery('DELETE FROM $orderTableName');
  }

  Future clearSelectedOrder(int orderID) async {
    final db = await instance.database;
    return await db.delete(
        orderTableName,
         where: '${OrderFields.orderID} = ?' ,
        whereArgs: [orderID],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}
