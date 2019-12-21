import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:sudoku/models/sudoku.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int _seconds = 0;
  int _minutes = 0;
  bool _shouldPlay = true;
  Timer _timer;

  String getTime() {
    String time = "";
    if (_minutes != 0) time += _minutes.toString() + "m";
    if (_seconds != 0) time += _seconds.toString() + "s";
    return time;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      _timer = timer;
      if (!_shouldPlay) {
        _seconds = 0;
        _minutes = 0;
        return;
      }
      setState(() {
        _seconds++;
        if (_seconds == 60) {
          _seconds = 0;
          _minutes++;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void startClock() {
  }

  @override
  Widget build(BuildContext context) {
    return Selector<Sudoku, bool>(
        selector: (_, _sudoku) => _sudoku.isSolved,
        builder: (_, isSolved, __) {
          if (isSolved)
            _shouldPlay = false;
          else
            _shouldPlay = true;
          return Text(getTime());
        });
  }
}
