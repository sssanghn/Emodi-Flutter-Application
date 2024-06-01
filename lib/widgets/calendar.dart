import 'package:emodi/widgets/mydiary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/constants.dart';

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
        ),
        padding: const EdgeInsets.all(16.0),
        height: 178,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Container(
              width: 178,
              height: 178,
              decoration: BoxDecoration(
                color: Colors.yellow,
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
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 서버에서 데이터를 받는다고 가정하고 미리 데이터를 정의
  final List<ListBlockData> _listBlockData = [
    ListBlockData(
      color: Constants.primaryColor,
      text: 'List Block 1',
      selectedDay: DateTime.now(),
    ),
    ListBlockData(
      color: Constants.primaryColor,
      text: 'List Block 2',
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
              MaterialPageRoute(builder: (context) => RootPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Column(
            children: [
              TableCalendar(
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
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _listBlockData.length,
                itemBuilder: (context, index) {
                  final blockData = _listBlockData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
