import '../api/api_response.dart';

extension OfStatus on ApiResponse {
  toInitial() {
    status = Status.initial;
  }

  toLoading() {
    status = Status.loading;
  }

  bool isError() {
    return status == Status.error;
  }

  bool isCompleted() {
    return status == Status.completed;
  }

  bool isLoading() {
    return status == Status.loading;
  }
  bool isInitial() {
    return status == Status.initial;
  }
}
