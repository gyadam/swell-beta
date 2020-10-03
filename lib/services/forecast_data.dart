import 'package:http/http.dart';
import 'dart:convert';
import 'helpers.dart';
import 'dart:math';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

const double METERS_TO_FT = 3.28084;
const int FORECAST_LENGTH_DAYS = 5;
const int POINTS_PER_DAY = 8;


class ForecastData{

  // variables for storing tide data
  Map tideDataAll = {};
  List<double> tideValues = [];
  List<String> lowTideTimes = [];

  // variables for storing swell data
  List swellDataAll = [];
  List<double> swellValues = List<double>();
  List<double> dailySwellAvg = [];
  List<List<double>> dailySwellRange = List<List<double>>();

  // variables for storing other data
  List<int> weatherForecast = List<int>();
  List<int> dailyWeather = List<int>();
  int spotID = 0;
  double latitude = 0.0;
  double longitude = 0.0;

  ForecastData(String spot){
    if (spot == 'Ocean Beach'){
      spotID = 255;
      latitude = 37.777;
      longitude = -122.518;
    }
    else if (spot == 'Black Sands Beach'){
      spotID = 307;
      latitude = 37.824;
      longitude = -122.515;
    }
  }

  Future<void> getData() async{

    // load API keys
    String rapidApiKey = "";
    String mswKey = "";

    loadAsset() async {
      return await rootBundle.loadString('secrets.json');
    }

    try{
      dynamic secrets = await loadAsset();
      Map<String, dynamic> keys = jsonDecode(secrets);
      rapidApiKey = keys["rapidapi_key"];
      mswKey = keys["msw_key"];
    }
    catch (e) {
      print(e);
    }

    // setup request for tide data
    var currentTime = DateTime.now();
    var todayMidnight = DateTime(currentTime.year, currentTime.month, currentTime.day);
    num timestamp = (todayMidnight.millisecondsSinceEpoch ~/ 1000);
    String tideApiUrl = 'https://tides.p.rapidapi.com/tides?interval=180&timestamp=$timestamp&duration=7200&latitude=$latitude&longitude=$longitude';
    Map<String, String> tideApiHeaders = {
      "x-rapidapi-host": "tides.p.rapidapi.com",
      "x-rapidapi-key": rapidApiKey
    };

    // get tide data
    try{
      Response tideDataResponse = await get(tideApiUrl, headers:tideApiHeaders);
      tideDataAll = jsonDecode(tideDataResponse.body);

      for (int i = 0; i < tideDataAll["heights"].length; i++){
        tideValues.add(tideDataAll['heights'][i]['height']*METERS_TO_FT); // convert m to ft
      }

      List<double> lowTideHeightsAll = [];
      List<String> lowTideTimesAll = [];

      for (int i = 0; i < tideDataAll["extremes"].length; i++){
        if (tideDataAll['extremes'][i]['state'] == 'LOW TIDE'){
          lowTideTimesAll.add(tideDataAll['extremes'][i]['datetime']);
          lowTideHeightsAll.add(tideDataAll['extremes'][i]['height']);
        }
      }

      lowTideTimes = getDailyLows(lowTideTimesAll, lowTideHeightsAll);
    }
    catch (e) {
      print(e);
    }

    // setup request for swell data
    String swellApiUrl = 'http://magicseaweed.com/api/$mswKey/forecast/?spot_id=$spotID&fields=localTimestamp,swell.components.primary.height,condition.weather';

    // get swell data
    try{
      Response swellDataResponse = await get(swellApiUrl);
      swellDataAll = jsonDecode(swellDataResponse.body);

      for(int i=0; i < swellDataAll.length; i++){
        dynamic height = swellDataAll[i]['swell']['components']['primary']['height'];
        double y = (height.runtimeType is double) ? height : height.toDouble();
        swellValues.add(y);

        int weatherID = int.parse(swellDataAll[i]['condition']['weather']);
        weatherForecast.add(weatherID);
      }

      for (int i=0; i < FORECAST_LENGTH_DAYS; i++){
        double avg = swellValues.sublist(i*POINTS_PER_DAY, i*POINTS_PER_DAY+POINTS_PER_DAY).reduce((a,b) => (a+b)) / POINTS_PER_DAY;
        dailySwellAvg.add(avg);

        double minimum = swellValues.sublist(i*POINTS_PER_DAY, i*POINTS_PER_DAY+POINTS_PER_DAY).reduce(min);
        double maximum = swellValues.sublist(i*POINTS_PER_DAY, i*POINTS_PER_DAY+POINTS_PER_DAY).reduce(max);
        dailySwellRange.add([minimum, maximum]);
      }

      dailyWeather = getDailyWeather(weatherForecast);

    }
    catch (e) {
      print(e);
    }

  }

}