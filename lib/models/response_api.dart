import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String? message;
  bool? success;
  dynamic data;

  ResponseApi({
    this.message,
    this.success,
  });

  ResponseApi.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    success = json["success"];

    try {
      data = json["user"];
    } catch (e) {
      print("Exception data $e");
    }
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "user": data,
      };
}
