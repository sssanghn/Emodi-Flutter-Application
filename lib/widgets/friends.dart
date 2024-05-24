import 'package:flutter/material.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/constants.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  bool isToggleSelected = true;

  List<String> friends = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
  ];

  List<String> images = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnnObTCNg1QJoEd9Krwl3kSUnPYTZrxb5Ig&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRisv-yQgXGrto6OxQxX62JyvyQGvRsQQ760g&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQifBWUhSiSfL0t8M3XCOe8aIyS6de2xWrt5A&usqp=CAU',
  ];

  List<String> filteredFriends = [];
  List<String> addedFriends = [];

  Map<String, bool> followState = {};

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;
    for (var friend in friends) {
      followState[friend] = true;
    }
  }

  void filterFriends(String query) {
    setState(() {
      if (isToggleSelected) {
        filteredFriends = friends.where((friend) => friend.toLowerCase().contains(query.toLowerCase())).toList();
      } else {
        filteredFriends = addedFriends.where((friend) => friend.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void toggleFriend(String friendName) {
    setState(() {
      followState[friendName] = !(followState[friendName] ?? false);
      if (!followState[friendName]!) {
        addedFriends.add(friendName);
      } else {
        addedFriends.remove(friendName);
      }
      filterFriends('');  // Update the filteredFriends list based on the current toggle state
    });
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
              MaterialPageRoute(builder: (context) => RootPage()),
            );
          },
        ),
        title: Text(
          '친구 목록',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
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
                        filterFriends('');  // Update the filteredFriends list based on the toggle state
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          ' 검색 ',
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
                        filterFriends('');  // Update the filteredFriends list based on the toggle state
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
                  String friendName = filteredFriends[index];
                  int originalIndex = friends.indexOf(friendName);
                  return buildFriendListItem(context, friendName, images[originalIndex]);
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
          onChanged: filterFriends,
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

  Widget buildFriendListItem(BuildContext context, String friendName, String imageUrl) {
    bool isFollowing = followState[friendName] ?? false;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(friendName),
      trailing: SizedBox(
        height: 40,
        child: TextButton(
          onPressed: () {
            toggleFriend(friendName);
          },
          child: Container(
            width: 65,
            decoration: BoxDecoration(
              color: isFollowing ? Colors.grey.withOpacity(0.2) : Constants.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                isFollowing ? '친구 추가' : '팔로잉',
                style: TextStyle(
                  color: isFollowing ? Constants.primaryColor : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}