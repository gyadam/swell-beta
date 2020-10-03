import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blacksandsforecast/services/combined_barchart.dart';
import 'package:intl/intl.dart';
import 'package:blacksandsforecast/services/forecast_data.dart';
import 'package:blacksandsforecast/services/helpers.dart';

class ForecastContent extends StatelessWidget {

  List<double> tideValues;
  List<double> swellValues;
  List<List<double>> swellRange;
  List<int> weatherIDs;
  List<String> lowTideTimes;

  ForecastContent(ForecastData forecastData){
    tideValues = forecastData.tideValues;
    swellValues = forecastData.swellValues;
    swellRange = forecastData.dailySwellRange;
    weatherIDs = forecastData.dailyWeather;
    lowTideTimes = forecastData.lowTideTimes;
  }

  @override
  Widget build(BuildContext context){

    DateTime now = DateTime.now();
    var fourDaysFromNow = now.add(Duration(days: 4));
    String currentFormattedDate = DateFormat('EEE MMM d').format(now);
    String futureFormattedDate = DateFormat('EEE MMM d').format(fourDaysFromNow);
    int today = DateTime.now().weekday;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "5 Day forecast",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
            SizedBox(height: 4),
            Text(
              currentFormattedDate + " - " + futureFormattedDate,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
                fontSize: 14.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '▇  ', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[700])),
                    TextSpan(text: 'Tide      '),
                    TextSpan(text: '▇  ', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[200])),
                    TextSpan(text: 'Swell'),
                  ],
                ),
              ),
            ),
            CombinedBarChart(tideValues, swellValues),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: SizedBox()
                  ),
                  Expanded(
                      flex: 5,
                      child: Text(
                        'Swell',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                        ),
                      )),
                  Expanded(
                      flex: 8,
                      child: Text(
                        'Low tide',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(''))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1.25),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(0.5),
                },
                border: TableBorder(
                    horizontalInside: new BorderSide(color: Colors.grey[300], width: 1)
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children:
                List<TableRow>.generate(5, (int index){
                  return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Text(
                            getNextFiveWeekdays(today)[index].substring(0,3),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            swellRange[index][0].toString() + ' - ' + swellRange[index][1].toString() + ' ft',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lowTideTimes[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child:
                          Image.network('http://cdnimages.magicseaweed.com/30x30/${weatherIDs[index]}.png'),
                        ),
                      ]
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}