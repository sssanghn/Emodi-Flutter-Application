import 'package:flutter/material.dart';
import 'dart:io';
import 'package:emodi/widgets/calendar.dart';

class MyDiaryPage extends StatefulWidget {
  final List<File>? images;

  const MyDiaryPage({Key? key, this.images}) : super(key: key);

  @override
  State<MyDiaryPage> createState() => _MyDiaryPageState();
}

class _MyDiaryPageState extends State<MyDiaryPage> {
  TextEditingController _textEditingController = TextEditingController();
  File? _selectedImage;

  // 키워드 리스트
  final List<String> keywords = ['#키워드1', '#키워드2', '#키워드3', '#키워드4'];

  @override
  void initState() {
    super.initState();
    if (widget.images != null && widget.images!.isNotEmpty) {
      _selectedImage = widget.images!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          '일기 기록',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image selection container
            Container(
              width: double.infinity,
              height: _selectedImage != null ? 150.0 : 0,
              child: _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              )
                  : null
            ),
            if(_selectedImage != null)
            const SizedBox(height: 16.0),
            if(_selectedImage != null)
            Wrap(
              children: keywords.map((keyword) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    keyword,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '제목이다.'
                  )
                ),
                Text(
                  '날짜다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              '내용이다.'
            )
          ],
        ),
      ),
    );
  }
}