import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/timerPage.dart';

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff329ea8),
          accentColor: Color(0xff331691),
          brightness: Brightness.dark),
      title: 'Flutter Timer',
      home: const TimerPage(),
    );
  }
}
