/// Wrapper library for Telegraph API (https://telegra.ph/api)

library telegraph;

import 'dart:async';

import 'src/types.dart';
import 'src/http.dart';
import 'src/logger.dart';

export 'src/types.dart';

/// API client class
class Client {
  HttpClient _httpClient;

  // default constructor
  Client(bool verbose) {
    Logger.verbose = verbose;

    _httpClient = HttpClient(null);
  }

  /// Load a client with a saved [accessToken].
  factory Client.load(String accessToken, {bool verbose}) {
    bool isVerbose = (verbose == null ? false : verbose);

    Client loaded = Client(isVerbose);
    loaded._httpClient.accessToken = accessToken;

    return loaded;
  }

  /// Create a new client.
  static Future<Client> create(String shortName,
      {String authorName, authorUrl, bool verbose}) async {
    bool isVerbose = (verbose == null ? false : verbose);

    Client created = Client(isVerbose);

    ResponseAccount res = await created.createAccount(shortName,
        authorName: authorName, authorUrl: authorUrl);

    if (res.ok) {
      // update access token
      created._httpClient.accessToken = res.result.accessToken;
      return created;
    } else {
      Logger.e("failed to create client: ${res.error}");
    }

    return null;
  }

  /// Get access token.
  String getAccessToken() {
    return _httpClient.accessToken;
  }

  ////////////////
  // methods

  /// Create a new Telegraph account.
  ///
  /// [shortName]: 1-32 characters
  /// [authorName]: 0-128 characters (optional)
  /// [authorUrl]: 0-512 characters (optional)
  ///
  /// http://telegra.ph/api#createAccount
  Future<ResponseAccount> createAccount(String shortName,
      {String authorName, authorUrl}) async {
    const String method = "createAccount";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{
      'short_name': shortName,
    };
    if (authorName != null) {
      params['author_name'] = authorName;
    }
    if (authorUrl != null) {
      params['author_url'] = authorUrl;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        return ResponseAccount.fromJson(res.toJson());
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return ResponseAccount(false, error: errStr);
  }

  /// Update information about a Telegraph account.
  ///
  /// [shortName]: 1-32 characters
  /// [authorName]: 0-128 characters (optional)
  /// [authorUrl]:  0-512 characters (optional)
  ///
  /// http://telegra.ph/api#editAccountInfo
  Future<Account> editAccountInfo(
      {String shortName, authorName, authorUrl}) async {
    const String method = "editAccountInfo";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{
      'short_name': shortName,
    };
    if (authorName != null) {
      params['author_name'] = authorName;
    }
    if (authorUrl != null) {
      params['author_url'] = authorUrl;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponseAccount result = ResponseAccount.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return Account(null, null, null)
      ..ok = false
      ..error = errStr;
  }

  /// Fetch information of a Telegraph account.
  ///
  /// [fields]: Available fields: "short_name", "author_name", "author_url", "auth_url", and "page_count"
  ///
  /// (default value = {"short_name", "author_name", "author_url"})
  ///
  /// http://telegra.ph/api#getAccountInfo
  Future<Account> getAccountInfo([List<String> fields]) async {
    const String method = "getAccountInfo";

    String errStr;

    if (fields == null) {
      fields = ["short_name", "author_name", "author_url"];
    }

    Map<String, dynamic> params = <String, dynamic>{
      'fields': fields,
    };

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponseAccount result = ResponseAccount.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return Account(null, null, null)
      ..ok = false
      ..error = errStr;
  }

  /// RevokeAccessToken revokes access token and generate a new one.
  ///
  /// http://telegra.ph/api#revokeAccessToken
  Future<Account> revokeAccessToken() async {
    const String method = "revokeAccessToken";

    String errStr;

    HttpResponse res = await _httpClient.request(method, null);
    if (res.statusCode == 200) {
      try {
        ResponseAccount result = ResponseAccount.fromJson(res.toJson());

        if (result.ok) {
          Logger.v("Access token revoked.");

          _httpClient.revokeAccessToken();

          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return Account(null, null, null)
      ..ok = false
      ..error = errStr;
  }

  /// Create a new Telegraph page.
  ///
  /// [title]: 1-256 characters
  /// [authorName]: 0-128 characters (optional)
  /// [authorUrl]:  0-512 characters (optional)
  /// [content]: Array of [NodeType]
  /// [returnContent]: return created [Page] object or not
  ///
  /// http://telegra.ph/api#createPage
  Future<Page> createPage(String title, List<NodeType> content,
      {String authorName, authorUrl, bool returnContent}) async {
    const String method = "createPage";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{
      'title': title,
      'content': content,
    };

    if (authorName != null) {
      params['author_name'] = authorName;
    }
    if (authorUrl != null) {
      params['author_url'] = authorUrl;
    }
    if (returnContent != null) {
      params['return_content'] = returnContent;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponsePage result = ResponsePage.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return Page(null, null, null, null, null)
      ..ok = false
      ..error = errStr;
  }

  /// Edit an existing Telegraph page.
  ///
  /// [path]: Path to the [Page]
  /// [title]: 1-256 characters
  /// [content]: Array of [NodeType]
  /// [authorName]: 0-128 characters (optional)
  /// [authorUrl]:  0-512 characters (optional)
  /// [returnContent]: return edited [Page] object or not
  ///
  /// http://telegra.ph/api#editPage
  Future<Page> editPage(String path, title, List<NodeType> content,
      {String authorName, authorUrl, bool returnContent}) async {
    const String method = "editPage";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{
      'path': path,
      'title': title,
      'content': content,
    };

    if (authorName != null) {
      params['author_name'] = authorName;
    }
    if (authorUrl != null) {
      params['author_url'] = authorUrl;
    }
    if (returnContent != null) {
      params['return_content'] = returnContent;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponsePage result = ResponsePage.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return Page(null, null, null, null, null)
      ..ok = false
      ..error = errStr;
  }

  /// Fetch a Telegraph page.
  ///
  /// [path]: Path to the Telegraph page
  /// [returnContent]: return the [Page] object or not
  ///
  /// http://telegra.ph/api#getPage
  Future<Page> getPage(String path, {bool returnContent}) async {
    const String method = "getPage";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{
      'path': path,
    };

    if (returnContent != null) {
      params['return_content'] = returnContent;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponsePage result = ResponsePage.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return Page(null, null, null, null, null)
      ..ok = false
      ..error = errStr;
  }

  /// Fetch a list of pages belonging to a Telegraph account.
  ///
  /// [offset]: Sequential number of the first page (default = 0)
  /// [limit]: Number of pages to be returned (0-200, default = 50)
  ///
  /// http://telegra.ph/api#getPageList
  Future<PageList> getPageList({int offset, limit}) async {
    const String method = "getPageList";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{};

    if (offset != null) {
      params['offset'] = offset;
    }
    if (limit != null) {
      params['limit'] = limit;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponsePageList result = ResponsePageList.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return PageList(null, null)
      ..ok = false
      ..error = errStr;
  }

  /// Fetch the number of views for a Telegraph page.
  ///
  /// [path]: Path to the Telegraph page
  /// [year]: 2000-2100 (required when 'month' is passed)
  /// [month]: 1-12 (required when 'day' is passed)
  /// [day]: 1-31 (required when 'hour' is passed)
  /// [hour]: 0-24 (pass -1 if none)
  ///
  /// http://telegra.ph/api#getViews
  Future<PageViews> getViews(String path, {int year, month, day, hour}) async {
    const String method = "getViews";

    String errStr;

    Map<String, dynamic> params = <String, dynamic>{
      'path': path,
    };

    if (year != null) {
      params['year'] = year;
    }
    if (month != null) {
      params['month'] = month;
    }
    if (day != null) {
      params['day'] = day;
    }
    if (hour != null) {
      params['hour'] = hour;
    }

    HttpResponse res = await _httpClient.request(method, params);
    if (res.statusCode == 200) {
      try {
        ResponsePageViews result = ResponsePageViews.fromJson(res.toJson());

        if (result.ok) {
          return result.result;
        } else {
          errStr = "${method} failed: ${result.error}";
        }
      } catch (e) {
        errStr = "${method} failed with json parse error: ${e} (${res.body})";
      }
    } else {
      errStr = errorDescriptionFrom(method, res);
    }

    Logger.e(errStr);

    return PageViews(null)
      ..ok = false
      ..error = errStr;
  }
}

/// Extract error description from given [HttpResponse].
String errorDescriptionFrom(String method, HttpResponse response) {
  try {
    Response res = Response.fromJson(response.toJson());
    return "${method} failed with error: ${res.error}";
  } catch (e) {
    return "${method} failed with error: ${response.reason} (${response.body}: ${e})";
  }
}
