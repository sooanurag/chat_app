import 'dart:convert';
import 'dart:io';

import 'package:chat_app/data/network/base_api_service.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getApiCall({
    required String url,
    Map<String, String>? header,
  }) async {
    dynamic apiResponse;
    try {
      final respsonse = await http
          .get(
            Uri.parse(url),
            headers: header,
          )
          .timeout(const Duration(seconds: 10));
      apiResponse = respsonse;
    } on SocketException {
      throw FetchDataException("No internet");
    }

    return returnResponse(apiResponse);
  }

  @override
  Future postApiCall({
    required String url,
    dynamic data,
    Map<String, String>? header,
  }) async {
    dynamic apiResponse;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: header,
          )
          .timeout(const Duration(seconds: 10));
      apiResponse = response;
    } on SocketException {
      throw FetchDataException("No Internet");
    }

    return returnResponse(apiResponse);
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 404:
        throw UnauthorizedException(response.body);
      default:
        throw FetchDataException(response.body);
    }
  }
}
