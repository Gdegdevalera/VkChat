import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Authoriztion extends StatefulWidget {
  _AuthoriztionState createState() => _AuthoriztionState();
}

class _AuthoriztionState extends State<Authoriztion> {
  String token;

  var authUrl = "https://oauth.vk.com/authorize?client_id=6801922&display=page&" +
      "redirect_uri=https://oauth.vk.com/blank.html&scope=messages&response_type=token&v=5.92";

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((url) {
      print(url);
      var extractor = RegExp('#access_token=(.*?)&');
      if (extractor.hasMatch(url)) {
        setState(() {
          token = extractor.allMatches(url).single.group(1);
          print('token: ' + token);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token != null) {
      Navigator.pop(context, token);
    }

    return WebviewScaffold(url: authUrl);
  }
}
