import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.title = 'No hay datos',
    this.message,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.data_array,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            if (message != null)
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
