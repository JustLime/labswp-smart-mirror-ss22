import 'package:app/connection/ip_address_page.dart';
import 'package:app/home.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}
/// Creating the settingscreen

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        /// Generate Appbar
        appBar: AppBar(
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            /// Icon top right
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.black87,
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: ImageIcon(
                  AssetImage("assets/logo.png"),
                  color: Colors.black,
                  size: 60,
                ),
              )
            ]),
        /// body of the screen
        body: const Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          /// Backgroundcolor
          child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 145, 217, 218),
              Color.fromARGB(255, 245, 176, 158)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          /// Create column for setting buttons
          child: createColumn(context),
        ),
      )),
    ]);
  }

  Widget createColumn(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Create row 
          /// @ImageIcon as a icon 
          /// @Text for buttontext 
          createPlaceholderRow(
              const ImageIcon(AssetImage("assets/birne.png"),
                  color: Colors.black, size: 45),
              'Dark Mode',
              context),
          createPlaceholderRow(
              const ImageIcon(
                AssetImage("assets/power.png"),
                color: Colors.black,
                size: 45,
              ),
              'Mirror on',
              context),
          createRow(
              const ImageIcon(AssetImage("assets/icons8-online-64.png"),
                  color: Colors.black, size: 45),
              'Connect Mirror',
              context),
          createPlaceholderRow(
              const ImageIcon(AssetImage("assets/icons8-sprache-50.png"),
                  color: Colors.black, size: 45),
              'Change Language',
              context),
          createPlaceholderRow(
              const ImageIcon(
                AssetImage("assets/feedback.png"),
                color: Colors.black,
                size: 45,
              ),
              'Feedback',
              context)
        ],
      ),
    );
  }

  /// Placeholder
  void buttonPressed() {
    debugPrint('Button pressed');
  }

  /// Creates the connect mirror row to connect to a bluetooth device
  Widget createRow(ImageIcon icon, String text, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const IPadressManager()));
            }, /// placeholder
            style: TextButton.styleFrom(primary: Colors.black87),
            child: Text(text),
          ),
        )
      ],
    );
  }

  Widget createPlaceholderRow(
      ImageIcon icon, String text, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextButton(
            onPressed: buttonPressed, /// placeholder
            style: TextButton.styleFrom(primary: Colors.black87),
            child: Text(text),
          ),
        )
      ],
    );
  }
}
