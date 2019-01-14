import 'package:flutter/material.dart';
import 'package:vkchat/authorization.dart';
import 'package:vkchat/helpers.dart';
import 'package:vkchat/message.dart';
import 'package:vkchat/preview-message.dart';
import 'package:vkchat/vk-api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String token;
  int peerId = 0;

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(
          title: Text("VK Chat"),
          actions: [FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () => getToken(context))], 
        ), 
        body: body());

  Widget body() {
    if (token == null) {
      return Text('Token is missing');
    }

    return FutureBuilder(
        future: VkApi.getConversations(token),
        builder: (context, data) {
          if (data.hasError) return Text(data.error);
          if (!data.hasData) return CircularProgressIndicator();

          var jsonProfiles = data.data['response']['profiles'];
          var jsonGroups = data.data['response']['groups'];
          var jsonItems = data.data['response']['items'] as Iterable<dynamic>;
          var profiles = Map.fromIterable(jsonProfiles ?? [],
              key: (p) => p['id'] as int, value: (p) => p);
          var groups = Map.fromIterable(jsonGroups ?? [],
              key: (p) => p['id'] as int, value: (p) => p);

          var previews = jsonItems
              .map((c) {
                final profile = profiles[c['conversation']['peer']['id']];
                final group = groups[c['conversation']['peer']['local_id']];
                final peerId = c['conversation']['peer']['id'];
                final name = getConversationName(c, profile, group);
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => 
                        ConversaionScreen(name: name, token: token, peerId: peerId))
                    );
                  },
                  child: ConversationPreview(data: c,
                      profile: profile,
                      group: group));
              })
              .toList();
          return ListView(children: previews);
        });
  }

  getToken(BuildContext context) async {
    token = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authoriztion())
    );
  }
}

class ConversaionScreen extends StatefulWidget {
  ConversaionScreen({this.name, this.token, this.peerId});
  final String name;
  final String token;
  final int peerId;

  _ConversaionScreenState createState() => _ConversaionScreenState();
}

class _ConversaionScreenState extends State<ConversaionScreen> {
  @override
  Widget build(BuildContext context) => 
      Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: FutureBuilder(
          future: VkApi.getHistory(widget.token, widget.peerId),
          builder: (context, data) {
            if (data.hasError) return Text(data.error);
            if (!data.hasData) return CircularProgressIndicator();

            var jsonProfiles = data.data['response']['profiles'];
            var jsonGroups = data.data['response']['groups'];
            var jsonItems = data.data['response']['items'] as Iterable<dynamic>;
            var profiles = Map.fromIterable(jsonProfiles ?? [],
                key: (p) => p['id'] as int, value: (p) => p);
            var groups = Map.fromIterable(jsonGroups ?? [],
                key: (p) => p['id'] as int, value: (p) => p);

            var previews = jsonItems
                .map((c) => Message(
                  data: c, 
                  profile: profiles[c['from_id']], 
                  group: groups[-c['from_id']]))
                .toList();
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/back.png'))
              ),
              child: ListView(children: previews)
            );
          }));
}


