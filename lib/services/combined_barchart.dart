import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const int FORECAST_LENGTH_DAYS = 5;
const int POINTS_PER_DAY = 8;
const double TIDE_OFFSET = 5.0;


class CombinedBarChart extends StatefulWidget {

  List<double> tideValues;
  List<double> swellValues;

  CombinedBarChart(List<double> tideValues, List<double> swellValues){
    this.tideValues = tideValues;
    this.swellValues = swellValues;
  }

  @override
  State<StatefulWidget> createState() => CombinedBarChartState();
}

class CombinedBarChartState extends State<CombinedBarChart> {
  final Color dark = Colors.blue[700];
  final Color light = Colors.blue[200];

  List<BarChartGroupData> data = [];

  List<BarChartRodData> generateBarChartRods(int n) => List.generate(POINTS_PER_DAY, (i) {
    // add offset to make tide positive
    double tide = widget.tideValues[n * POINTS_PER_DAY + i] + TIDE_OFFSET;
    double swell = widget.swellValues[n * POINTS_PER_DAY + i];
    return BarChartRodData(
        y: tide + swell,
        width: 5,
        rodStackItem: [
          BarChartRodStackItem(0, tide, dark),
          BarChartRodStackItem(tide, tide + swell, light)
        ],
      borderRadius: const BorderRadius.all(Radius.zero)
    );
  });

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < FORECAST_LENGTH_DAYS; i++){
      data.add(
        BarChartGroupData(
          x: i,
          barsSpace: 2,
          barRods:
            generateBarChartRods(i)
        )
      );
    }
  }

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
    if (todaysIndex < weekDays.length - FORECAST_LENGTH_DAYS + 1){
      return weekDays.sublist(todaysIndex, todaysIndex + FORECAST_LENGTH_DAYS);
    }
    else{
      return weekDays.sublist(todaysIndex) +  weekDays.sublist(0, FORECAST_LENGTH_DAYS - (FORECAST_LENGTH_DAYS + 1 - todaysIndex));
    }
  }

  @override
  Widget build(BuildContext context) {

    int today = DateTime.now().weekday;
    List<String> weekDays = getNextFiveWeekdays(today);

    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 10.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                  margin: 10,
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
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  getTitles: (double value) {
                    if (value % 2 == 1){
                      return (value - 5).toString();
                    }
                    else{
                      return '';
                    }
                  },
                  interval: 1,
                  margin: 6,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value == 5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: const Color(0xffe7e8ec),
                  strokeWidth: 2.5,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 5,
              barGroups: data,
            ),
          ),
        ),
      ),
    );
  }
}