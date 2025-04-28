import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../core/core.dart';
import '../models/models.dart';

class Repository {
  final dio = DioConfig.dio;
  static const platform =
      MethodChannel('com.example.flutter_challenge/comments');

  Future<List<Post>> getPosts() async {
    try {
      final response = await dio.get(
        '/posts',
      );
      return (response.data as List)
          .map((post) => Post.fromJson(post))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<List<Comment>> getComments(int postId) async {
    try {
      final response = await platform.invokeMethod(
        'getComments',
        {'postId': postId},
      );

      final List<dynamic> jsonList = jsonDecode(response);
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      throw ApiException();
    }
  }
}
