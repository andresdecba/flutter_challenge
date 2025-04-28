import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.onRetry,
    required this.error,
  });

  final VoidCallback? onRetry;
  final String error;

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
              Icons.error,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'Algo salió mal',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Intente nuevamente mas tarde.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            // Text(
            //   error,
            //   textAlign: TextAlign.center,
            //   style: textTheme.bodySmall,
            // ),
            const SizedBox(height: 20),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
          ],
        ),
      ),
    );
  }
}
