import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';

int postsNum = 0;
int likesNum = 0;
int commentsNum = 0;

class PopUpPage extends StatefulWidget {
  final String friendName;
  final String imageUrl;
  final bool showEditProfileButton;
  final bool isPopup;

  const PopUpPage({
    Key? key,
    required this.friendName,
    required this.imageUrl,
    this.showEditProfileButton = true,
    this.isPopup = false,
  }) : super(key: key);

  @override
  State<PopUpPage> createState() => _PopUpPageState();
}

class _PopUpPageState extends State<PopUpPage> {
  bool showEditProfileButton = false;

  @override
  void initState() {
    super.initState();
    showEditProfileButton = widget.showEditProfileButton;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 12),
          child: Align(
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
                  '${widget.friendName}@hanyang.ac.kr',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: 30,
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
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showEditProfileButton = !showEditProfileButton;
                    });
                  },
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: showEditProfileButton ? Constants.primaryColor : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        showEditProfileButton ? '팔로잉' : '친구 추가',
                        style: TextStyle(
                          color: showEditProfileButton ? Colors.white : Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
