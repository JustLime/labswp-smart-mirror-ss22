import 'package:flutter/material.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';

/// This class is a template for one grid element.
///
/// Each grid element has its own state.
class GridContainer extends StatefulWidget {
  final Widget? Function(Widget? child) callback;
  final Function() onDelete;

  const GridContainer(
      {Key? key, required this.callback, required this.onDelete})
      : super(key: key);

  @override
  State<GridContainer> createState() => _GridContainerState();
}

class _GridContainerState extends State<GridContainer> {
  Color _color = Colors.white.withOpacity(0.1);
  Widget? child;
  bool value = false;
  GroupController controller = GroupController(isMultipleSelection: false);
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width / 10;
    final _height = MediaQuery.of(context).size.height / 10;
    // Area for dragging widgets
    return GestureDetector(
      onDoubleTap: () {
        setState(
          () {
            if (child != null) {
              child = null;
              widget.onDelete();
            }
          },
        );
      },
      child: DragTarget<Widget>(
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: _width,
            height: _height,
            color: _color,
            child: Align(
              child: child,
            ),
          );
        },
        onAccept: (mirrorWidget) {
          if (child == null) {
            setState(
              () {
                child = mirrorWidget;
                _color = Colors.white.withOpacity(0.1);
                debugPrint(child.toString() + " is accepted");
                widget.callback(child);
              },
            );
          }
        },
        onMove: (mirrorWidget) {
          if (child == null) {
            setState(() {
              _color = Colors.white.withOpacity(0.2);
            });
          }
        },
        onLeave: (mirrorWidget) {
          if (child == null) {
            setState(() {
              _color = Colors.white.withOpacity(0.1);
            });
          }
        },
      ),
    );
  }
}
