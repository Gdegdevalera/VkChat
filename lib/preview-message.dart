import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:vkchat/helpers.dart';

class ConversationPreview extends StatelessWidget {
  ConversationPreview({this.data, this.profile, this.group});
  final dynamic data;
  final dynamic profile;
  final dynamic group;
  final messageDateFormatter = DateFormat('Hm');

  @override
  Widget build(BuildContext context) => padding10(row([
        portrait(),
        Expanded(child: padding10(column([name(), previewMessage()]))),
        Column(children: [messageTime(), unreadCount()])
      ]));

  Widget messageTime() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
        data['last_message']['date'] * 1000);

    return Text(messageDateFormatter.format(dateTime),
        textAlign: TextAlign.right, style: TextStyle(color: Colors.grey));
  }

  Widget previewMessage() {
    var jsonMessage = data['last_message'];
    var jsonAction = jsonMessage['action'];
    String text = jsonAction != null ? jsonAction['type'] : jsonMessage['text'];

    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  Widget name() => 
    Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(getConversationName(data, profile, group),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold)));

  Widget portrait() {
    var conversation = data['conversation'];
    switch (conversation['peer']['type']) {
      case 'user':
        return Image.network(profile["photo_50"]);

      case 'chat':
        var photo = conversation['chat_settings']['photo'];
        return photo != null
            ? Image.network(photo['photo_50'])
            : Icon(Icons.chat, size: 50);

      case 'group':
        return Image.network(group['photo_50']);

      default:
        return Icon(Icons.portrait, size: 50);
    }
  }

  Widget unreadCount() {
    var count = '2'; //data['conversation']['unreadcount'];

    var result = Container(
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
        child: Text(count.toString(), style: TextStyle(color: Colors.white)));

    return count == null ? Opacity(opacity: 0, child: result) : result;
  }
}
