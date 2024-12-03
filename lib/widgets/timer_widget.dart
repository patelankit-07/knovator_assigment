import 'dart:async';
import 'package:flutter/material.dart';

class TimerIcon extends StatefulWidget {
  final int duration;
  final Function() onComplete;

  const TimerIcon(
      {super.key, required this.duration, required this.onComplete});

  @override
  _TimerIconState createState() => _TimerIconState();
}

class _TimerIconState extends State<TimerIcon> {
  late int remainingTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    remainingTime = widget.duration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        widget.onComplete();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
  }

  void resumeTimer() {
    if (remainingTime > 0 && timer == null) {
      startTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$remainingTime s',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}
