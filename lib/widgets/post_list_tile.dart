import 'package:flutter/material.dart';

import '../core/core.dart';

class PostListTile extends StatelessWidget {
  const PostListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isFavorite,
    required this.favNotifier,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isFavorite;
  final ValueNotifier<bool> favNotifier;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.grey,
        );

    return ListTile(
      title: Text(
        title.capitalizeFirstLetter(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle.capitalizeFirstLetter(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: subtitleStyle,
      ),
      trailing: ValueListenableBuilder<bool>(
        valueListenable: favNotifier,
        builder: (context, isFav, child) {
          return Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.grey,
          );
        },
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
    );
  }
}
