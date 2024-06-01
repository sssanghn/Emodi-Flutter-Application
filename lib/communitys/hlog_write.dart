import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/communitys/emotion_analysis.dart';

class HlogWritePage extends StatefulWidget {
  final List<File>? images;

  const HlogWritePage({Key? key, this.images}) : super(key: key);

  @override
  State<HlogWritePage> createState() => _HlogWritePageState();
}

class _HlogWritePageState extends State<HlogWritePage> {
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RootPage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          '일기 작성',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        scrolledUnderElevation: 0,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Add calendar functionality here
                },
                icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmotionAnalysisPage()),
                  );
                },
                icon: Icon(Icons.done, color: Colors.black),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image selection container
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: _selectedImage != null ? null : 150.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                )
                    : Center(
                  child: Icon(Icons.add_a_photo, size: 50.0, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // 키워드 리스트
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
            TextField(
              controller: _textEditingController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '내용을 입력하세요.',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
