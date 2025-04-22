import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final T data;
  final String rawBody;
  final int statusCode;
  final String? lastModified;

  ApiResponse({
    required this.data,
    required this.rawBody,
    required this.statusCode,
    this.lastModified,
  });
}

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<ApiResponse<Map<String, dynamic>>> getJson(
    String url, {
    String? ifModifiedSince,
  }) async {
    final uri = Uri.parse(url);
    final headers = <String, String>{};
    if (ifModifiedSince != null) {
      headers['If-Modified-Since'] = ifModifiedSince;
    }
    final response = await _client.get(uri, headers: headers);
    final lastModified = response.headers['last-modified'];
    if (response.statusCode == 304) {
      return ApiResponse(
        data: <String, dynamic>{},
        rawBody: '',
        statusCode: response.statusCode,
        lastModified: lastModified,
      );
    }
    final bodyBytes = response.bodyBytes;
    final bodyString = const Utf8Decoder().convert(bodyBytes);
    final jsonMap = jsonDecode(bodyString) as Map<String, dynamic>;
    return ApiResponse(
      data: jsonMap,
      rawBody: bodyString,
      statusCode: response.statusCode,
      lastModified: lastModified,
    );
  }

  void dispose() {
    _client.close();
  }
}
