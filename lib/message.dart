import 'package:flutter/widgets.dart';
import 'package:vkchat/helpers.dart';

class Message extends StatelessWidget {
  Message({this.data, this.profile, this.group});
  final dynamic data;
  final dynamic profile;
  final dynamic group;

  @override
  Widget build(BuildContext context) => padding10(
    Text('${name()} - ${data['text']}')
  );

  name() {
    if(profile != null) {
      return profile['first_name'];
    }

    return group['name'];
  }
}
