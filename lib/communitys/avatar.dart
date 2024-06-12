import 'package:flutter/material.dart';

enum AvatarType {BASIC, USER}

class ImageAvatar extends StatelessWidget {
  final double width;
  final String url;
  final AvatarType type;
  final void Function()? onTap;
  const ImageAvatar(
      {super.key,
      this.width = 30,
      required this.url,
      required this.type,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AvatarType.BASIC => ClipOval(
          child: Image.asset(
            'assets/app_icon.png',
            width: width,
            height: width,
          ), // 기본 아바타 이미지
        ),
      AvatarType.USER => ClipOval(
          child: Image.asset(
            'assets/icon.png',
            width: width,
            height: width,
          ), // 유저 아바타 이미지
        ),
    };
  }
}
