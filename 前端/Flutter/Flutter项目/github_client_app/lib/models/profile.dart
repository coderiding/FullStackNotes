// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.user,
    this.token,
    this.theme,
    this.cache,
    this.lastLogin,
    this.locale,
  });

  String user;
  String token;
  int theme;
  String cache;
  String lastLogin;
  String locale;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    user: json["user"],
    token: json["token"],
    theme: json["theme"],
    cache: json["cache"],
    lastLogin: json["lastLogin"],
    locale: json["locale"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "token": token,
    "theme": theme,
    "cache": cache,
    "lastLogin": lastLogin,
    "locale": locale,
  };
}
