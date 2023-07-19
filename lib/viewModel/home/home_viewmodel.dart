import 'package:case_study/core/model/get_most_popular.dart';
import 'package:flutter/material.dart';

import '../../core/api/api_response.dart';

abstract class HomeViewModel with ChangeNotifier {
  ApiResponse<GetMostPopularModel> get getMostPopularResponse;

  set getMostPopularResponse(ApiResponse<GetMostPopularModel> value);

  void refreshHome();

  Future<void> getMostPopular();

  void quickSort(List<Result> list, int low, int high);
}
