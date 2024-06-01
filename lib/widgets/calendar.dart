import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/constants.dart';

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
        height: 178, // 높이를 줄임
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10), // 추가된 부분: 왼쪽 여백 조정
            Container(
              width: 178, // 노란색 박스의 크기를 조정
              height: 178, // 노란색 박스의 크기를 조정
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
                    fontSize: 20, // 텍스트 크기를 더 크게 조정
                  ),
                ),
              ),
            ),
            SizedBox(width: 20), // 텍스트와 노란색 박스 사이에 간격을 추가
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

  final List<Color> _blockColors = [
    Color(0xFF64B5F6),
    Color(0xFF42A5F5),
    Color(0xFF2196F3),
  ];

  void _showScrollableDialog(BuildContext context, String blockText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    blockText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '여기에 더 많은 내용을 추가할 수 있습니다. 스크롤이 가능합니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  // 더 많은 내용 추가
                  for (int i = 0; i < 20; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '스크롤 가능한 내용 $i',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).size.height * 0.8, // 높이를 더 크게 조정
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListBlock(
                  color: _blockColors[0],
                  text: 'List Block 1',
                  selectedDay: _selectedDay,
                  onTap: () => _showScrollableDialog(context, 'List Block 1'),
                ),
                SizedBox(height: 20),
                ListBlock(
                  color: _blockColors[1],
                  text: 'List Block 2',
                  selectedDay: _selectedDay,
                  onTap: () => _showScrollableDialog(context, 'List Block 2'),
                ),
                SizedBox(height: 20),
                ListBlock(
                  color: _blockColors[2],
                  text: 'List Block 3',
                  selectedDay: _selectedDay,
                  onTap: () => _showScrollableDialog(context, 'List Block 3'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      body: Column(
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
              _showBottomSheet(context);
            },
            onFormatChanged: (_) {
              // Do nothing
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}
