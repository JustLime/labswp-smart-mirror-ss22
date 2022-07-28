import 'package:flutter/material.dart';

/// SHows a Weather Widget.
class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  var draggableContainer = const WeatherWidget();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: draggableContainer,
      feedback: const WeatherWidget(),
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
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image.asset(
              "assets/01d.png",
              color: Colors.black,
            ),
          )),
      childWhenDragging: const WeatherWidget(),
    );
  }
}
