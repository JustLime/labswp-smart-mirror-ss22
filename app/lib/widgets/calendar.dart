import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shows a calendar as a widget with the current date.
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  var draggableContainer = const CalendarWidget();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: draggableContainer,
      feedback: const CalendarWidget(),
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
        child: Stack(alignment: Alignment.center, children: [
          Image.asset(
            "assets/icons8-kalender-60.png",
          ),
          Text(DateTime.now().day.toString(),
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  color: Colors.black)),
        ]),
      ),
      childWhenDragging: const CalendarWidget(),
    );
  }
}
