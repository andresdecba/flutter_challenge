import 'package:flutter/services.dart';
import 'package:flutter_challenge/core/core.dart';
import 'package:flutter_challenge/models/models.dart';

import 'package:flutter_challenge/repository/respository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late Repository repository;
  late MethodChannel methodChannel;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
    dioAdapter = DioAdapter(dio: dio);
    methodChannel =
        const MethodChannel('com.example.flutter_challenge/comments');
    repository = Repository(
      dio: dio,
      platform: methodChannel,

      /// const MethodChannel('com.example.flutter_challenge/comments'),
    );
  });

  group('Repository', () {
    group('getPosts', () {
      test(
        'debe devolver una lista de Post cuando la respuesta es exitosa',
        () async {
          // Datos simulados
          final mockResponseData = [
            {
              'userId': 0,
              'id': 1,
              'title': 'Post_1',
              'body': 'Body_1',
              'isFavorite': false
            },
            {
              'userId': 0,
              'id': 2,
              'title': 'Post_2',
              'body': 'Body_2',
              'isFavorite': false
            },
          ];

          // Configura el mock de DioAdapter
          dioAdapter.onGet(
            '/posts',
            (server) => server.reply(200, mockResponseData),
          );

          // Llama al método y verifica el resultado
          final posts = await repository.getPosts();
          expect(posts, isA<List<Post>>());
          expect(posts.length, 2);
          expect(posts[0].title, 'Post_1');
        },
      );

      test(
        'debe lanzar ApiException cuando ocurre un error',
        () async {
          // Configura el mock de DioAdapter para devolver un error
          dioAdapter.onGet(
            '/posts',
            (server) => server.reply(500, {'error': 'Internal Server Error'}),
          );

          // Verifica que se lance ApiException
          expect(() async => await repository.getPosts(),
              throwsA(isA<ApiException>()));
        },
      );
    });

    group('getComments', () {
      test(
        'debe devolver una lista de Comment cuando la respuesta es exitosa',
        () async {
          // Datos simulados
          final mockResponseData = [
            {
              'postId': 1,
              'id': 1,
              'name': 'Comment 1',
              'email': 'test1@example.com',
              'body': 'Body 1'
            },
            {
              'postId': 1,
              'id': 2,
              'name': 'Comment 2',
              'email': 'test2@example.com',
              'body': 'Body 2'
            },
          ];

          // Configura el mock de MethodChannel
          when(methodChannel.invokeMethod('getComments', {'postId': 1}))
              .thenAnswer((_) async => mockResponseData);

          // Llama al método y verifica el resultado
          final comments = await repository.getComments(1);
          expect(comments, isA<List<Comment>>());
          expect(comments.length, 2);
          expect(comments[0].name, 'Comment 1');
        },
      );

      test(
        'debe lanzar ApiException cuando ocurre un error',
        () async {
          // Configura el mock de MethodChannel para lanzar una excepción
          when(methodChannel.invokeMethod('getComments', {'postId': 1}))
              .thenThrow(PlatformException(code: 'ERROR'));

          // Verifica que se lance ApiException
          expect(() async => await repository.getComments(1),
              throwsA(isA<ApiException>()));
        },
      );
    });
  });
}
