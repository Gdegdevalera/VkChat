import 'dart:convert';
import 'package:http/http.dart' as http;

class VkApi {
  static Future<dynamic> getConversations(String token) =>
      get("messages.getConversations?extended=1", token);

  static Future<dynamic> getHistory(String token, int peerId) =>
      get("messages.getHistory?extended=1&count=100&peer_id=$peerId", token);

  static Future<dynamic> get(String url, String token) async {
    final response = await http.get(
        "https://api.vk.com/method/" + url + "&v=5.92&access_token=" + token);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['error'] == null) {
        return result;
      }
    }

    throw Exception('Failed to load' + url);
  }
}
