import 'package:app/connection/global_variables.dart';
import 'package:app/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';

class IPadressManager extends StatelessWidget {
  const IPadressManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Address',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const IPadressManagerFront(),
    );
  }
}

class IPadressManagerFront extends StatefulWidget {
  const IPadressManagerFront({Key? key}) : super(key: key);

  @override
  State<IPadressManagerFront> createState() => _IPadressManagerFrontState();
}

class _IPadressManagerFrontState extends State<IPadressManagerFront> {
  final TextEditingController _ipController = TextEditingController();

  /// Builds Widget to input the IP address
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()));
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black87,
          ),
          centerTitle: true,
          title: const Text("IP Config"),
        ),
        body: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                hintText: "IP Address of raspberry",
                labelText: "IP Address",
              ),
            ),
            TextButton(
              /// Saves the IP address
                onPressed: saveIP,
                child:
                    const Text("submit", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                )),
          ],
        ));
  }
  /// Saves the IP address and generates a snackbar if IP Address is not valid
  void saveIP() {
    if (validator.ip(_ipController.text.trim())) {
      debugPrint(_ipController.text);
      ipAddress = _ipController.text.trim();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("IP Address successfully set to " + ipAddress)));
    } else {
      const snackbar = SnackBar(content: Text("Not a valid IP Address"));
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
