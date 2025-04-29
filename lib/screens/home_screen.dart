import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challenge/repository/respository.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Repository _repository;
  late final Future<List<Post>> _getPosts;

  @override
  void initState() {
    super.initState();
    _repository = Repository(
      dio: DioConfig.dio,
      platform: const MethodChannel('com.example.flutter_challenge/comments'),
    );
    _getPosts = _repository.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter challenge'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: FutureBuilder(
        future: _getPosts,
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

          // empty state
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const EmptyView(
              title: 'No posts found',
              message: 'Intente nuevamente más tarde.',
            );
          }

          // data
          if (snapshot.hasData) {
            return _BuildPosts(snapshot.data!);
          }

          // default
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BuildPosts extends StatefulWidget {
  const _BuildPosts(
    this.posts,
  );

  final List<Post> posts;

  @override
  State<_BuildPosts> createState() => __BuildPostsState();
}

class __BuildPostsState extends State<_BuildPosts> {
  late final TextEditingController _searchCtlr;
  List<Post> _posts = [];

  void onFilter(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      // if the value is empty, return the original list
      if (query.isEmpty) {
        _posts = widget.posts;
        return;
      }
      // filter the list by title
      _posts = widget.posts
          .where((e) => e.title.toLowerCase().contains(query))
          .toList();
    });
  }

  void onClear() {
    _searchCtlr.clear();
    onFilter('');
  }

  void onTapOutside(PointerDownEvent event) {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _searchCtlr = TextEditingController();
    _posts = widget.posts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
          child: SearchBar(
            controller: _searchCtlr,
            onChanged: onFilter,
            onTapOutside: onTapOutside,
            hintText: 'Buscar por título',
            elevation: WidgetStateProperty.all(0.0),
            padding: WidgetStateProperty.all(
              const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
            ),
            trailing: [
              if (_searchCtlr.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                ),
              if (_searchCtlr.text.isEmpty) const Icon(Icons.search),
            ],
          ),
        ),

        // no results were found
        if (_posts.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'No se encontraron resultados',
              style: TextStyle(fontSize: 16.0),
            ),
          ),

        // posts
        Flexible(
          child: ListView.separated(
            itemCount: _posts.length,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            separatorBuilder: (context, index) => const Divider(
              height: 1.0,
            ),
            itemBuilder: (context, index) {
              return PostListTile(
                key: ValueKey(_posts[index].id),
                title: _posts[index].title,
                subtitle: _posts[index].body,
                isFavorite: _posts[index].isFavorite,
                favNotifier: _posts[index].favNotifier,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostScreen(_posts[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
