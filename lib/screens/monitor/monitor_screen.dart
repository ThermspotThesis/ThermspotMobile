
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../services/mock_thermal_service.dart';

class MonitorScreen extends StatefulWidget {
  final double alarmThreshold;

  const MonitorScreen({super.key,
  required this.alarmThreshold});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final MockThermalService _service = MockThermalService();

  StreamSubscription<ThermalMeasurement>? _subscription;

  ThermalMeasurement? _currentMeasurement;

  final List<double> _history = [];

  @override
  void initState() {
    super.initState();

    _subscription = _service.measurements.listen((measurement) {
      if (!mounted) return;

      setState(() {
        _currentMeasurement = measurement;

        _history.add(measurement.maximum);

        // Keep the latest 20 values
        if (_history.length > 20) {
          _history.removeAt(0);
        }
      });
    });

    _service.start();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final measurement = _currentMeasurement;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live monitoring',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: measurement == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Simulated connection status
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 10,
                  ),
                  SizedBox(width: 8),
                  Text('Connected (simulation)'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Temperature cards
          Row(
            children: [
              Expanded(
                child: _temperatureCard(
                  'Average',
                  measurement.average,
                ),
              ),
              Expanded(
                child: _temperatureCard(
                  'Max',
                  measurement.maximum,
                ),
              ),
              Expanded(
                child: _temperatureCard(
                  'Internal',
                  measurement.internal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Graph
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Temperature history',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Simulated data · updates every 2 seconds',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: ThermalGraphPainter(
                        values: List.of(_history),
                        threshold: widget.alarmThreshold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dynamic threshold warning
          if (measurement.maximum > widget.alarmThreshold)
            Card(
              color: const Color(0xFFFFEEEE),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Temperature threshold exceeded',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Max: ${measurement.maximum.toStringAsFixed(1)} °C',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12),
                    Text('Temperature within limit'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _temperatureCard(String title, double value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 18,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${value.toStringAsFixed(1)} °C',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: title == 'Max'
                      ? Colors.orange
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThermalGraphPainter extends CustomPainter {
  final List<double> values;
  final double threshold;

  ThermalGraphPainter({
    required this.values,
    required this.threshold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const minTemp = 20.0;
    const maxTemp = 100.0;

    double getY(double temperature) {
      return size.height -
          ((temperature - minTemp) /
              (maxTemp - minTemp)) *
              size.height;
    }

    final graphPaint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final alarmPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1;

    // Alarm threshold line
    final alarmY = getY(threshold);

    for (double x = 0; x < size.width; x += 12) {
      canvas.drawLine(
        Offset(x, alarmY),
        Offset(min(x + 6, size.width), alarmY),
        alarmPaint,
      );
    }

    // Graph line
    final path = Path();

    for (int i = 0; i < values.length; i++) {
      // Use 20 fixed positions so the graph grows
      // across the screen as measurements arrive.
      final x = i * size.width / 19;
      final y = getY(values[i]);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, graphPaint);
  }

  @override
  bool shouldRepaint(covariant ThermalGraphPainter oldDelegate) {
    return true;
  }
}