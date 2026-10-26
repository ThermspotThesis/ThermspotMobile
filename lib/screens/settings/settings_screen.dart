import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Measurement',
            style: TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.thermostat),
                  title: const Text('Temperature unit'),
                  trailing: const Text('Celsius °C'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.warning_amber),
                  title: const Text('Alarm threshold'),
                  trailing: const Text('85 °C'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.gradient),
                  title: const Text('Heatmap range'),
                  trailing: const Text('22 – 96 °C'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Connection',
            style: TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: SwitchListTile(
              title: const Text('Auto-connect hardware'),
              secondary: const Icon(Icons.wifi),
              value: true,
              onChanged: (value) {
                // Functionality will be implemented later.
              },
            ),
          ),

          const SizedBox(height: 24),

          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('DISCONNECT HARDWARE'),
          ),
        ],
      ),
    );
  }
}