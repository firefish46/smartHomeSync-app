import 'package:flutter/material.dart';
import 'DoorPage.dart';
import 'light_page.dart';
import 'fan_page.dart';
import 'water_page.dart';

void main() => runApp(const SmartHomeApp());

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Sync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const HomeDashboard(),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  Widget buildBlock(BuildContext context, String title, IconData icon, Widget page) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: Colors.deepOrangeAccent),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Home Sync")),
      body: Column(
        children: [
          Row(
            children: [
              buildBlock(context, "Doors", Icons.door_front_door, const DoorPage()),
              buildBlock(context, "Lights", Icons.lightbulb, const LightPage()),
            ],
          ),
          Row(
            children: [
              buildBlock(context, "Fan/AC", Icons.ac_unit, const FanPage()),
              buildBlock(context, "Water", Icons.water_drop, const WaterPage()),
            ],
          ),
        ],
      ),
    );
  }
}
