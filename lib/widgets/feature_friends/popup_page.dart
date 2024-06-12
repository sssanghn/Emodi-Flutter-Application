import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/widgets/feature_friends/friends_model.dart';

class PopUpPage extends StatelessWidget {
  final UserInfo friend;
  final bool isPopup;

  const PopUpPage({
    Key? key,
    required this.friend,
    this.isPopup = false,
  }) : super(key: key);

  Widget _buildInfoColumn(String label, String value) {
    return Padding(
    padding: EdgeInsets.all(12.0),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Constants.primaryColor,
          ),
        ),
      ],
        ),
    );
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
          padding: EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(friend.imageUrl),
                ),
                SizedBox(height: 7),
                Text(
                  friend.username,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  friend.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Card(
                    surfaceTintColor: Color(0xFFfffbfe),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoColumn("게시물", '${friend.postNum}'),
                          const VerticalDivider(),
                          _buildInfoColumn("팔로잉", '${friend.followingNum}'),
                          const VerticalDivider(),
                          _buildInfoColumn("팔로워", '${friend.followerNum}'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {

                  },
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: friend.friend ? Constants.primaryColor : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        friend.friend ? '팔로잉' : '친구 추가',
                        style: TextStyle(
                          color: friend.friend ? Colors.white : Constants.primaryColor,
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
