import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/communitys/emotion_analysis.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:emodi/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('ko', 'KR'), // 로케일을 한국어로 설정
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // 영어
        const Locale('ko', 'KR'), // 한국어
      ],
      home: HlogWritePage(),
    );
  }
}

class HlogWritePage extends StatefulWidget {
  final List<File>? images;

  const HlogWritePage({Key? key, this.images}) : super(key: key);

  @override
  State<HlogWritePage> createState() => _HlogWritePageState();
}

class _HlogWritePageState extends State<HlogWritePage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _titleEditingController = TextEditingController();
  File? _selectedImage;
  DateTime? _selectedDate;

  // 키워드 리스트
  final List<String> keywords = ['#키워드1', '#키워드2', '#키워드3', '#키워드4'];

  @override
  void initState() {
    super.initState();
    if (widget.images != null && widget.images!.isNotEmpty) {
      _selectedImage = widget.images!.first;
    }
    _selectedDate = DateTime.now(); // Initialize with today's date
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KR'), // 달력을 한국어로 설정
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Constants.primaryColor,
            colorScheme: ColorScheme.light(
                primary: Constants.primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
        centerTitle: true,
        actions: [
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
                decoration: _selectedImage != null ? null :
                BoxDecoration(
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleEditingController,
                    decoration: InputDecoration(
                      hintText: '제목을 입력하세요.',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                ),
                Text(
                  "${_selectedDate!.toLocal().toIso8601String().split('T')[0]}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
