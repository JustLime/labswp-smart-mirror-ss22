import 'package:app/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mirror/mirror_grid.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var _color = const Color.fromARGB(255, 72, 153, 233);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Mirror",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w300),
        ),
        backgroundColor: _color,
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 30),
              child: IconButton(
                icon: const ImageIcon(
                  AssetImage("assets/Windows_Settings_app_icon.png"),
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen()));
                },
              ))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 72, 153, 233),
        ),
        child: const MirrorGrid(),
      ),
    );
  }
}
