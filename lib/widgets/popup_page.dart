import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';

int postsNum = 0;
int likesNum = 0;
int commentsNum = 0;

class MyPage extends StatefulWidget {
  final String friendName;
  final String imageUrl;
  final bool showEditProfileButton;
  final bool isPopup;

  const MyPage({
    Key? key,
    required this.friendName,
    required this.imageUrl,
    this.showEditProfileButton = true,
    this.isPopup = false,
  }) : super(key: key);

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
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.settings),
            ),
          ]
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              SizedBox(height: 7),
              Text(
                widget.friendName,
                style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0),
              Text(
                'ETRI@hanyang.ac.kr', // This can be changed to dynamically use a value if required
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
            ],
          ),
        ),
      ),
    );
  }
}
