import 'package:emodi/communitys/feed_write.dart';
import 'package:flutter/material.dart';
import 'package:emodi/communitys/feed.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/Auth/auth_manager.dart';

class CommunityHomePage extends StatefulWidget {
  final AuthManager authManager;
  const CommunityHomePage({super.key, required this.authManager});

  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = widget.authManager;
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
            MaterialPageRoute(builder: (context) => HlogWritePage(authManager: _authManager)),
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
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) => const HlogPage(
        userUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnnObTCNg1QJoEd9Krwl3kSUnPYTZrxb5Ig&usqp=CAU',
        userName: '_ugsxng99',
        images: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnnObTCNg1QJoEd9Krwl3kSUnPYTZrxb5Ig&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRisv-yQgXGrto6OxQxX62JyvyQGvRsQQ760g&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQifBWUhSiSfL0t8M3XCOe8aIyS6de2xWrt5A&usqp=CAU',
        ],
        countLikes: 12,
        writeTime: '10:33 AM. 28 Feb',
        diaryTitle: '제목',
        diaryDay: '2024-05-22',
        likedProfile: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnnObTCNg1QJoEd9Krwl3kSUnPYTZrxb5Ig&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRisv-yQgXGrto6OxQxX62JyvyQGvRsQQ760g&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQifBWUhSiSfL0t8M3XCOe8aIyS6de2xWrt5A&usqp=CAU',
        ],
      ),
    );
  }
}
