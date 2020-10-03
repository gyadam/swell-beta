import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:blacksandsforecast/services/forecast_data.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void loadData() async {

    ForecastData blackSandsForecast = ForecastData('Black Sands Beach');
    await blackSandsForecast.getData();
    ForecastData oceanBeachForecast = ForecastData('Ocean Beach');
    await oceanBeachForecast.getData();

    Navigator.pushReplacementNamed(context, '/home', arguments:{
      'blackSandsForecastData': blackSandsForecast,
      'oceanBeachForecastData': oceanBeachForecast
    });
  }

  @override
  void initState(){
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.white,
          size: 50.0,
        )
      )
    );
  }
}
