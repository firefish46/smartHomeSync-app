import 'package:flutter/material.dart';
import 'dart:math';

class FanPage extends StatefulWidget {
  const FanPage({super.key});

  @override
  State<FanPage> createState() => _FanPageState();
}

class _FanPageState extends State<FanPage> with SingleTickerProviderStateMixin {
  bool isFanOn = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    if (isFanOn) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fan/AC Control')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1, // Ensure a square for circular shape
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade100,
                        Colors.blue.shade300,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Semi-transparent overlay
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      // Fan animation
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: FanBladePainter(rotation: _rotationAnimation.value),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 180, // 20 pixels from the top
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      isFanOn ? "Fan Running" : "Fan Stopped",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.ac_unit),
                title: const Text("Fan/AC Runtime Today"),
                trailing: const Text("3.5 hrs"),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(isFanOn ? "Fan/AC ON" : "Fan/AC OFF"),
              value: isFanOn,
              activeColor: Colors.blue,
              onChanged: (val) {
                setState(() {
                  isFanOn = val;
                  if (isFanOn) {
                    _controller.repeat();
                  } else {
                    _controller.stop();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FanBladePainter extends CustomPainter {
  final double rotation;

  FanBladePainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade600
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final bladeLength = size.width * 0.35; // Scaled to fit circular container
    const bladeWidth = 20.0;
    const numBlades = 4;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < numBlades; i++) {
      final angle = (2 * pi / numBlades) * i;
      final path = Path()
        ..moveTo(0, -bladeWidth / 2)
        ..lineTo(bladeLength, -bladeWidth / 2)
        ..quadraticBezierTo(
            bladeLength + 10, 0, bladeLength, bladeWidth / 2)
        ..lineTo(0, bladeWidth / 2)
        ..close();

      canvas.save();
      canvas.rotate(angle);
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    // Draw center circle
    canvas.drawCircle(
      Offset.zero,
      12,
      Paint()..color = Colors.blue.shade800,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}