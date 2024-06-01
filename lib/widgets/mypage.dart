import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/widgets/announcements_page.dart';
import 'package:emodi/Auth/explanation.dart'; // explanation.dart 페이지를 임포트합니다.

int postsNum = 0;
int likesNum = 0;
int commentsNum = 0;

class MyPage extends StatefulWidget {
  final String friendName;
  final String imageUrl;

  MyPage({
    Key? key,
    required this.friendName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = widget.imageUrl;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImageUrl = image.path;
      });
    }
  }

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
                backgroundImage: AssetImage(
                    'assets/app_icon.png'
                ),
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
                          _pickImage();
                        },
                      ),
                      ListTile(
                        leading: Icon(CupertinoIcons.exclamationmark_bubble),
                        trailing: const Icon(Icons.navigate_next),
                        title: Text('공지사항'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnnouncementsPage()
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        trailing: const Icon(Icons.navigate_next),
                        title: Text('로그아웃'),
                        onTap: () {
                          // 로그아웃 버튼을 눌렀을 때 처음 화면으로 이동하도록 설정합니다.
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExplanationPage(),
                            ),
                                (route) => false,
                          );
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
