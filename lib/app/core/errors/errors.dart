abstract class Failure implements Exception {
  String get message;
}

class ParamtersEmptyError extends Failure {
  final String message;
  ParamtersEmptyError({required this.message});
}

class ServerException implements Failure {
  final String message;
  ServerException({required this.message});
}
