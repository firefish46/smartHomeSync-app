import 'package:flutter/material.dart';

class LightPage extends StatefulWidget {
  const LightPage({super.key});

  @override
  State<LightPage> createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  bool isLightOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Light Control')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.yellow.shade700),
              ),
              alignment: Alignment.center,
              child: const Text("Light Feed Placeholder", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.flash_on),
                title: const Text("Times Lights Turned On"),
                trailing: const Text("27 times"),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(isLightOn ? "Lights ON" : "Lights OFF"),
              value: isLightOn,
              activeColor: Colors.amber,
              onChanged: (val) {
                setState(() => isLightOn = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
