
import 'dart:async';
import 'dart:math';

class ThermalMeasurement {
  final double average;
  final double maximum;
  final double internal;
  final DateTime timestamp;

  ThermalMeasurement({
    required this.average,
    required this.maximum,
    required this.internal,
    required this.timestamp,
  });
}

class MockThermalService {
  final Random _random = Random();
  Timer? _timer;

  final StreamController<ThermalMeasurement> _controller =
  StreamController<ThermalMeasurement>.broadcast();

  Stream<ThermalMeasurement> get measurements =>
      _controller.stream;

  void start() {
    if (_timer != null) return;

    _generateMeasurement();

    _timer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => _generateMeasurement(),
    );
  }

  void _generateMeasurement() {
    if (_controller.isClosed) return;

    //simulated temperatures
    final average = 65 + _random.nextDouble() * 10;
    final maximum = 78 + _random.nextDouble() * 18;
    final internal = 22 + _random.nextDouble() * 3;

    final measurement = ThermalMeasurement(
      average: average,
      maximum: maximum,
      internal: internal,
      timestamp: DateTime.now(),
    );

    _controller.add(measurement);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.close();
  }
}
