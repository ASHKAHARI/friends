import 'dart:convert';

import 'package:flutter/material.dart';

Friends friendsFromJson(String str) => Friends.fromJson(json.decode(str));

String friendsToJson(Friends data) => json.encode(data.toJson());

class Friends {
  Friends(
      {this.id,
      this.name,
      this.mobileNo,
      this.dob,
      this.category,
      this.profilePicture,
      this.iconColor = Colors.cyan});

  int? id;
  String? name;
  Color? iconColor;
  String? mobileNo;
  String? dob;
  String? category;
  String? profilePicture;

  factory Friends.fromJson(Map<String, dynamic> json) => Friends(
        id: json["id"],
        name: json["name"],
        dob: json["dob"],
        mobileNo: json["mobileNo"],
        category: json["category"],
        profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dob": dob,
        "mobileNo": mobileNo,
        "category": category,
        "profilePicture":profilePicture,
      };
}
