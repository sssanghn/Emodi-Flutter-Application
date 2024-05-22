import 'package:flutter/material.dart';
import 'package:emodi/communitys/hlog.dart';
import 'package:emodi/communitys/hlog_write.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:emodi/constants.dart';

class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({super.key});

  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<File> images =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HlogWritePage(images: images),
        ),
      );
    } else {
      print('이미지가 선택되지 않았습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 50),
            Text(
            'Emo',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Constants.primaryColor,
              fontSize: 25,
            ),
          ),
            Text(
              'Di',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
        ],
        ),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // 알림 버튼을 눌렀을 때 액션
            },
            icon: Icon(
              Icons.notifications_none,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _body(),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) => const HlogPage(
        userUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnnObTCNg1QJoEd9Krwl3kSUnPYTZrxb5Ig&usqp=CAU',
        userName: '_ugsxng99',
        images: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnnnObTCNg1QJoEd9Krwl3kSUnPYTZrxb5Ig&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRisv-yQgXGrto6OxQxX62JyvyQGvRsQQ760g&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQifBWUhSiSfL0t8M3XCOe8aIyS6de2xWrt5A&usqp=CAU',
        ],
        countLikes: 12,
        writeTime: '10:33 AM. 28 Feb',
      ),
    );
  }
}
