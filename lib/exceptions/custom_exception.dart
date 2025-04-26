// Custom exception class for handling exceptions with status and message params
class CustomException implements Exception {
  final int? status;
  final String message;

  CustomException(this.message, {this.status = 500});

  @override
  String toString() {
    return 'ApiException{status: $status, message: $message}';
  }
}
