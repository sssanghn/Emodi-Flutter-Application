import 'package:flutter/material.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/widgets/feature_friends/popup_page.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/widgets/feature_friends/friends_model.dart';
import 'package:emodi/widgets/feature_friends/friends_remote_api.dart';
import 'package:emodi/Auth/jwt_token_model.dart';

class FriendPage extends StatefulWidget {
  final AuthManager authManager;
  final int id;
  const FriendPage({Key? key, required this.id, required this.authManager}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late AuthManager _authManager;
  late FriendsRemoteApi api;
  bool isToggleSelected = true;
  late Future<JwtToken> jwtTokenFuture;

  List<UserSearch> allFriends = []; // 서버에서 불러온 모든 친구 리스트
  List<UserSearch> filteredFriends = []; // 검색 또는 필터링된 친구 리스트
  List<UserSearch> myFriends = []; // 내 친구 리스트

  @override
  void initState() {
    super.initState();
    _authManager = widget.authManager;
    jwtTokenFuture = _authManager.loadAccessToken();
    api = FriendsRemoteApi();
    loadMyFriends(); // 처음 시작할 때 내 친구를 불러옴
  }

  void filterFriends(String query) async {
    if (query.length < 3) {
      setState(() {
        filteredFriends = [];
      });
      return;
    }
    try {
      JwtToken jwtToken = await jwtTokenFuture;
      List<UserSearch> searchedFriends = await api.friendSearchGet(jwtToken, query);
      setState(() {
        filteredFriends = searchedFriends;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void toggleFriend(UserSearch friend) async {
    try {
      JwtToken jwtToken = await jwtTokenFuture;
      if (friend.friend) {
        await api.followingDelete(jwtToken, widget.id, friend.id);
      } else {
        await api.followingPost(jwtToken, widget.id, friend.id);
      }
      setState(() {
        friend.friend = !friend.friend;
        if (friend.friend) {
          myFriends.add(friend); // 친구 추가 시 myFriends 리스트에 추가
        } else {
          myFriends.removeWhere((f) => f.id == friend.id); // 친구 삭제 시 myFriends 리스트에서 제거
        }
        if (!isToggleSelected) {
          filteredFriends = myFriends;
        }
      });
    } catch (e) {
      print('Failed to follow/unfollow user: $e');
    }
  }

  void searchMyFriends(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredFriends = myFriends;
      });
    } else {
      setState(() {
        filteredFriends = myFriends.where((friend) {
          return friend.loginId.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RootPage(id: widget.id, authManager: _authManager)),
            );
          },
        ),
        title: Text(
          '친구 목록',
          style: Constants.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isToggleSelected = true;
                        filteredFriends = [];
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          '검색',
                          style: TextStyle(
                            color: isToggleSelected ? Colors.black : Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          height: 2,
                          color: isToggleSelected ? Colors.black : Colors.grey,
                          margin: EdgeInsets.only(top: 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isToggleSelected = false;
                        filteredFriends = myFriends;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          '내 친구',
                          style: TextStyle(
                            color: isToggleSelected ? Colors.grey : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          height: 2,
                          color: isToggleSelected ? Colors.grey : Colors.black,
                          margin: EdgeInsets.only(top: 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            buildSearchScreen(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  UserSearch friend = filteredFriends[index];
                  return buildFriendListItem(context, friend, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchScreen() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 40,
        child: TextField(
          onChanged: (query) {
            if (isToggleSelected) {
              filterFriends(query);
            } else {
              searchMyFriends(query);
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.2),
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFriendListItem(BuildContext context, UserSearch friend, int index) {
    bool isFriend = friend.friend;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(friend.imageUrl.isEmpty ? 'https://placekitten.com/200/200' : friend.imageUrl),
      ),
      title: Text(friend.loginId),
      trailing: SizedBox(
        height: 40,
        child: TextButton(
          onPressed: () {
            toggleFriend(friend);
          },
          child: Container(
            width: 65,
            decoration: BoxDecoration(
              color: isFriend ? Constants.primaryColor : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                isFriend ? '팔로잉' : '친구 추가',
                style: TextStyle(
                  color: isFriend ? Colors.white : Constants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        // 친구 정보 로드
        jwtTokenFuture.then((jwtToken) {
          api.friendInfoGet(jwtToken, friend.id).then((userInfo) {
            // PopUpPage에 friendInfo 전달
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: Colors.grey.withOpacity(0.7),
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: PopUpPage(
                        friend: userInfo,
                        isPopup: true,
                      ),
                    ),
                  ),
                );
              },
            );
          }).catchError((error) {
            // 에러 처리
            print('Error loading friend info: $error');
          });
        });
      },
    );
  }

  void loadMyFriends() async {
    try {
      JwtToken jwtToken = await jwtTokenFuture;
      List<UserInfo> myFriendsList = await api.myFriendGet(jwtToken, widget.id);
      setState(() {
        myFriends = myFriendsList.map((userInfo) {
          return UserSearch(
            id: userInfo.id,
            loginId: userInfo.loginId,
            username: userInfo.username,
            email: userInfo.email,
            tellNumber: userInfo.tellNumber,
            imageUrl: userInfo.imageUrl,
            friend: true,
          );
        }).toList();
        if (!isToggleSelected) {
          filteredFriends = myFriends;
        }
      });
    } catch (e) {
      print('Failed to load my friends: $e');
    }
  }
}
