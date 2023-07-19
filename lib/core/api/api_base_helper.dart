import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'app_exception.dart';

class ApiBaseHelper {
  Future<dynamic> get({
    required String url,
    Map<String, String>? header,
  }) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: header).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeOutException('ConnectionTimeOut');
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('internet bağlantısı yok');
    }

    return responseJson;
  }

  Future<dynamic> delete({
    required String url,
    required Map<String, String>? header,
    required Object? body,
  }) async {
    dynamic responseJson;
    try {
      final response = await http
          .delete(
        Uri.parse(url),
        body: body,
        headers: header,
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeOutException('ConnectionTimeOut');
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('internet bağlantısı yok');
    }

    return responseJson;
  }

  Future<dynamic> post({
    required String url,
    Object? body,
    Map<String, String>? header,
  }) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: body,
            headers: header,
          )
          .timeout(
            const Duration(seconds: 15),
          );
      responseJson = _returnResponse(response);
    } on TimeoutException catch (_) {
      throw FetchDataException("Zaman aşımı!");
    } on SocketException catch (e) {
      debugPrint(e.toString());
      throw FetchDataException("Soket hatası bağlantını ve bilgilerini kontrol et!");
    }

    return responseJson;
  }

  dynamic successControl({required response}) {
    if (response["success"] == false) {
      throw (response["message"]);
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = _convertToJson(response.bodyBytes);
        return responseJson;
      case 400:
        var responseJson = _convertToJson(response.bodyBytes);
        throw BadRequestException(responseJson["message"]);
      case 401:
        var responseJson = _convertToJson(response.bodyBytes);
        throw UnauthorisedException(responseJson["message"]);
      case 403:
        var responseJson = _convertToJson(response.bodyBytes);
        throw UnauthorisedException(responseJson["message"]);
      case 408:
        var responseJson = _convertToJson(response.bodyBytes);
        throw TimeOutException(responseJson["message"]);
      case 500:
      default:
        throw FetchDataException(
            'Sunucuyla İletişim Kurulurken Hata Oluştu. Web site adını kontrol et.\nDurum Kodu: ${response.statusCode}');
    }
  }

  dynamic _convertToJson(Uint8List bodyBytes) {
    var responseBody = utf8.decode(bodyBytes);
    return json.decode(responseBody);
  }
}
