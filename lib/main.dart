import 'package:flutter/material.dart';
import 'package:blacksandsforecast/pages/loading.dart';
import 'package:blacksandsforecast/pages/home.dart';


void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
    }
));
