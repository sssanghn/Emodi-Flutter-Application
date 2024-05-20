import 'package:flutter/material.dart';
import 'package:emodi/communitys/hlog.dart';
import 'package:emodi/communitys/hlog_write.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
        title: Text(
          'emodi',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 120,
                ),
                Spacer(),
                IconButton(
                  onPressed: _pickImage,
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
          ),
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
