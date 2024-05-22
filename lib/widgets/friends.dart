import 'package:flutter/material.dart';
import 'package:emodi/root_page.dart';

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

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;
  }

  void filterFriends(String query) {
    setState(() {
      filteredFriends = friends.where((friend) => friend.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

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
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return buildFriendListItem(
                      context, friends[index], images[index]);
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
        height: 40, // 높이를 조절하려면 여기서 조절합니다.
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(friendName),
      trailing: TextButton(
        onPressed: () {
          // Add your logic for following/unfollowing here
        },
        child: Text(
          '팔로잉',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}