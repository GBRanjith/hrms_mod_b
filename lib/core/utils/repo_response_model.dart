import '../enums/status.dart';

class RepoResult<T> {
  final Status status;
  final T? data;
  final String? message;

  RepoResult({required this.status, this.data, this.message});

  bool get isSuccess => status == Status.success;
  bool get isError => status == Status.failure;
  bool get isLoading => status == Status.loading;

  RepoResult<R> asFailure<R>() => RepoResult<R>(status: status, message: message);
}
