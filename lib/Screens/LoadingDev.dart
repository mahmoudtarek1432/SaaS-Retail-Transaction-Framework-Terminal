import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/Screens/MainMenu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:terminal/Controllers/HTTPServices.dart';
import 'package:terminal/Models/Menu.dart';
import 'package:terminal/Models/Settings.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/Category.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';

class LoadingDev extends StatefulWidget {
  static const String id = 'loadingDev';
  @override
  _LoadingDevState createState() => _LoadingDevState();
}

class _LoadingDevState extends State<LoadingDev> {
  SqliteController queries = new SqliteController();
  HTTPServices httpServices = new HTTPServices();

  Future setupMenuDev() async {
    final settings = await queries.getSettings();
    final categories = await queries.getAllCategories();

    new Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, MainMenu.id, arguments: {
        'Settings': settings,
        'Category': categories,
      });
    });
  }

  Future determinationAction() async {
    int code = 4;
    try {
      //all is fine
      if (code == 1) {
        await setupMenuDev();
      }
      //If menu is outdated
      else if (code == 2) {
        queries.clearMenu();
        final menu = await httpServices.getMenu();
        await queries.insertMenu(menu);
        await setupMenuDev();
      }
      //If settings is outdated
      else if (code == 3) {
        queries.clearSettings();
        final settings = await getUserSettings();
        await queries.insertSettings(settings);
        await setupMenuDev();
      }
      //If both settings and menu outdated
      else if (code == 4) {
        queries.clearSettings();
        queries.clearMenu();
        final settings = await getUserSettings();
        final menu = await getMenu();
        await queries.insertSettings(settings);
        await queries.insertMenu(menu);
        await setupMenuDev();
      } else if (code == 5) {
        print("Something went wrong code 5");
      } else {
        print("Error");
      }
    } catch (e) {
      print('error caught: $e');
    }
  }

  // ignore: missing_return
  Future<Settings> getUserSettings() async {
    Settings settings;

    String url = "http://10.0.3.2:3000/TerminalSettings";
    var response = await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = json.decode(response.body);
      var data = responseMap['responseObject']['settings'];

      settings = Settings(
        primaryColor: data['primarycolor'],
        secondaryColor: data['secondarycolor'],
        accentColor: data['accentcolor'],
        labelColor: data['labelcolor'],
        textColor: data['textcolor'],
        brandName: data['brandname'],
        icon: data['icon'],
        version: 0,
        terminalMode: 0,
      );

      return settings;
    }
  }

  Future<Menu> getMenu() async {
    List<Category> _category = [];
    List<Item> _item = [];
    List<ItemExtra> _itemExtras = [];
    List<ItemOption> _itemOption = [];

    Menu menu;
    Category category;
    Item item;
    ItemExtra itemExtra;
    ItemOption itemOption;

    String url = "http://10.0.3.2:3000/Menu";
    var response = await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = json.decode(response.body);

      List categorylist = responseMap['responseObject']['menu']['categories'];

      List itemlist;
      List itemExtraslist;
      List itemOptionlist;

      int i = 0;
      int y = 0;
      int z = 0;
      int x = 0;

      while (i < categorylist.length) {
        y = 0;
        itemlist = categorylist[i]['items'];
        while (y < itemlist.length) {
          itemExtraslist = itemlist[y]['itemExtras'];
          z = 0;
          while (z < itemExtraslist.length) {
            itemExtra = ItemExtra(
                itemExtraID: itemExtraslist[z]['id'],
                itemID: itemExtraslist[z]['itemId'],
                itemExtraName: itemExtraslist[z]['name'],
                itemExtraPrice: itemExtraslist[z]['price'].toString(),
                itemExtraImage: itemExtraslist[z]['image'],
                itemExtraCode: itemExtraslist[z]['code'],
                display: itemExtraslist[z]['display'].toString());
            _itemExtras.add(itemExtra);
            z++;
          }

          itemOptionlist = itemlist[y]['itemOptions'];
          x = 0;
          while (x < itemOptionlist.length) {
            itemOption = ItemOption(
                itemOptionID: itemOptionlist[x]['id'],
                itemID: itemOptionlist[x]['itemId'],
                itemOptionName: itemOptionlist[x]['name'],
                itemOptionPrice: itemOptionlist[x]['price'].toString(),
                itemOptionCode: itemOptionlist[x]['code'],
                display: itemOptionlist[x]['display'].toString());
            _itemOption.add(itemOption);
            x++;
          }

          item = Item(
              itemID: itemlist[y]['id'],
              categoryID: itemlist[y]['categoryId'],
              itemName: itemlist[y]['name'],
              itemDescription: itemlist[y]['description'],
              itemPrice: itemlist[y]['price'].toString(),
              itemImage: itemlist[y]['image'],
              hasOption: itemlist[y]['hasOptions'].toString(),
              itemCode: itemlist[y]['code'].toString(),
              display: itemlist[y]['display'].toString());

          _item.add(item);
          y++;
        }

        category = Category(
            categoryID: categorylist[i]['id'],
            categoryName: categorylist[i]['name'],
            categoryImage: categorylist[i]['image'],
            display: categorylist[i]['display'].toString());
        _category.add(category);
        i++;
      }

      menu = Menu(
          menuID: responseMap['responseObject']['menu']['id'],
          categories: _category,
          items: _item,
          itemExtras: _itemExtras,
          itemOption: _itemOption,
          version: responseMap['responseObject']['version']);
    }
    return menu;
  }

  @override
  void initState() {
    super.initState();
    determinationAction();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitHourGlass(
          color: Colors.red,
          size: 200.0,
        ),
      ),
    );
  }
}
