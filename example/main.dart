// example/main.dart
//
// A sample client which creates and edites posts on Telegraph.

import '../lib/telegraph.dart';

import 'dart:convert';

// NOTE: Set this to 'true' for verbose messages.
const bool _isVerbose = false;

String _jsonToString(Object json) {
  return jsonEncode(json);
}

main() async {
  String savedAccessToken;

  // create a new account,
  Client newClient = await Client.create("meinside", verbose: _isVerbose);

  if (newClient != null) {
    // save access token,
    savedAccessToken = newClient.getAccessToken();

    // get account info,
    Account account = await newClient.getAccountInfo(
        ["short_name", "author_name", "author_url", "auth_url", "page_count"]);

    if (account.ok) {
      print("> got account info: ${_jsonToString(account.toJson())}");

      // edit account info,
      Account editedAccount =
          await newClient.editAccountInfo(shortName: "meinsideme");
      if (editedAccount.ok) {
        print(
            "> edited account info to: ${_jsonToString(editedAccount.toJson())}");
      } else {
        print("* error editing account info: ${editedAccount.error}");
      }
    } else {
      print("* error getting account info: ${account.error}");
    }

    // create page,
    Page newPage = await newClient.createPage(
        "New page", [NodeType.fromString("plain text")],
        returnContent: true);
    if (newPage.ok) {
      print("> created a new page: ${_jsonToString(newPage.toJson())}");

      String savedPagePath = newPage.path;

      // edit page,
      Page editedPage = await newClient.editPage(
          savedPagePath,
          "Edited page",
          [
            NodeType.fromString("This is the first line."),
            NodeType.from("br"),
            NodeType.from("p", children: [
              NodeType.fromString("This is the "),
              NodeType.from("b", children: [
                NodeType.fromString("second"),
              ]),
              NodeType.fromString(" line."),
            ]),
          ],
          returnContent: true);
      if (editedPage.ok) {
        print("> edited a page: ${_jsonToString(editedPage.toJson())}");
      } else {
        print("* error editing a page: ${editedPage.error}");
      }

      // get page,
      Page gotPage =
          await newClient.getPage(savedPagePath, returnContent: true);
      if (gotPage.ok) {
        print("> got page: ${_jsonToString(gotPage.toJson())}");
      } else {
        print("* error getting a page: ${gotPage.error}");
      }

      // get views,
      PageViews views = await newClient.getViews(savedPagePath);
      if (views.ok) {
        print("> got views: ${_jsonToString(views.toJson())}");
      } else {
        print("* error getting views of a page: ${views.error}");
      }
    } else {
      print("* error creating a new page: ${newPage.error}");
    }
  } else {
    print("* error creating a new client");
  }

  if (savedAccessToken != null) {
    // load an account with the saved access token,
    Client loadedClient = Client.load(savedAccessToken, verbose: _isVerbose);

    // create page with html,
    Page newPage = await loadedClient.createPage(
        "New page with HTML",
        NodeType.listFromHtml(
            "This is the 1st line.<br/>And this is the <b>2nd</b> line.<br/>Then it <b><i>must</i></b> be the <b>3rd</b> line."),
        returnContent: true);
    if (newPage.ok) {
      print(
          "> created a new page with HTML: ${_jsonToString(newPage.toJson())}");
    } else {
      print("* failed to create a new page with HTML: ${newPage.error}");
    }

    // get page list,
    PageList pages = await loadedClient.getPageList(offset: 0, limit: 100);
    if (pages.ok) {
      print("> got pages: ${_jsonToString(pages.toJson())}");
    } else {
      print("* failed to get pages: ${pages.error}");
    }

    // and revoke access token.
    Account revoked = await loadedClient.revokeAccessToken();
    if (revoked.ok) {
      print(
          "> revoked access token for account: ${_jsonToString(revoked.toJson())}");
    } else {
      print("* failed to revoke access token: ${revoked.error}");
    }
  }
}
