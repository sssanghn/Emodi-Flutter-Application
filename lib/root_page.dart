import 'package:flutter/material.dart';
import 'package:emodi/widgets/mypage.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/communitys/feed_home.dart';
import 'package:emodi/widgets/feature_friends/friends.dart';
import 'package:emodi/widgets/feature_diary/calendar.dart';
import 'package:emodi/Auth/auth_manager.dart';

class RootPage extends StatefulWidget {
  final AuthManager authManager;
  final int initialIndex;
  final int id;
  const RootPage({Key? key, required this.id, required this.authManager, this.initialIndex = 0}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;
  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.initialIndex;
    _authManager = widget.authManager;
  }

  // 페이지 리스트
  List<Widget> _widgetOptions() {
    return [
      CommunityHomePage(authManager: _authManager, id: widget.id),
      FriendPage(authManager: _authManager, id: widget.id),
      CalendarPage(authManager: _authManager, id: widget.id),
      MyPage(authManager: _authManager, id: widget.id),
    ];
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: _bottomNavIndex == 0
            ? ColorFiltered(
          colorFilter: ColorFilter.mode(Constants.primaryColor, BlendMode.srcIn),
          child: Image.asset('assets/edit_square.png', width: 30, height: 30),
        )
            : Image.asset('assets/edit_square.png', width: 30, height: 30),
        label: '게시물',
      ),
      BottomNavigationBarItem(
        icon: _bottomNavIndex == 1
            ? ColorFiltered(
          colorFilter: ColorFilter.mode(Constants.primaryColor, BlendMode.srcIn),
          child: Image.asset('assets/patient_list.png', width: 30, height: 30),
        )
            : Image.asset('assets/patient_list.png', width: 30, height: 30),
        label: '친구 목록',
      ),
      BottomNavigationBarItem(
        icon: _bottomNavIndex == 2
            ? ColorFiltered(
          colorFilter: ColorFilter.mode(Constants.primaryColor, BlendMode.srcIn),
          child: Image.asset('assets/diary.png', width: 30, height: 30),
        )
            : Image.asset('assets/diary.png', width: 30, height: 30),
        label: '내 일기',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_outlined,
        size: 30),
        label: '마이페이지',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions()[_bottomNavIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          selectedItemColor: Constants.primaryColor,
          items: _bottomNavigationBarItems(),
            ),
          ),
    );
  }
}
