import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SwellBarChart extends StatefulWidget {

  List<double> _dailyAvg;
  List<List<double>> _dailyRange;
  SwellBarChart(List<double> dailyAvg, List<List<double>> dailyRange){
    this._dailyAvg = dailyAvg;
    this._dailyRange = dailyRange;
  }

  @override
  State<StatefulWidget> createState() => SwellBarChartState();
}

class SwellBarChartState extends State<SwellBarChart> {
  final Color barBackgroundColor = Colors.lightBlue[100];

  int touchedIndex;

  List<String> getNextFiveWeekdays(int todaysIndex){
    List<String> weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    // shift to match list indexing
    todaysIndex--;
    if (todaysIndex < 3){
      return weekDays.sublist(todaysIndex, todaysIndex+5);
    }
    else{
      return weekDays.sublist(todaysIndex) +  weekDays.sublist(0, 5 - (6 - todaysIndex));
    }

  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.lightBlue[100],
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Swell forecast',
                    style: TextStyle(
                        color: const Color(0xff0f4a3c), fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Black Sands Beach',
                    style: TextStyle(
                        color: const Color(0xff379982), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.blue,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.blue[800] : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 10,
            color: Colors.blue[200],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(5, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget._dailyAvg[0], isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, widget._dailyAvg[1], isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, widget._dailyAvg[2], isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, widget._dailyAvg[3], isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, widget._dailyAvg[4], isTouched: i == touchedIndex);
      default:
        return null;
    }
  });

  BarChartData mainBarData() {

    int today = DateTime.now().weekday;
    List<String> weekDays = getNextFiveWeekdays(today);

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              double swellRangeMin;
              double swellRangeMax;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = weekDays[0];
                  swellRangeMin = widget._dailyRange[group.x.toInt()][0];
                  swellRangeMax = widget._dailyRange[group.x.toInt()][1];
                  break;
                case 1:
                  weekDay = weekDays[1];
                  swellRangeMin = widget._dailyRange[group.x.toInt()][0];
                  swellRangeMax = widget._dailyRange[group.x.toInt()][1];
                  break;
                case 2:
                  weekDay = weekDays[2];
                  swellRangeMin = widget._dailyRange[group.x.toInt()][0];
                  swellRangeMax = widget._dailyRange[group.x.toInt()][1];
                  break;
                case 3:
                  weekDay = weekDays[3];
                  swellRangeMin = widget._dailyRange[group.x.toInt()][0];
                  swellRangeMax = widget._dailyRange[group.x.toInt()][1];
                  break;
                case 4:
                  weekDay = weekDays[4];
                  swellRangeMin = widget._dailyRange[group.x.toInt()][0];
                  swellRangeMax = widget._dailyRange[group.x.toInt()][1];
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + swellRangeMin.toString() + ' - ' + swellRangeMax.toString(), TextStyle(color: Colors.grey[200]));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return weekDays[0].substring(0,3);
              case 1:
                return weekDays[1].substring(0,3);
              case 2:
                return weekDays[2].substring(0,3);
              case 3:
                return weekDays[3].substring(0,3);
              case 4:
                return weekDays[4].substring(0,3);
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: const Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          reservedSize: 4,
          getTitles: (value) {
            if (value == 1) {
              return '1';
            } else if (value == 3) {
              return '3';
            } else if (value == 5) {
              return '5';
            } else if (value == 7) {
              return '7';
            } else if (value == 9) {
              return '9';
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

}