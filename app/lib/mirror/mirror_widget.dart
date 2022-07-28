import 'package:flutter/material.dart';

/// Represents a mirror widget which can be dragged into the grid.

class MirrorWidget extends StatefulWidget {
  const MirrorWidget({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  State<MirrorWidget> createState() => _MirrorWidgetState();
}

class _MirrorWidgetState extends State<MirrorWidget> {
  MirrorWidget draggableContainer = const MirrorWidget();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: draggableContainer,
      feedback: const MirrorWidget(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
