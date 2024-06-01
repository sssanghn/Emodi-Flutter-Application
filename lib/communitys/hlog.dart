import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:emodi/communitys/avatar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emodi/constants.dart';

class HlogPage extends StatefulWidget {
  final String userUrl;
  final String userName;
  final List<String> images;
  final int countLikes;
  final String writeTime;
  final String diaryTitle;
  final String diaryDay;
  final List<String> likedProfile;
  const HlogPage({
    super.key,
    required this.userUrl,
    required this.userName,
    required this.images,
    required this.countLikes,
    required this.writeTime,
    required this.diaryTitle,
    required this.diaryDay,
    required this.likedProfile,
  });

  @override
  State<HlogPage> createState() => _HlogPageState();
}

class _HlogPageState extends State<HlogPage> {
  int _current = 0;
  bool _isFavorited = false;
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 설정
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                spreadRadius: 5, // 그림자 퍼지는 정도
                blurRadius: 10, // 그림자 흐림 정도
                offset: Offset(0, 3), // 그림자 위치 조정
              ),
            ],
          ),
          child: Column(
            children: [
              _header(),
              _images(screenSize.width),
              _options(),
              _comment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 8.0, top: 8.0, bottom: 8.0),
              child: ImageAvatar( //프로필 사진
                url: widget.userUrl,
                type: AvatarType.BASIC,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName, // 계정 이름
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _images(double screenWidth) {
    return CarouselSlider.builder(
      //이미지 갯수
        itemCount: widget.images.length,
        //이미지 빌더
        itemBuilder: (context, index, realIndex) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
            child: Container(
            width: screenWidth,
            height: screenWidth,
            child: CachedNetworkImage(
              //인덱스에 해당하는 이미지 로드
              imageUrl: widget.images[index],
              fit: BoxFit.cover,
            ),
          ),
            ),
            ),
          );
        },
        // carousel_slider위젯의 여러가지 옵션 정의
        options: CarouselOptions(
          enableInfiniteScroll: false,
          aspectRatio: 1,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() {
              //인덱스 갱신
              _current = index;
            });
          },
        ));
  }

  Widget _options() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorited = !_isFavorited; // Toggle the favorite state
                  });
                },
                child: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? Colors.red : Colors.black,
                  size: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8),
              child: GestureDetector(child: Icon(Icons.mode_comment_outlined)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8, right: 20),
              child:
              GestureDetector(child: Icon(Icons.share_outlined)),
            ),
          ],
        ),
        (widget.images.length == 1)
            ? Container()
            : AnimatedSmoothIndicator(
          activeIndex: _current,
          count: widget.images.length,
          effect: ScrollingDotsEffect(
              dotColor: Colors.black26,
              activeDotColor: Constants.primaryColor,
              activeDotScale: 1,
              spacing: 4.0,
              dotWidth: 6.0,
              dotHeight: 6.0),
        ),
        Row(
          children: [
            //안보이는 아이템1
            Opacity(
              opacity: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: Icon(Icons.bookmark_border)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                '좋아요 ${widget.countLikes}개',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constants.textColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _comment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
              Text(
                '${widget.diaryTitle}',
              ),
              Spacer(),
              Text('${widget.diaryDay}',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            ]
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpandableText(
              '#키워드1 #키워드2 #키워드3 #키워드4',
              expandText: '더보기',
              linkColor: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: Text(
              '${widget.writeTime}',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
