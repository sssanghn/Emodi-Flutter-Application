import 'package:emodi/widgets/feature_diary/mydiary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/Auth/auth_manager.dart';

// 모델 클래스 정의
class ListBlockData {
  final Color color;
  final String text;
  final DateTime selectedDay;

  ListBlockData({
    required this.color,
    required this.text,
    required this.selectedDay,
  });
}

class ListBlock extends StatelessWidget {
  final Color color;
  final String text;
  final DateTime? selectedDay;
  final VoidCallback onTap;

  const ListBlock({
    Key? key,
    required this.color,
    required this.text,
    required this.selectedDay,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  selectedDay != null ? selectedDay!.day.toString() : '',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    selectedDay != null
                        ? '${selectedDay!.year}-${selectedDay!.month}-${selectedDay!.day}'
                        : '',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10), // 이미지 컨테이너와 화살표 사이 간격
            Container(
              width: 60, // 이미지 컨테이너 너비
              height: 60, // 이미지 컨테이너 높이
              decoration: BoxDecoration(
                color: Colors.grey, // 임시로 회색 배경 사용
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: Colors.white70,
                ), // 이미지가 들어갈 위치 표시
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  final AuthManager authManager;
  const CalendarPage({Key? key, required this.authManager});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late AuthManager _authManager;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _authManager = widget.authManager;
    }

  // 서버에서 데이터를 받는다고 가정하고 미리 데이터를 정의
  final List<ListBlockData> _listBlockData = [
    ListBlockData(
      color: Constants.primaryColor,
      text: '일기 제목 1',
      selectedDay: DateTime.now(),
    ),
    ListBlockData(
      color: Constants.primaryColor,
      text: '일기 제목 2',
      selectedDay: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
          '내 일기',
          style: Constants.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RootPage(authManager: _authManager)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TableCalendar(
                locale: 'ko_KR',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (_) {},
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primaryColor.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                  disabledBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _listBlockData.length,
                itemBuilder: (context, index) {
                  final blockData = _listBlockData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListBlock(
                      color: blockData.color,
                      text: blockData.text,
                      selectedDay: blockData.selectedDay,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyDiaryPage(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
