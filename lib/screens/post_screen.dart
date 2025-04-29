import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../repository/respository.dart';
import '../widgets/widgets.dart';

class PostScreen extends StatelessWidget {
  const PostScreen(this.post, {super.key});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              post.isFavorite = !post.isFavorite;
              post.favNotifier.value = post.isFavorite;
            },
            icon: ValueListenableBuilder<bool>(
              valueListenable: post.favNotifier,
              builder: (context, isFav, child) {
                return Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PostDetails(post),
          Flexible(
            child: _BuildComments(post.id),
          ),
        ],
      ),
    );
  }
}

class _BuildComments extends StatefulWidget {
  const _BuildComments(this.postId);
  final int postId;

  @override
  State<_BuildComments> createState() => _BuildCommentsState();
}

class _BuildCommentsState extends State<_BuildComments> {
  late final Repository _repository;
  late final Future<List<Comment>> _getComments;

  @override
  void initState() {
    super.initState();
    _repository = Repository(
      dio: DioConfig.dio,
      platform: const MethodChannel('com.example.flutter_challenge/comments'),
    );
    _getComments = _repository.getComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder(
      future: _getComments,
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        }

        // error
        if (snapshot.hasError) {
          return ErrorView(
            error: snapshot.error.toString(),
            onRetry: () => setState(() {}),
          );
        }

        // data
        final comments = snapshot.data!;

        // empty state
        if (snapshot.hasData && comments.isEmpty) {
          return const EmptyView(
            title: 'No hay comentarios aún...',
            message: '¡ Se el primero en comentar !',
          );
        }

        // data
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.grey[200],
                child: Text(
                  '${comments.length} Comentarios',
                  style: textTheme.titleSmall,
                ),
              ),
              Flexible(
                child: ListView.separated(
                  itemCount: comments.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(top: 8.0)
                          : EdgeInsets.zero,
                      child: CommentListTile(
                        comment,
                        key: ValueKey(comment.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // default
        return const SizedBox.shrink();
      },
    );
  }
}
