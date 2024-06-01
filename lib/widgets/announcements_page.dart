import 'package:flutter/material.dart';

class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '공지사항',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        children: [
          AnnouncementItem(
            title: '중요 공지',
            content: '이번 주에는 회의가 있습니다. 시간을 확인해주세요.',
            date: '2024-06-01',
          ),
          AnnouncementItem(
            title: '서비스 업데이트 안내',
            content: '새로운 기능을 추가했습니다. 확인해주세요.',
            date: '2024-05-30',
          ),
          // 추가적인 공지사항 아이템들을 여기에 추가할 수 있습니다.
        ],
      ),
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const AnnouncementItem({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content),
          SizedBox(height: 8),
          Text(
            'Date: $date',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onTap: () {
        // 공지사항을 눌렀을 때의 동작을 추가할 수 있습니다.
      },
    );
  }
}
