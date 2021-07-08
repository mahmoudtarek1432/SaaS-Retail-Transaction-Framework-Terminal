class UserFields {
  static final List<String> values = [
    token ,tableNumber
  ];
  static final String token = 'token';
  static final String tableNumber = 'tableNumber';

}

class User {
  String token ;
  int tableNumber;

  User({
    this.token,
    this.tableNumber
  });

  static User fromJson(Map<String, Object> json) => User(
    token: json[UserFields.token] as String,
    tableNumber: json[UserFields.tableNumber] as int,

  );

  Map<String, Object> toJson() => {
    UserFields.token:token ,
    UserFields.tableNumber:tableNumber ,
  };

}