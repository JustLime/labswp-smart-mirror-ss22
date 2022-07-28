import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';

/// Shows a live analog clock as a widget.
class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  ClockWidget draggableContainer = const ClockWidget();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: draggableContainer,
      feedback: const ClockWidget(),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnalogClock(
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  color: Colors.transparent,
                  shape: BoxShape.circle),
              width: 50.0,
              height: 50,
              isLive: true,
              hourHandColor: Colors.black,
              minuteHandColor: Colors.black,
              showSecondHand: false,
              showDigitalClock: false,
              datetime: DateTime.now(),
            ),
          ),
        ),
      ),
      childWhenDragging: const ClockWidget(),
    );
  }
}

