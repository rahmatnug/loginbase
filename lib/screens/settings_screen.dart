import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme_provider.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import '../utils/score_session.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  const SettingsScreen({super.key, required this.username});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '—';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${info.version}+${info.buildNumber}';
      });
    } catch (_) {
      setState(() => _appVersion = 'Unknown');
    }
  }

  Future<void> _resetScores() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Skor'),
        content: const Text(
          'Semua riwayat skor akan dihapus, tetapi akun Anda tetap ada. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('RESET', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldReset ?? false) {
      await ScoreSession.clearScores();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua skor berhasil direset')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user'); // sesuaikan jika kunci berbeda
      if (mounted) {
        Navigator.of(context).pop(); // kembali ke layar sebelumnya
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil logout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profil Pengguna
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(widget.username),
              subtitle: const Text('Ketuk untuk ubah profil (nama, avatar, password)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(username: widget.username),
                  ),
                );
                setState(() {}); // refresh tampilan jika perlu
              },
            ),
          ),
          const SizedBox(height: 16),

          // Tema
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Aktif/nonaktifkan mode gelap'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) => themeProvider.toggleTheme(value),
                ),
                ListTile(
                  title: const Text('Ikuti Sistem'),
                  subtitle: const Text('Tema akan mengikuti pengaturan perangkat'),
                  trailing: ElevatedButton(
                    onPressed: () => themeProvider.setSystemMode(),
                    child: const Text('Set'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reset Skor
          ElevatedButton.icon(
            onPressed: _resetScores,
            icon: const Icon(Icons.delete),
            label: const Text('Reset Skor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tentang Aplikasi
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              subtitle: Text('Versi: $_appVersion\nDeveloper: Tim Kuis Edukatif\nKontak: support@kuisedukatif.com'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Logout
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}