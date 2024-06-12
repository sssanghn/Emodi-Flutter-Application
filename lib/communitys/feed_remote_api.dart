import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emodi/Auth/jwt_token_model.dart';
import 'package:emodi/communitys/feed_model.dart'; // Import the new post model

class FeedRemoteApi {
  late http.Client httpClient;

  FeedRemoteApi() {
    httpClient = http.Client();
  }

  // 뭔지 모를 get
  Future<List<Post>> PostsGet(JwtToken jwtToken, String date) async {
    var uri = Uri.https('emo-di.com', 'api/posts/date', {'date': date});

    final http.Response response = await httpClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // 게시물 10개 불러오기
  Future<List<Post>> LoadPostsGet(JwtToken jwtToken, int memberId) async {
    var uri = Uri.https('emo-di.com', 'feed', {'memberId': memberId.toString()});

    final http.Response response = await httpClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> content = data['content'];
      return content.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}