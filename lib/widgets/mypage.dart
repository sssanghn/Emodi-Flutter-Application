import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/widgets/announcements_page.dart';
import 'package:emodi/Auth/explanation.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/Auth/auth_repository.dart';
import 'package:emodi/Auth/auth_remote_api.dart';
import 'package:emodi/DataSource/local_data_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emodi/widgets/mypage_model.dart';
import 'package:emodi/widgets/mypage_remote_api.dart';
import 'package:emodi/Auth/jwt_token_model.dart';

class MyPage extends StatefulWidget {
  final AuthManager authManager;
  final int id;

  MyPage({
    Key? key,
    required this.authManager,
    required this.id,
  }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late AuthManager _authManager;
  late AuthRepository _authRepository;
  String? _profileImageUrl;
  late Future<JwtToken> jwtTokenFuture;
  late myPageRemoteApi api;
  UserInfo? myInfo;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(LocalDataStorage(), AuthRemoteApi());
    _authManager = widget.authManager;
    jwtTokenFuture = _authManager.loadAccessToken();
    api = myPageRemoteApi();
    loadMyInfo();
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

  void loadMyInfo() async {
    try {
      JwtToken jwtToken = await jwtTokenFuture;
      UserInfo userInfo = await api.myInfoGet(jwtToken, widget.id);
      setState(() {
        myInfo = userInfo;
      });
    } catch (e) {
      print('Failed to load my Info: $e');
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
          child: myInfo == null
              ? Center(child: CircularProgressIndicator()) // Show a centered loading indicator while data is being fetched
              : Column(
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
                '${myInfo!.username}',
                style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0),
              Text(
                '${myInfo!.email}', // This can be changed to dynamically use a value if required
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
                                '${myInfo!.postNum}',
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
                                '${myInfo!.followingNum}',
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
                                '${myInfo!.followerNum}',
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
                          _authManager.removeToken();
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: ExplanationPage(
                                  authRepository: _authRepository,
                                  authManager: _authManager),
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: Duration(milliseconds: 300),
                            ),
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
