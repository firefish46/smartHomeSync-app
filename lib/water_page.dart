import 'package:flutter/material.dart';
import 'dart:math';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> with SingleTickerProviderStateMixin {
  bool isWaterOn = false;
  late AnimationController _controller;
  late Animation<double> _waterLevelAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _waterLevelAnimation = Tween<double>(
      begin: 0.3, // Low water level when OFF
      end: 0.7,   // High water level when ON
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Supply Control')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade700),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: WaterWavePainter(
                      waveProgress: _controller.value,
                      waterLevel: isWaterOn ? 0.7 : 0.3,
                    ),
                    child: Center(
                      child: Text(
                        "${(isWaterOn ? 70 : 30)}% Full",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.water_drop),
                title: const Text("Water Usage Today"),
                trailing: const Text("480L"),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(isWaterOn ? "Water Supply ON" : "Water Supply OFF"),
              value: isWaterOn,
              activeColor: Colors.teal,
              onChanged: (val) {
                setState(() {
                  isWaterOn = val;
                  _controller.forward(from: 0);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WaterWavePainter extends CustomPainter {
  final double waveProgress;
  final double waterLevel;

  WaterWavePainter({required this.waveProgress, required this.waterLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal.shade400
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 10.0; // Amplitude of the wave
    final waveFrequency = 2.0; // Number of waves

    // Calculate the y position based on water level (0.0 to 1.0)
    final baseY = size.height * (1 - waterLevel);

    path.moveTo(0, baseY);

    // Create sine wave
    for (double x = 0; x <= size.width; x++) {
      final waveY = baseY +
          sin((x / size.width * 2 * pi * waveFrequency) +
              (waveProgress * 2 * pi)) *
              waveHeight;
      path.lineTo(x, waveY);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}