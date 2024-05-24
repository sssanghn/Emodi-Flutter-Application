// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';

int postsNum = 0;
int likesNum = 0;
int commentsNum = 0;
String userName = 'ETRI';
String userEmail = 'ETRI@hanyang.ac.kr';
NetworkImage userImage = NetworkImage('https://via.placeholder.com/150');

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '마이페이지',
            style: Constants.titleTextStyle,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.settings),
            ),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: userImage,
              ),
              SizedBox(height: 7),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Card(
                  surfaceTintColor: Color(0xFFfffbfe),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "게시물",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                postsNum.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "팔로잉",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                likesNum.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "팔로워",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  likesNum.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constants.primaryColor,
                                  ),
                                )
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12), // Add some space before the ListView

              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Card(
                  surfaceTintColor: Colors.white,
                  child: Column(
                    children: ListTile.divideTiles(context: context, tiles: [
                      ListTile(
                        leading: Icon(CupertinoIcons.person),
                        title: Text('프로필 수정'),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {
                          // Handle Edit Profile tap
                        },
                      ),
                      ListTile(
                        leading: Icon(CupertinoIcons.exclamationmark_bubble),
                        trailing: const Icon(Icons.navigate_next),
                        title: Text('공지사항'),
                        onTap: () {
                          // Handle Announcements tap
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        trailing: const Icon(Icons.navigate_next),
                        title: Text('로그아웃'),
                        onTap: () {
                          // Handle Logout tap
                        },
                      ),
                    ]).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
