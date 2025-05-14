import 'package:flutter/material.dart';

class DoorPage extends StatefulWidget {
  const DoorPage({super.key});

  @override
  State<DoorPage> createState() => _DoorPageState();
}

class _DoorPageState extends State<DoorPage> {
  bool isLocked = true;
  double _sliderPosition = 0.0; // Ranges from 0.0 (left) to 1.0 (right)
  bool _isDragging = false;

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _isDragging = true;
      // Calculate new position based on drag
      final maxWidth = constraints.maxWidth - 60; // Account for knob width and padding
      final newPosition = (_sliderPosition * maxWidth + details.delta.dx) / maxWidth;
      _sliderPosition = newPosition.clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd() {
    setState(() {
      _isDragging = false;
      // Snap to nearest state
      if (_sliderPosition > 0.5 && isLocked) {
        isLocked = false;
        _sliderPosition = 1.0;
      } else if (_sliderPosition <= 0.5 && !isLocked) {
        isLocked = true;
        _sliderPosition = 0.0;
      } else {
        _sliderPosition = isLocked ? 0.0 : 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Door Control')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Camera feed placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              alignment: Alignment.center,
              child: const Text("Camera Feed Placeholder", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),

            // Stats
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Door Opened Today"),
                trailing: const Text("5 times"),
              ),
            ),
            const SizedBox(height: 30),

            // Slide Lock Toggle UI
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Slide to Lock/Unlock", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) => _handleDragUpdate(details, constraints),
                      onHorizontalDragEnd: (_) => _handleDragEnd(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isLocked ? Colors.red.shade300 : Colors.green.shade300,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                isLocked ? "Locked" : "Unlocked",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: _isDragging
                                  ? Duration.zero
                                  : const Duration(milliseconds: 300),
                              left: _isDragging
                                  ? _sliderPosition * (constraints.maxWidth - 60)
                                  : (isLocked ? 0 : constraints.maxWidth - 60),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isLocked ? Icons.lock : Icons.lock_open,
                                  color: isLocked ? Colors.red : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}