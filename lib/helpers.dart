import 'package:flutter/widgets.dart';

Widget padding10(Widget inner) =>
    Container(padding: EdgeInsets.all(10), child: inner);

Widget row(List<Widget> inners) => Row(children: inners);

Widget column(List<Widget> inners) =>
    Column(children: inners, crossAxisAlignment: CrossAxisAlignment.start);

String getConversationName(dynamic data, dynamic profile, dynamic group) {
  var conversation = data['conversation'];

  switch (conversation['peer']['type']) {
    case 'user':
      return profile == null
          ? "Unknown"
          : "${profile['first_name']} ${profile['last_name']}";

    case 'chat':
      return conversation['chat_settings']['title'];

    case 'group':
      return group['name'];

    default:
      return "Unknown";
  }
}
