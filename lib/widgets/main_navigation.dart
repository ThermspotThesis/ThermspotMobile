
import 'package:flutter/material.dart';
import '../../widgets/main_navigation.dart';

import '../screens/monitor/monitor_screen.dart';
import '../screens/ai/ai_screen.dart';
import '../screens/settings/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;
  //shared threshold, stored in parent widget
  double alarmThreshold = 85.0;

  //update state to newValue, so engineers can use the slider for change
  void updateAlarmThreshold(double newValue) {
    setState(() {
      alarmThreshold = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MonitorScreen(alarmThreshold: alarmThreshold,), //
      const HeatmapPlaceholder(),
      const AiScreen(),
      SettingsScreen(alarmThreshold: alarmThreshold,
        onThresholdChanged: updateAlarmThreshold,), //
    ];

    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.monitor_heart_outlined),
            label: 'Monitor',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_on),
            label: 'Heatmap',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HeatmapPlaceholder extends StatelessWidget {
  const HeatmapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thermal analysis')),
      body: const Center(
        child: Text('Heatmap coming soon'),
      ),
    );
  }
}

