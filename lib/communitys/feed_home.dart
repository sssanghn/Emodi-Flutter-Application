import 'package:emodi/communitys/feed_write.dart';
import 'package:flutter/material.dart';
import 'package:emodi/communitys/feed.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/communitys/feed_model.dart';
import 'package:emodi/communitys/feed_remote_api.dart';
import 'package:emodi/Auth/jwt_token_model.dart';

class CommunityHomePage extends StatefulWidget {
  final AuthManager authManager;
  final int id;
  const CommunityHomePage({super.key, required this.id, required this.authManager});

  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  late AuthManager _authManager;
  late Future<JwtToken> jwtTokenFuture;
  late FeedRemoteApi api;
  List<Post>? loadPosts;

  @override
  void initState() {
    super.initState();
    _authManager = widget.authManager;
    jwtTokenFuture = _authManager.loadAccessToken();
    api = FeedRemoteApi();
    loadFeeds();
  }

  void loadFeeds() async {
    try {
      JwtToken jwtToken = await jwtTokenFuture;
      List<Post> posts = await api.LoadPostsGet(jwtToken, widget.id);
      setState(() {
        loadPosts = posts;
      });
    } catch (e) {
      print('Failed to load my Info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 50),
            Text(
            'Emo',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Constants.primaryColor,
              fontSize: 25,
            ),
          ),
            Text(
              'Di',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
        ],
        ),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // 알림 버튼을 눌렀을 때 액션
            },
            icon: Icon(
              Icons.notifications_none,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _body(),
          ),
        ],
      ),
      floatingActionButton:
      Align(
    alignment: Alignment.bottomRight,
    child: Padding(
    padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
    child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HlogWritePage(id: widget.id, authManager: _authManager)),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _body() {
    if (loadPosts == null) {
      return Center(child: CircularProgressIndicator(
        color: Constants.primaryColor,
      ));
    } else {
    return ListView.builder(
      itemCount: loadPosts!.length,
      itemBuilder: (context, index) {
        final post = loadPosts![index];
        return HlogPage(
          keywords: post.keywords,
          userUrl: post.imageUrl,
          userName: post.memberLoginId,
          images: [post.imageUrl],
          likeCount: post.likeCount,
          writeTime: post.createdAt.toLocal().toString(),
          diaryTitle: post.title,
          diaryDay: '2024-06-05',
        );
      }
    );
  }
}}
