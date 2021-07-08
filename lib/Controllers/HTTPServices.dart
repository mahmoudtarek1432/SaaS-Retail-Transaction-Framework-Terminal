import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:terminal/Models/User.dart';
import 'package:terminal/Controllers/SqliteController.dart';
import 'package:terminal/constant.dart';
import 'package:terminal/Models/Menu.dart';
import 'package:terminal/Models/Settings.dart';
import 'package:terminal/Models/Item.dart';
import 'package:terminal/Models/Category.dart';
import 'package:terminal/Models/ItemExtras.dart';
import 'package:terminal/Models/ItemOption.dart';
import 'package:terminal/Models/OrdersPostRequest.dart';
import 'package:terminal/Models/Response.dart';

class HTTPServices {
  Response response;
  SqliteController queries = new SqliteController();

  Future<bool> authenticate(String id) async {
    String url = "$baseurl/api/TerminalAuth/Login/$id";

    var httpResponse = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: id + "");

    if (httpResponse.statusCode == 200){
    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      queries.insertUser(User(token: responseMap['responseObject']));
      print(response.message);
      return true;
    } else if (response.isSuccessfull == false) {
      print(response.message);
    }}
    return false;
  }

  Future<bool> validateToken() async {
    User user = await queries.getUser();
    String url = "$baseurl/api/TerminalAuth/CheckAuth";

    var httpResponse = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + user.token
      },
    );
    if (httpResponse.statusCode == 200){
    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      print(response.message);
      return true;
    }}
    return false;
  }

  Future<int> checkForUpdates() async {
    User user = await queries.getUser();

    int settingsVersion = await queries.getSettingsVersion();
    int menuVersion = await queries.getMenuVersion();

    String url = "$baseurl/api/TerminalUpdate/CheckForUpdates";

    var httpResponse = await http.post(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + user.token
    }, body: json.encode({
      "settingsVersion": settingsVersion,
      "menuVersion": menuVersion
    })
    );

    if (httpResponse.statusCode == 200){
    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      print(response.message);
      return response.responseObject;
    } else if (response.isSuccessfull == false) {
      print(response.message);
    }
    }
    return 5;
  }

  Future<Settings> getUserSettings() async {
    User user = await queries.getUser();
    Settings settings;

    String url = "$baseurl/api/TerminalUpdate/TerminalSettings";
    var httpResponse = await http.get(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + user.token
    });

    if (httpResponse.statusCode == 200){
    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      var data = responseMap['responseObject']['settings'];
      settings = Settings(
          primaryColor: data['primaryColor'],
          secondaryColor: data['secondaryColor'],
          accentColor: data['accentColor'],
          labelColor: data['labelColor'],
          textColor: data['mainTextColor'],
          brandName: data['brandName'],
          terminalMode: data['terminalMode'],
          icon: data['icon'],
          version: responseMap['responseObject']['version']);
    }
    }

    return settings;
  }

  Future<Menu> getMenu() async {
    User user = await queries.getUser();

    List<Category> _category = [];
    List<Item> _item = [];
    List<ItemExtra> _itemExtras = [];
    List<ItemOption> _itemOption = [];

    Menu menu;
    Category category;
    Item item;
    ItemExtra itemExtra;
    ItemOption itemOption;

    String url = "$baseurl/api/TerminalUpdate/Menu";
    var httpResponse = await http.get(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + user.token
    });

    if (httpResponse.statusCode == 200){
    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {

      List categoryList = responseMap['responseObject']['menu']['categories'];
      List itemList;
      List itemExtrasList;
      List itemOptionList;

      int i = 0;
      int y = 0;
      int z = 0;
      int x = 0;

      while (i < categoryList.length) {
        y = 0;
        itemList = categoryList[i]['items'];
        while (y < itemList.length) {
          itemExtrasList = itemList[y]['itemExtras'];
          z = 0;
          while (z < itemExtrasList.length) {
            itemExtra = ItemExtra(
                itemExtraID: itemExtrasList[z]['id'],
                itemID: itemExtrasList[z]['itemId'],
                itemExtraName: itemExtrasList[z]['name'],
                itemExtraPrice: itemExtrasList[z]['price'].toString(),
                itemExtraImage: itemExtrasList[z]['image'],
                itemExtraCode: itemExtrasList[z]['code'],
                display: itemExtrasList[z]['display'].toString());
            _itemExtras.add(itemExtra);
            z++;
          }

          itemOptionList = itemList[y]['itemOptions'];
          x = 0;
          while (x < itemOptionList.length) {
            itemOption = ItemOption(
                itemOptionID: itemOptionList[x]['id'],
                itemID: itemOptionList[x]['itemId'],
                itemOptionName: itemOptionList[x]['name'],
                itemOptionPrice: itemOptionList[x]['price'].toString(),
                itemOptionCode: itemOptionList[x]['code'],
                display: itemOptionList[x]['display'].toString());
            _itemOption.add(itemOption);
            x++;
          }

          item = Item(
              itemID: itemList[y]['id'],
              categoryID: itemList[y]['categoryId'],
              itemName: itemList[y]['name'],
              itemDescription: itemList[y]['description'],
              itemPrice: itemList[y]['price'].toString(),
              itemImage: itemList[y]['image'],
              hasOption: itemList[y]['hasOptions'].toString(),
              itemCode: itemList[y]['code'].toString(),
              display: itemList[y]['display'].toString());

          _item.add(item);
          y++;
        }

        category = Category(
            categoryID: categoryList[i]['id'],
            categoryName: categoryList[i]['name'],
            categoryImage: itemList[0]['image'],
            display: categoryList[i]['display'].toString());
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
    }

    return menu;
  }

  Future<Response> webSocketConfirm(String connectionId) async {
    User user = await queries.getUser();
    String url = "$baseurl/api/WebSocket/Terminal/$connectionId";

    var httpResponse = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer " + user.token
        },
        body: connectionId + "");

    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      print(response.message);
      return response;
    } else if (response.isSuccessfull == false) {
      print(response.message);
    }

    return response;
  }

  Future<bool> postOrder(OrdersPostRequestObject order) async {

    User user = await queries.getUser();
    String url = "$baseurl/api/Orders";

    var httpResponse = await http.post(url,
        headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + user.token,
                },
        body: ordersPostRequestObjectToJson(order)
    );

    if (httpResponse.statusCode == 200){
      Map<String, dynamic> responseMap = json.decode(httpResponse.body);
      response = Response.fromJson(responseMap);

      if (response.isSuccessfull == true) {
        print(response.message);
        return true;
      }
      else if (response.isSuccessfull == false) {
        print(response.message);
      }
    }
    return false;

  }

  Future addItemToOrder(OrderItem orderItem) async {
    User user = await queries.getUser();
    String url = "$baseurl/api/AddItemToOrder";

    var httpResponse = await http.post(url,
        headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + user.token
                },
        body: orderItemToJson(orderItem)
    );

    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      queries.insertUser(user = User(token: responseMap['responseObject']));
      print(response.message);
    } else if (response.isSuccessfull == false) {
      print(response.message);
    }
  }

  Future addComment(OrderComment comment) async {
    User user = await queries.getUser();
    String url = "$baseurl/api/OrderComment";

    var httpResponse = await http.post(url,
        headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + user.token
                },
        body: orderCommentToJson(comment)
    );

    Map<String, dynamic> responseMap = json.decode(httpResponse.body);
    response = Response.fromJson(responseMap);

    if (response.isSuccessfull == true) {
      print(response.message);
    } else if (response.isSuccessfull == false) {
      print(response.message);
    }

  }

}
