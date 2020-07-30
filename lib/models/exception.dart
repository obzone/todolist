class UnauthorityException implements Exception {}

class CommonException implements Exception {
  final String message;
  const CommonException(this.message);

  @override
  String toString() {
    return message;
  }
}
