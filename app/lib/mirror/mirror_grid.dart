import 'dart:convert';

import 'package:app/connection/global_variables.dart';
import 'package:app/mirror/grid_container.dart';
import 'package:app/widgets/clock.dart';
import 'package:app/widgets/calendar.dart';
import 'package:app/widgets/news.dart';
import 'package:app/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';

class MirrorGrid extends StatefulWidget {
  const MirrorGrid({Key? key}) : super(key: key);

  @override
  State<MirrorGrid> createState() => _MirrorGridState();
}

class _MirrorGridState extends State<MirrorGrid> {
  /// Map that contains the mirror widget name and its index value.
  var _grid = <int, String>{};

  /// Json file to send to the websocket.
  String? jsonFile;

  /// Defines the intial size of the grid.
  final _gridColumns = 4;
  final _gridRows = 5;

  var _showWidgetHub = false;

  @override
  Widget build(BuildContext context) {
    const List<Widget> _gridWidgets = [
      CalendarWidget(),
      ClockWidget(),
      WeatherWidget(),
      NewsWidget()
    ];
    var _size = MediaQuery.of(context).size;
    var _gridList = List.generate(
      _gridColumns * _gridRows,
      (index) => GridContainer(
        callback: (child) {
          setState(() {
            _grid[index] = child.toString();
          });
          return null;
        },
        onDelete: () {
          setState(() {
            _grid.remove(index);
          });
        },
      ),
    );

    return GestureDetector(
      onPanEnd: (data) {
        if (data.velocity.pixelsPerSecond.dy > 100) {
          setState(() {
            _showWidgetHub = false;
          });
        } else if (data.velocity.pixelsPerSecond.dy < -100) {
          setState(() {
            _showWidgetHub = true;
          });
        }
      },
      onTap: () {
        setState(() {
          _showWidgetHub = false;
        });
      },
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                /// Represents the mirror grid that is a image of the actual mirror.
                SizedBox(height: _size.height * 0.02),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 8,
                            blurRadius: 9,
                          )
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    width: _size.width * 0.9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GridView.count(
                        crossAxisCount: _gridColumns,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        children: _gridList,
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Widget Hub for inserting available widgets on the grid so it has been shown on the mirror.
          AnimatedPositioned(
            bottom: _showWidgetHub ? -20 : -_size.height * 0.4,
            duration: const Duration(milliseconds: 200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white38,
                width: _size.width,
                height: _size.height * 0.5,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Drag here to expand widget hub",
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: sendJsonToWebsocket,
                          child: const Text("Send grid to mirror")),
                      const SizedBox(
                        height: 50,
                      ),
                      DragTarget(
                        builder: (context, candidateData, rejectedData) => Wrap(
                            spacing: 15,
                            alignment: WrapAlignment.spaceAround,
                            children: _gridWidgets),
                        onLeave: (data) {
                          setState(() {
                            _showWidgetHub = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Stringifies the widgets placed in the grid as json string.
  convertMirrorWidgetsToJson() {
    var jsonMap = <int, String>{};
    var jsonString = '';
    var counter = 1;

    _grid.forEach((key, value) {
      switch (value) {
        case 'CalendarWidget':
          jsonMap[key] = 'calendar';
          break;
        case 'ClockWidget':
          jsonMap[key] = 'clock';
          break;
        case 'WeatherWidget':
          jsonMap[key] = 'weather';
          break;
        case 'NewsWidget':
          jsonMap[key] = 'news';
          break;
      }
    });

    jsonString = '[';
    if (jsonMap.isNotEmpty) {
      jsonMap.forEach((key, value) {
        key++;
        int row;
        int column;
        if (key < 4) {
          row = 1;
          column = key;
        } else {
          row = (key / 4).floor() + 1;
          column = key % 4;
        }

        switch (value) {
          case "calendar":
            var startRow = row + 2;
            var endColumn = column + 4;
            jsonString +=
                '{"tagName": "$value", "gridPos": "$row / $column / $startRow / $endColumn"}';
            break;
          case "clock":
            var startRow = row + 2;
            var endColumn = column + 3;
            jsonString +=
                '{"tagName": "$value", "gridPos": "$row / $column / $startRow / $endColumn", "offset": 0}';
            if (counter < jsonMap.length) {
              jsonString += ',';
            }
            break;
          case "weather":
            var startRow = row + 2;
            var endColumn = column + 3;
            jsonString +=
                '{"tagName": "$value", "gridPos": "$row / $column / $startRow / $endColumn", "city": "Heilbronn"}';
            if (counter < jsonMap.length) {
              jsonString += ',';
            }
            break;
          case "news":
            var startRow = row + 6;
            var endColumn = column + 3;
            jsonString +=
                '{"tagName": "$value", "gridPos": "$row / $column / $startRow / $endColumn", "search": "top-headlines?country=de&category=technology"}';
            if (counter < jsonMap.length) {
              jsonString += ',';
            }
            break;
        }
        counter++;
      });
    }
    jsonString += "]";
    debugPrint(jsonString);
    return jsonString;
  }

  /// Parses the json in the following format:
  ///
  /// tagName (name of widget), gridPos, attribute of tagName
  readJson(jsonString) async {
    var jsonStringHelper = await jsonString;
    Map<String?, dynamic> parsedJson = jsonDecode(jsonStringHelper);
    var gridWidgets = <int, String>{};

    switch (parsedJson["tagName"]) {
      case "calendar":
        gridWidgets[getIndexByGridPosition(parsedJson["gridPos"])] =
            "CalendarWidget";
        break;
      case "clock":
        gridWidgets[getIndexByGridPosition(parsedJson["gridPos"])] =
            "ClockWidget";
        break;
      case "weather":
        gridWidgets[getIndexByGridPosition(parsedJson["gridPos"])] =
            "WeatherWidget";
        break;
      case "news":
        gridWidgets[getIndexByGridPosition(parsedJson["gridPos"])] =
            "NewsWidget";
        break;
    }

    gridWidgets.forEach((key, value) {
      debugPrint("$key: $value");
    });

    setState(() {
      _grid.clear();
      _grid = gridWidgets;
    });
  }

  /// Calculates the row value based on the json grid position value on mirror side.
  int getRowByGridPosition(String gridPos) {
    var _list = gridPos.split(" / ");
    var _row = int.parse(_list[0]);
    return _row;
  }

  /// Calculates the column value based on the json grid position value on mirror side.
  int getColumnByGridPosition(String gridPos) {
    var _list = gridPos.split(" / ");
    var _column = int.parse(_list[1]);
    return _column;
  }

  /// Calculates the index value based on the json grid position value on mirror side.
  int getIndexByGridPosition(String gridPos) {
    var list = gridPos.split(" / ");
    var row = int.parse(list[0]);
    var column = int.parse(list[1]);
    var index = (row - 1) * _gridColumns + column - 1;
    return index;
  }

  /// Trys to send the grid to the webserver.
  void sendJsonToWebsocket() async {
    try {
      final _channel =
          IOWebSocketChannel.connect(Uri.parse("ws://" + ipAddress + ":420"));
      await readJsonFromFile();
      _sendJson(_channel);
      const snackbar = SnackBar(content: Text("Grid successfully sent"));
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } catch (e) {
      debugPrint(e.runtimeType.toString() + " - " + e.toString());
      const snackbar = SnackBar(content: Text("IP Address not set"));
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<String?> readJsonFromFile() async {
    jsonFile = await rootBundle.loadString('path/file.json');
    return jsonFile;
  }

  /// Sends json to the webserver.
  void _sendJson(IOWebSocketChannel _channel) async {
    _channel.sink.add(convertMirrorWidgetsToJson());
  }
}
