import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int FORECAST_LENGTH_DAYS = 5;
const int POINTS_PER_DAY = 8;


class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    child: tabBar,
  );
}


List<String> getDailyLows(List<String> lowTideTimes, List<double> lowTideHeights){
  // get current date
  List<String> lowTideTimesLocal = [];
  List<String> dailyLowTideTimesLocal = [];
  List<double> dailyLowTideHeightsLocal = [];

  for (int i = 0; i < lowTideTimes.length; i++){
    DateTime time = DateTime.parse(lowTideTimes[i]);
    DateTime convertTime = time.add(Duration(hours: -7));
    String formattedConvertedTimes = DateFormat('yyyy-MM-dd h:mm a').format(convertTime).toString();
    lowTideTimesLocal.add(formattedConvertedTimes);
  }

  String currentDate = DateFormat('yyyy-MM-dd').format(new DateTime.now()).toString();
  String prevDate = currentDate;
  double lowestTideHeight = 9999.9;
  String lowestTideTime = '';
  for (int i = 0; i < lowTideTimesLocal.length; i++){
    if(lowTideTimesLocal[i].substring(0,10) == prevDate){
      if(lowTideHeights[i] < lowestTideHeight){
        lowestTideHeight = lowTideHeights[i];
        lowestTideTime = lowTideTimesLocal[i].substring(11);
      }
      prevDate = lowTideTimesLocal[i].substring(0,10);
    }
    else{
      dailyLowTideTimesLocal.add(lowestTideTime);
      dailyLowTideHeightsLocal.add(lowestTideHeight);
      lowestTideTime = lowTideTimesLocal[i].substring(11);
      lowestTideHeight = lowTideHeights[i];
      prevDate = lowTideTimesLocal[i].substring(0,10);
    }
  }
  dailyLowTideTimesLocal.add(lowestTideTime);
  dailyLowTideHeightsLocal.add(lowestTideHeight);

  return dailyLowTideTimesLocal;
}


List<int> getDailyWeather(List<int> weatherForecast){

  List<int> dailyWeatherAvg = List<int>();

  List<int> cloudy = [2, 7, 11, 19, 20, 35];
  List<int> rainy = [3, 4, 5, 6, 8, 9, 12, 13, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 26, 27, 28, 29, 33, 34, 36, 37, 38];
  List<int> foggy = [30, 31, 32];

  for (int i=0; i < FORECAST_LENGTH_DAYS; i++) {
    int dailyWeatherID = 0;
    var map = Map();
    List<int> threeHourForecasts = weatherForecast.sublist(i*POINTS_PER_DAY, i*POINTS_PER_DAY+POINTS_PER_DAY);

    // group weather statuses into broader categories
    for(int j = 0; j < threeHourForecasts.length; j++){
      if (cloudy.contains(threeHourForecasts[j])){
        threeHourForecasts[j] = 19;
      }
      else if (rainy.contains(threeHourForecasts[j])){
        threeHourForecasts[j] = 23;
      }
      else if (foggy.contains(threeHourForecasts[j])){
        threeHourForecasts[j] = 31;
      }

    }
    threeHourForecasts.forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));

    // look for most frequently occurring weather status
    int mode = 0;
    map.forEach((k, v){
      if (v > mode && k != 10){
        dailyWeatherID = k;
        mode = v;
      }
    });
    dailyWeatherAvg.add(dailyWeatherID);
  }
  return dailyWeatherAvg;
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