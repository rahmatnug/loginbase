import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appName = '—';
  String packageName = '—';
  String version = '—';
  String buildNumber = '—';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        appName = info.appName;
        packageName = info.packageName;
        version = info.version;
        buildNumber = info.buildNumber;
      });
    } catch (_) {
      // Biarkan default nilai '—'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Quiz Edukatif'),
            subtitle: Text(appName),
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number),
            title: const Text('Package Name'),
            subtitle: Text(packageName),
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text('Versi'),
            subtitle: Text('$version+$buildNumber'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Developer'),
            subtitle: Text('Tim Kuis Edukatif'),
          ),
          const ListTile(
            leading: Icon(Icons.mail),
            title: Text('Kontak'),
            subtitle: Text('kuis.edukatif@gmail.com'),
          ),
        ],
      ),
    );
  }
}