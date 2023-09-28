abstract class BaseApiService {
  Future<dynamic> getApiCall({
    required String url,
    Map<String, String>? header,
  });
  Future<dynamic> postApiCall({
    required String url,
    dynamic data,
    Map<String, String>? header,
  });
}
