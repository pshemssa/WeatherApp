import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String selectedUnit;

  SettingsScreen({required this.selectedUnit});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String unit;

  @override
  void initState() {
    super.initState();
    unit = widget.selectedUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Temperature Unit",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text("Celsius (°C)"),
              leading: Radio<String>(
                value: "metric",
                groupValue: unit,
                onChanged: (value) {
                  setState(() {
                    unit = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Fahrenheit (°F)"),
              leading: Radio<String>(
                value: "imperial",
                groupValue: unit,
                onChanged: (value) {
                  setState(() {
                    unit = value!;
                  });
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, unit);
                },
                child: Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
