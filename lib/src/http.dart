/// HTTP helper functions and constants

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './logger.dart';

// http://telegra.ph/api

/// http response wrapper struct
class HttpResponse {
  int statusCode;
  String body;
  String reason;

  HttpResponse(this.statusCode, this.body, this.reason);

  /// Get body as a json object.
  Map<String, dynamic> toJson() {
    return jsonDecode(body);
  }
}

class HttpClient {
  // Access token for this client.
  String accessToken;

  // API base URL
  static String _apiBaseUrl = "https://api.telegra.ph";

  /// Default constructor.
  HttpClient(this.accessToken);

  /// Send request to API server and return the response.
  Future<HttpResponse> request(
      String method, Map<String, dynamic> params) async {
    String apiUrl = "${_apiBaseUrl}/${method}";

    params ??= Map<String, dynamic>();
    if (accessToken != null) {
      params["access_token"] = accessToken;
    }

    String body, reason;
    int statusCode;

    // www-form urlencoded
    Map<String, String> convertedParams = _convertParams(params);

    Logger.v(
        "sending www-form urlencoded data request to api url: ${apiUrl}, params: ${convertedParams}");

    await http.post(apiUrl, body: convertedParams).then((response) {
      statusCode = response.statusCode;
      body = response.body;
      reason = response.reasonPhrase;

      Logger.v("www-form response: ${statusCode} ${reason} | ${body}");
    }).catchError((e) {
      body = "failed to send www-form request";
      reason = e.toString();

      Logger.e("failed to send www-form request: ${e}");
    });

    statusCode ??= 500;
    body ??= "HTTP ${statusCode}";
    reason ??= "unknown/internal error";

    return HttpResponse(statusCode, body, reason);
  }

  /// Convert given Map<String, dynamic> [params] to Map<String, String> type for www-form data.
  Map<String, String> _convertParams(Map<String, dynamic> params) {
    Map<String, String> converted = Map<String, String>();
    params?.forEach((key, value) {
      // check given parameter's value:
      String paramVal = null;
      try {
        // first try with .toJson(),
        paramVal = jsonEncode(value.toJson());
      } catch (_) {
        if (value is String) {
          paramVal = value;
        } else if (value is int) {
          paramVal = value.toString();
        } else {
          paramVal = jsonEncode(value);
        }
      }

      converted[key] = paramVal;
    });

    return converted;
  }

  /// Revoke access token
  void revokeAccessToken() {
    accessToken = null;
  }
}
