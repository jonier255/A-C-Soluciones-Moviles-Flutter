import 'dart:convert';

RegisterResponseModel registerResponseJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  String? message;

  RegisterResponseModel({
    this.message,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        message: json["message"],
      );
}
