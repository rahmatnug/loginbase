import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  const SettingsScreen({super.key, required this.username});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _deviceInfo = '';
  String _firstInstall = '';
  String _lastLogin = '';
  bool _darkMode = false;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
    _loadSettings();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        setState(() {
          _deviceInfo = '''
Device: ${androidInfo.brand} ${androidInfo.model}
Android Version: ${androidInfo.version.release}
SDK: ${androidInfo.version.sdkInt}
Hardware: ${androidInfo.hardware}
''';
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        setState(() {
          _deviceInfo = '''
Device: ${iosInfo.name} ${iosInfo.model}
System Name: ${iosInfo.systemName}
System Version: ${iosInfo.systemVersion}
''';
        });
      } else {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        setState(() {
          _deviceInfo = '''
Browser: ${webInfo.browserName}
Platform: ${webInfo.platform}
''';
        });
      }
    } catch (e) {
      setState(() {
        _deviceInfo = 'Error getting device info: $e';
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final firstInstallTime = prefs.getInt('first_install_time');
    final lastLogin = prefs.getString('last_login');

    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _firstInstall = firstInstallTime != null
          ? DateFormat('dd MMMM yyyy, HH:mm').format(
              DateTime.fromMillisecondsSinceEpoch(firstInstallTime))
          : 'Not available';
      _lastLogin = lastLogin ?? 'Never logged in';
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() {
      _darkMode = value;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Dark mode enabled' : 'Dark mode disabled'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Device Information', _deviceInfo),
            _buildInfoCard('First Install', _firstInstall),
            _buildInfoCard('Last Login', _lastLogin),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: _darkMode,
                      onChanged: _toggleDarkMode,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings reset successfully'),
                    ),
                  );
                  _loadSettings();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restore),
                  SizedBox(width: 8),
                  Text('Reset All Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
