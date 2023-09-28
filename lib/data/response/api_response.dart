import 'status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse([
    this.status,
    this.message,
    this.data,
  ]);

  ApiResponse.loading() : status = Status.loading;
  ApiResponse.done() : status = Status.completed;
  ApiResponse.error() : status = Status.error;

  @override
  String toString() => "Status: $status\t Message: $message\t Data: $data";
}
