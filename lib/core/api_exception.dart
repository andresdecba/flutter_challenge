class ApiException implements Exception {
  final String? message;
  final int? statusCode;

  ApiException({
    this.message = 'Algo salió mal',
    this.statusCode,
  });

  @override
  String toString() {
    return 'ApiException: $message ${statusCode != null ? 'Status code: $statusCode' : ''}';
  }
}
