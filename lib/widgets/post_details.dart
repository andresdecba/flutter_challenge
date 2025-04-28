import 'package:flutter/material.dart';

import '../models/models.dart';
import '../core/core.dart';

class PostDetails extends StatelessWidget {
  const PostDetails(
    this.post, {
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        border: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            post.title.capitalizeFirstLetter(),
            textAlign: TextAlign.left,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            post.body.capitalizeFirstLetter(),
            textAlign: TextAlign.left,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
