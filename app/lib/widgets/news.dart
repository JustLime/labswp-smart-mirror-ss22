import 'package:flutter/material.dart';

/// Shows a news widget.
class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  NewsWidget draggableContainer = const NewsWidget();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
          data: draggableContainer,
          feedback: const NewsWidget(),
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
                child: Image.asset("assets/icons8-news-60.png"),
              )),
          childWhenDragging: const NewsWidget(),
        );
  }
}
