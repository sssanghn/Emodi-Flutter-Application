import 'package:flutter/material.dart';
import 'mypage.dart';

class MyPagePopup extends StatelessWidget {
  final String friendName;
  final String imageUrl;

  const MyPagePopup({Key? key, required this.friendName, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Increase width of popup
        child: MyPage(
          friendName: friendName,
          imageUrl: imageUrl,
          showEditProfileButton: false,
          isPopup: true, // Add this line
        ),
      ),
    );
  }
}
