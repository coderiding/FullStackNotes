import 'package:flutter/material.dart';

class UserLoginRequestEntity {
  UserLoginRequestEntity({
    @required this.email,
    @required this.password,
  });

  String email;
  String password;

  factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) => UserLoginRequestEntity(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}

class UserLoginResponseEntity {
  UserLoginResponseEntity({
    @required this.accessToken,
    this.displayName,
    this.channels,
  });

  String accessToken;
  String displayName;
  List<String> channels;

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) => UserLoginResponseEntity(
    accessToken: json["accessToken"],
    displayName: json["displayName"],
    channels: List<String>.from(json["channels"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "displayName": displayName,
    "channels": List<dynamic>.from(channels.map((x) => x)),
  };
}
