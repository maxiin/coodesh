abstract class Failure {
  String message;
  int? code;

  Failure({required this.message, this.code});
}

class ApiFailure extends Failure {
  ApiFailure({required message, required code}): super(message: message, code: code);
}

class FileFailure extends Failure {
  FileFailure({required message}): super(message: message);
}