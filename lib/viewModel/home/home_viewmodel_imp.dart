import 'package:case_study/core/model/get_most_popular.dart';
import 'package:flutter/material.dart';

import '../../core/api/api.dart';
import '../../core/api/api_response.dart';
import '../../locator.dart';
import 'home_viewmodel.dart';

class HomeViewModelImp with ChangeNotifier implements HomeViewModel {
  ApiResponse<GetMostPopularModel> _getMostPopularResponse = ApiResponse.loading('loading');

  @override
  ApiResponse<GetMostPopularModel> get getMostPopularResponse => _getMostPopularResponse;

  @override
  set getMostPopularResponse(ApiResponse<GetMostPopularModel> value) {
    _getMostPopularResponse = value;
    notifyListeners();
  }

  @override
  void refreshHome() {
    getMostPopularResponse = ApiResponse.loading('loading');
    notifyListeners();
    getMostPopular();
  }

  @override
  Future<void> getMostPopular() async {
    try {
      final result = await locator<Api>().getMostPopular();
      quickSort(result.results, 0, (result.results.length-1));
      getMostPopularResponse = ApiResponse.completed(result);
    } catch (e) {
      getMostPopularResponse = ApiResponse.error(e.toString());
    }
  }



  void quickSort(List<Result> list, int low, int high) {
    if (low < high) {
      int pivotIndex = partition(list, low, high);
      quickSort(list, low, pivotIndex - 1);
      quickSort(list, pivotIndex + 1, high);
    }
  }

  int partition(List<Result> list, int low, int high) {
    String pivot = list[high].publishedDate.toString();
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].publishedDate.toString().compareTo(pivot) <= 0) {
        i++;
        swap(list, i, j);
      }
    }

    swap(list, i + 1, high);
    return i + 1;
  }

  void swap(List<Result> list, int i, int j) {
    Result temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
}
