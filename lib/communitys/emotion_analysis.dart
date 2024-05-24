import 'package:flutter/material.dart';
import 'package:emodi/root_page.dart';
import 'package:pie_chart/pie_chart.dart';

class EmotionAnalysisPage extends StatefulWidget {
  const EmotionAnalysisPage({Key? key}) : super(key: key);

  @override
  State<EmotionAnalysisPage> createState() => _EmotionAnalysisPageState();
}

class _EmotionAnalysisPageState extends State<EmotionAnalysisPage> {
  Map<String, double> dataMap = {
    '분노': 20,
    '행복': 20,
    '공포': 10,
    '슬픔': 10,
    '혐오': 10,
    '놀람': 10,
    '중립': 30,
  };

  List<bool> isSelected = [true, false];
  bool _showText = false;
  bool _showCorrectionText = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        _showText = true;
      });
      Future.delayed(Duration(milliseconds: 1200), () {
        setState(() {
          _showCorrectionText = true;
        });
      });
    });
  }

  void _showBottomSheet(BuildContext context) {
    Map<String, TextEditingController> controllers = {
      for (var entry in dataMap.entries) entry.key: TextEditingController(text: entry.value.toString())
    };

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '분석 결과가 잘못되었나요?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '감정 비율을 수정해주세요.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                ...controllers.keys.map((emotion) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controllers[emotion],
                      decoration: InputDecoration(
                        labelText: emotion,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dataMap = {
                        for (var entry in controllers.entries)
                          entry.key: double.tryParse(entry.value.text) ?? 0
                      };
                    });
                    Navigator.pop(context);
                  },
                  child: Text('저장하기'),
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          '감정 분석',
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
                MaterialPageRoute(builder: (context) => RootPage()),
              );
            },
            icon: Icon(Icons.done, color: Colors.black),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 1000),
                chartLegendSpacing: 42,
                chartRadius: MediaQuery.of(context).size.width / 2.4,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValues: true,
                  chartValueBackgroundColor: Colors.transparent,
                  showChartValuesInPercentage: true,
                  decimalPlaces: 1,
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1000),
              child: Column(
                children: [
                  Text(
                    '감정 분석 결과,',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '"--" 감정으로 분석됩니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            AnimatedOpacity(
              opacity: _showCorrectionText ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1000),
              child: Column(
                children: [
                  Text(
                    '분석 결과가 잘못되었나요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '그렇다면 아래 버튼을 눌러주세요.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    child: Text('수정하기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForEmotion(String emotion) {
    switch (emotion) {
      case '분노':
        return Colors.red;
      case '행복':
        return Colors.blue;
      case '놀람':
        return Colors.purple;
      case '혐오':
        return Colors.orange;
      case '슬픔':
        return Colors.yellow;
      case '공포':
        return Colors.brown;
      case '중립':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}