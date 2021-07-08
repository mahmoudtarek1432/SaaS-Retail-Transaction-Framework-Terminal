import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

class Response {

  bool isSuccessfull;
  String message;
  String errors;
  var responseObject;

  Response(
      {
      this.isSuccessfull,
        this.message,
        this.errors,
        this.responseObject
      });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
      isSuccessfull: json["isSuccessfull"],
      message: json["message"],
      errors: json["errors"],
      responseObject: json["responseObject"]
  );


}
