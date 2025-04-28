import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';

class CommentListTile extends StatelessWidget {
  const CommentListTile(
    this.comment, {
    super.key,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // user info
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          comment.name.capitalizeFirstLetter(),
                          style: textTheme.labelMedium,
                        ),
                        Text(
                          comment.email,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // comment
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              comment.body.capitalizeFirstLetter(),
              style: textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
