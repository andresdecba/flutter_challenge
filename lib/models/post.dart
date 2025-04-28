import 'package:flutter/material.dart';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  bool isFavorite;
  ValueNotifier<bool> favNotifier;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    required this.isFavorite,
  }) : favNotifier = ValueNotifier(isFavorite);

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isFavorite:
          json['isFavorite'] != null ? json['isFavorite'] as bool : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'isFavorite': isFavorite,
    };
  }
}
