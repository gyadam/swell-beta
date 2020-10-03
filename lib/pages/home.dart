import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blacksandsforecast/services/combined_barchart.dart';
import 'package:intl/intl.dart';
import 'package:blacksandsforecast/services/forecast_data.dart';
import 'package:blacksandsforecast/services/helpers.dart';
import 'package:blacksandsforecast/services/forecast_content.dart';

class Home extends StatelessWidget {

  Map data = {};

  @override
  Widget build(BuildContext context) {

    // get data from loading page
    data = ModalRoute.of(context).settings.arguments;
    ForecastData blackSandsForecastData = data['blackSandsForecastData'];
    ForecastData oceanBeachForecastData = data['oceanBeachForecastData'];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[900],
              title: Text("Rock climbing conditions",
                  style: TextStyle(
//                    letterSpacing: 1.0,
                    color: Colors.white,
                    fontSize: 20
                    //fontWeight: FontWeight.bold,
                  )
              ),
              centerTitle: true,
              elevation: 0.0,
              bottom: ColoredTabBar(
                  Colors.white,
                TabBar(
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
//                    letterSpacing: 1.0
                  ),
                  unselectedLabelColor: Colors.grey[500],
                  tabs: [
                    Tab(text: 'Black Sands Beach'),
                    Tab(text: 'Ocean Beach')
                  ],
                ),
              )

            ),
            body: TabBarView(
              children: [
                ForecastContent(blackSandsForecastData),
                ForecastContent(oceanBeachForecastData)
              ]
            )
        ),
      )

    );
  }
}

