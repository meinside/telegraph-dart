/// Type definitions
///
/// https://telegra.ph/api#Available-types

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import './logger.dart';

///////////////////////////////////////
//
// Enum types and helper functions
//

////////////////
// API responses

/// Base class of all API responses.
class Response {
  bool ok; // 'ok'
  String error; // 'error' (optional)

  // constructor
  Response(this.ok, {this.error});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(json['ok'] as bool,
        error: json['error'] == null ? null : json['error'] as String);
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'ok': ok,
    };

    if (error != null) {
      json['error'] = error;
    }

    return json;
  }
}

//// ResponseAccount class.
class ResponseAccount extends Response {
  Account result; // 'result' (optional)

  // constructor
  ResponseAccount(bool ok, {String error, this.result})
      : super(ok, error: error);

  factory ResponseAccount.fromJson(Map<String, dynamic> json) {
    return ResponseAccount(json['ok'] as bool,
        error: json['error'] == null ? null : json['error'] as String,
        result: Account.fromJson(json['result']));
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'ok': ok,
    };

    if (error != null) {
      json['error'] = error;
    }
    if (result != null) {
      json['result'] = result;
    }

    return json;
  }
}

/// ResponsePage class.
class ResponsePage extends Response {
  Page result; // 'result' (optional)

  // constructor
  ResponsePage(bool ok, {String error, this.result}) : super(ok, error: error);

  factory ResponsePage.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return ResponsePage(json['ok'] as bool,
        error: json['error'] == null ? null : json['error'] as String,
        result: Page.fromJson(json['result']));
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'ok': ok,
    };

    if (error != null) {
      json['error'] = error;
    }
    if (result != null) {
      json['result'] = result;
    }

    return json;
  }
}

/// ResponsePageList class.
class ResponsePageList extends Response {
  PageList result; // 'result' (optional)

  // constructor
  ResponsePageList(bool ok, {String error, this.result})
      : super(ok, error: error);

  factory ResponsePageList.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return ResponsePageList(json['ok'] as bool,
        error: json['error'] == null ? null : json['error'] as String,
        result: PageList.fromJson(json['result']));
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'ok': ok,
    };

    if (error != null) {
      json['error'] = error;
    }
    if (result != null) {
      json['result'] = result;
    }

    return json;
  }
}

/// ResponsePageViews class.
class ResponsePageViews extends Response {
  PageViews result; // 'result' (optional)

  // constructor
  ResponsePageViews(bool ok, {String error, this.result})
      : super(ok, error: error);

  factory ResponsePageViews.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return ResponsePageViews(json['ok'] as bool,
        error: json['error'] == null ? null : json['error'] as String,
        result: PageViews.fromJson(json['result']));
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'ok': ok,
    };

    if (error != null) {
      json['error'] = error;
    }
    if (result != null) {
      json['result'] = result;
    }

    return json;
  }
}

////////////////
// types

/// Base class for non-API responses which need result values.
class Returned {
  bool ok;
  String error;

  Returned() : this.ok = true;
}

/// Account class.
///
/// http://telegra.ph/api#Account
class Account extends Returned {
  String shortName; // short_name
  String authorName; // author_name
  String authorUrl; // author_url

  String accessToken; // access_token (optional)
  String authUrl; // auth_url (optional)
  int pageCount; // page_count (optional)

  // constructor
  Account(this.shortName, this.authorName, this.authorUrl,
      {this.accessToken, this.authUrl, this.pageCount});

  factory Account.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Account(json['short_name'] as String, json['author_name'] as String,
        json['author_url'] as String,
        accessToken: json['access_token'] == null
            ? null
            : json['access_token'] as String,
        authUrl: json['auth_url'] == null ? null : json['auth_url'] as String,
        pageCount:
            json['page_count'] == null ? null : json['page_count'] as int);
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'short_name': shortName,
      'author_name': authorName,
      'author_url': authorUrl,
    };

    if (accessToken != null) {
      json['access_token'] = accessToken;
    }
    if (authUrl != null) {
      json['auth_url'] = authUrl;
    }
    if (pageCount != null) {
      json['page_count'] = pageCount;
    }

    return json;
  }
}

/// Node type.
///
/// It can be a String, or a [NodeElement]
///
/// http://telegra.ph/api#Node
class NodeType {
  String strValue;
  NodeElement nodeElementValue;

  // default constructor
  NodeType();

  factory NodeType.fromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    if (json is String) {
      return NodeType()..strValue = json;
    } else {
      return NodeType()..nodeElementValue = NodeElement.fromJson(json);
    }
  }

  dynamic toJson() {
    if (strValue != null) {
      return strValue;
    } else if (nodeElementValue != null) {
      return nodeElementValue.toJson();
    }

    return null;
  }

  /// Generate a [NodeType] from given string.
  factory NodeType.fromString(String str) {
    return NodeType()..strValue = str;
  }

  /// Generate a [NodeType] from given [tag], [attrs], and [children].
  factory NodeType.from(String tag,
      {Map<String, String> attrs, List<NodeType> children}) {
    return NodeType()
      ..nodeElementValue = NodeElement(tag, attrs: attrs, children: children);
  }

  /// Generate a [NodeType] from given [elem].
  factory NodeType.fromNodeElement(NodeElement elem) {
    return NodeType()..nodeElementValue = elem;
  }

  /// Generate a [NodeType] from given [NodeElement]'s [json] value.
  factory NodeType.fromNodeElementJson(Map<String, dynamic> json) {
    return NodeType()..nodeElementValue = NodeElement.fromJson(json);
  }

  /// Generate a list of [NodeType] from given [json] value.
  static List<NodeType> listFromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    List<NodeType> list = List<NodeType>();

    for (dynamic child in json as List<dynamic>) {
      if (child is String) {
        list.add(NodeType.fromString(child));
      } else {
        list.add(NodeType.fromNodeElementJson(child));
      }
    }

    return list;
  }

  /// Convert given list of [NodeType] to json value.
  static List<dynamic> listToJson(List<NodeType> list) {
    if (list == null) {
      return null;
    }

    List<dynamic> json = List<dynamic>();

    for (NodeType child in list) {
      if (child.strValue != null) {
        json.add(child.strValue);
      } else if (child.nodeElementValue != null) {
        json.add(child.nodeElementValue.toJson());
      }
    }

    return json;
  }

  /// Create new nodes with given HTML string.
  static List<NodeType> listFromHtml(String html) {
    try {
      Document document = parse(html, generateSpans: true);

      // recursion function
      List<NodeType> traverseChildrenOf(Node elem) {
        List<NodeType> nodes = [];

        for (Node node in elem.nodes) {
          if (node is Text) {
            nodes.add(NodeType.fromString(node.text));

            //print("* Added text node: ${node.text}");
          } else if (node is Element) {
            // convert attributes,
            Map<String, String> attrs = <String, String>{};

            void convertAttrs(dynamic key, String value) {
              if (key is String) {
                attrs[key] = value;
              } else if (key is AttributeName) {
                attrs[key.name] = value;
              }
            }

            node.attributes.forEach(convertAttrs);

            nodes.add(NodeType.from(node.localName,
                attrs: attrs, children: traverseChildrenOf(node)));

            //print("* Added element node: <${node.localName}>${node.text}</${node.localName}>");
          }
        }

        return nodes.length == 0 ? null : nodes;
      }

      return traverseChildrenOf(document.body);
    } catch (e) {
      Logger.e("failed to generate nodes from html: ${e}");
    }

    return null;
  }
}

/// NodeElement type.
///
/// http://telegra.ph/api#NodeElement
class NodeElement {
  String tag; // tag
  Map<String, String> attrs; // attrs (optional)
  List<NodeType> children; // children (optional)

  // constructor
  NodeElement(this.tag, {this.attrs, this.children});

  factory NodeElement.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    NodeElement nodeElement = NodeElement(json['tag'] as String,
        attrs:
            json['attrs'] == null ? null : json['attrs'] as Map<String, String>,
        children: NodeType.listFromJson(json['children']));

    return nodeElement;
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'tag': tag,
    };

    if (attrs != null) {
      json['attrs'] = attrs;
    }
    if (children != null) {
      json['children'] = NodeType.listToJson(children);
    }

    return json;
  }
}

/// Page type
///
/// http://telegra.ph/api#Page
class Page extends Returned {
  String path; // path
  String url; // url
  String title; // title
  String description; // description
  int views; // views

  String authorName; // author_name (optional)
  String authorUrl; // author_url (optional)
  String imageUrl; // image_url (optional)
  List<NodeType> content; // content (optional)
  bool canEdit; // can_edit (optional)

  // constructor
  Page(this.path, this.url, this.title, this.description, this.views,
      {this.authorName,
      this.authorUrl,
      this.imageUrl,
      this.content,
      this.canEdit});

  factory Page.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Page(
        json['path'] as String,
        json['url'] as String,
        json['title'] as String,
        json['description'] as String,
        json['views'] as int,
        authorName:
            json['author_name'] == null ? null : json['author_name'] as String,
        authorUrl:
            json['author_url'] == null ? null : json['author_url'] as String,
        imageUrl:
            json['image_url'] == null ? null : json['image_url'] as String,
        content: NodeType.listFromJson(json['content']),
        canEdit: json['can_edit'] == null ? null : json['can_edit'] as bool);
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'path': path,
      'url': url,
      'title': title,
      'description': description,
      'views': views,
    };

    if (authorName != null) {
      json['author_name'] = authorName;
    }
    if (authorUrl != null) {
      json['author_url'] = authorUrl;
    }
    if (imageUrl != null) {
      json['image_url'] = imageUrl;
    }
    if (content != null) {
      json['content'] = NodeType.listToJson(content);
    }
    if (canEdit != null) {
      json['can_edit'] = canEdit;
    }

    return json;
  }

  static List<Page> listFromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    List<Page> pages = List<Page>();

    for (dynamic page in json as List<dynamic>) {
      pages.add(Page.fromJson(page));
    }

    return pages;
  }

  static List<dynamic> listToJson(List<Page> pages) {
    if (pages == null) {
      return null;
    }

    List<dynamic> nodes = List<dynamic>();

    for (Page page in pages) {
      nodes.add(page.toJson());
    }

    return nodes;
  }
}

/// PageList type
///
/// http://telegra.ph/api#PageList
class PageList extends Returned {
  int totalCount; // total_count
  List<Page> pages; // pages

  // constructor
  PageList(this.totalCount, this.pages);

  factory PageList.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return PageList(
        json['total_count'] as int, Page.listFromJson(json['pages']));
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'total_count': totalCount,
      'pages': Page.listToJson(pages),
    };

    return json;
  }
}

/// PageViews type
///
/// http://telegra.ph/api#PageViews
class PageViews extends Returned {
  int views; // views

  // constructor
  PageViews(this.views);

  factory PageViews.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return PageViews(json['views'] as int);
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'views': views,
    };

    return json;
  }
}
