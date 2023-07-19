
import 'package:case_study/core/model/get_most_popular.dart';
import 'package:http/http.dart' as http;

import '../../locator.dart';
import '../constants/constants.dart';
import '../constants/endpoints.dart';
import 'api_base_helper.dart';

class Api {
  static final ApiBaseHelper _apiBaseHelper = locator<ApiBaseHelper>();
  var client = http.Client();

  Future<GetMostPopularModel> getMostPopular() async {
    var url = Constants.domain + Endpoints.mostPopular + Constants.token;
    var response = await _apiBaseHelper.get(
      url: url,
    );
    return GetMostPopularModel.fromJson(response);
  }
}
