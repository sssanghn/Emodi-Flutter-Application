import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:emodi/constants.dart';

class HlogWritePage extends StatefulWidget {
  final List<File>? images;

  const HlogWritePage({Key? key, this.images}) : super(key: key);

  @override
  State<HlogWritePage> createState() => _HlogWritePageState();
}

class _HlogWritePageState extends State<HlogWritePage> {
  TextEditingController _textEditingController = TextEditingController();
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '풋살',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        scrolledUnderElevation: 0,
        actions: [
          Row(
            children: [ // 약간의 여백 추가
              TextButton(
                onPressed: null,
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 15,
                  ),
                ),
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
            if (widget.images != null && widget.images!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 250.0,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                          ),
                          items: widget.images!.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Image.file(image),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.images!.asMap().entries.map((entry) {
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
                      ],
                    ),
                  ),
                ],
              ),
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
