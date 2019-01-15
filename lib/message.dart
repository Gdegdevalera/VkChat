import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vkchat/helpers.dart';

class Message extends StatelessWidget {
  Message({this.data, this.profile, this.group});
  final dynamic data;
  final dynamic profile;
  final dynamic group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: body(context));
  }

  body(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 50) * 0.7;
    final text = [
        Text(name(), style: TextStyle(color: Colors.grey, fontSize: 9)),
        Text(data['text'], textAlign: TextAlign.left)
      ];

    if (data['out'] == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          portrait(),
          Container(
              padding: const EdgeInsets.all(5),
              width: width,
              decoration: BoxDecoration(
                color: const Color(0xCCF1F1F1),
                borderRadius: BorderRadius.circular(7),
                // boxShadow: [BoxShadow(
                //   color: Colors.grey,
                //   blurRadius: 10,
                //   offset: Offset(1, 1))]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: text)
            )
          ]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              width: width,
              decoration: BoxDecoration(
                color: const Color(0xCCF1F1F1),
                borderRadius: BorderRadius.circular(7)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: text)
            ),
          portrait()
          ]);
  }

  name() {
    if(profile != null) {
      return profile['first_name'];
    }

    return group['name'];
  }

  portrait() {
    final padding = data['out'] == 0 
      ? EdgeInsets.only(right: 7)
      : EdgeInsets.only(left: 7);

    if(profile != null) {
      return Container(
          padding: padding,
          child: cachedImage(profile['photo_50']));
    }

    return Icon(Icons.chat);
  }
}
