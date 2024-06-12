import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/communitys/emotion_analysis.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/communitys/feed_model.dart';
import 'package:emodi/communitys/feed_remote_api.dart';
import 'package:emodi/Auth/jwt_token_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:emodi/widgets/vision_remote_api.dart'; // Vision API 클래스를 포함하는 파일

class HlogWritePage extends StatefulWidget {
  final AuthManager authManager;
  final List<File>? images;
  final int id;

  const HlogWritePage({
    Key? key,
    required this.id,
    required this.authManager,
    this.images,
  }) : super(key: key);

  @override
  State<HlogWritePage> createState() => _HlogWritePageState();
}

class _HlogWritePageState extends State<HlogWritePage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _titleEditingController = TextEditingController();
  List<File> _selectedImages = [];
  int _currentImageIndex = 0;
  DateTime? _selectedDate;
  late AuthManager _authManager;
  late Future<JwtToken> jwtTokenFuture;
  late FeedRemoteApi api;
  bool _isLoading = false;

  List<String> keywords = [];
  VisionApi? _visionApi;
  Map<String, double>? analysisResult;

  @override
  void initState() {
    super.initState();
    _authManager = widget.authManager;
    jwtTokenFuture = _authManager.loadAccessToken();
    api = FeedRemoteApi();
    if (widget.images != null && widget.images!.isNotEmpty) {
      _selectedImages = widget.images!;
    }
    _selectedDate = DateTime.now();
    _initVisionApi();
  }

  Future<void> _initVisionApi() async {
    _visionApi = VisionApi('/Users/isangheon/StudioProjects/Emodi/ios/Runner/iron-entropy-425406-m3-a93187a3e105.json');
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages = images.map((image) => File(image.path)).toList();
        _currentImageIndex = 0; // Reset the index when new images are selected
        keywords.clear(); // Clear keywords when new images are selected
      });
      await _analyzeImage(_selectedImages.first);
    }
  }

  // 이미지 감정 분석 Post
  Future<void> _analyzeImage(File image) async {
    setState(() {
      _isLoading = true;
    });

    final imageBytes = await image.readAsBytes();
    final imageBase64 = base64Encode(imageBytes);

    try {
      final result = await _visionApi!.analyzeImage(imageBase64);
      final faceAnnotations = result['responses'][0]['faceAnnotations'];
      final labelAnnotations = result['responses'][0]['labelAnnotations'];

      if (faceAnnotations != null && faceAnnotations.isNotEmpty) {
        final emotions = faceAnnotations[0];
        final highestEmotion = _visionApi!.getHighestEmotion(emotions);
        setState(() {
          keywords.add('#$highestEmotion');
        });
      }

      if (labelAnnotations != null && labelAnnotations.isNotEmpty) {
        for (var label in labelAnnotations) {
          setState(() {
            keywords.add('#${label['description']}');
          });
        }
      }
    } catch (e) {
      print('Failed to analyze image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // AI 감정 분석 모델 Post
  Future<Map<String, double>> analyzeText(String content) async {
    final uri = Uri.parse('http://35.216.28.75/predict');
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'text': content,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final Map<String, double> analysisResult = jsonResponse.map((key, value) => MapEntry(key, value.toDouble()));
      return analysisResult;
    } else {
      throw Exception('Failed to analyze text');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KR'),
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

  Future<void> FeedsPost(JwtToken jwtToken) async {
    setState(() {
      _isLoading = true;
    });

    var uri = Uri.https('emo-di.com', 'api/posts');

    String base64Image = '';
    if (_selectedImages.isNotEmpty) {
      Uint8List imageBytes = await imageToBytes(_selectedImages.first.path);
      base64Image = base64Encode(imageBytes);
    }

    final newPost = NewPost(
      title: _titleEditingController.text,
      content: _textEditingController.text,
      keyword: keywords,
      imageBytes: base64Image,
    );

    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
      body: jsonEncode(newPost.toJson()),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      print('Post submitted successfully');
      final analysisResult = await analyzeText(_textEditingController.text);
      final highestEmotion = analysisResult.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmotionAnalysisPage(highestEmotion: highestEmotion, analysisResult: analysisResult!, id: widget.id, authManager: _authManager)),
      );
    } else {
      print('Failed to submit post: ${response.statusCode} ${response.body}');
      throw Exception('Failed to submit post');
    }
  }

  Future<Uint8List> imageToBytes(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RootPage(id: widget.id, authManager: _authManager)),
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
          _isLoading
              ? CircularProgressIndicator(
            color: Constants.primaryColor,
          )
              : IconButton(
            onPressed: () async {
              try {
                final jwtToken = await jwtTokenFuture;
                await FeedsPost(jwtToken);
              } catch (e) {
                print('error: $e');
              }
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
            GestureDetector(
              onTap: _pickImages,
              child: _selectedImages.isEmpty
                  ? Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(Icons.add_a_photo, size: 50.0, color: Colors.grey),
                ),
              )
                  : Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0, // Adjusted height
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                    ),
                    items: _selectedImages.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  if (_selectedImages.length > 1)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _selectedImages.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Constants.primaryColor
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
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
                  "${_selectedDate != null ? _selectedDate!.toLocal().toIso8601String().split('T')[0] : '날짜 선택'}",
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
