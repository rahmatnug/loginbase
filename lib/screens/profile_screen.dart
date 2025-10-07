import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _avatarController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('profile_name') ?? widget.username;
    _avatarController.text = prefs.getString('profile_avatar_url') ?? '';
    // Demi keamanan, kita tidak menampilkan password tersimpan.
    setState(() {});
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final avatar = _avatarController.text.trim();
    final pwd = _passwordController.text.trim();
    final confirmPwd = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showSnack('Nama tidak boleh kosong');
      return;
    }

    if (pwd.isNotEmpty || confirmPwd.isNotEmpty) {
      if (pwd != confirmPwd) {
        _showSnack('Password dan konfirmasi tidak cocok');
        return;
      }
      if (pwd.length < 6) {
        _showSnack('Password minimal 6 karakter');
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_avatar_url', avatar);
    // Catatan: Untuk produksi, jangan simpan password plaintext.
    // Gunakan hashing/secure storage. Di sini hanya contoh sederhana.
    if (pwd.isNotEmpty) {
      await prefs.setString('profile_password', pwd);
    }

    _showSnack('Profil berhasil disimpan');
    Navigator.pop(context);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar preview
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundImage:
              (_avatarController.text.isNotEmpty) ? NetworkImage(_avatarController.text) : null,
              child: (_avatarController.text.isEmpty)
                  ? const Icon(Icons.person, size: 42)
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // Nama
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              prefixIcon: Icon(Icons.badge),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Avatar URL
          TextField(
            controller: _avatarController,
            decoration: const InputDecoration(
              labelText: 'Avatar URL (opsional)',
              prefixIcon: Icon(Icons.image),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Password
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password baru (opsional)',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Konfirmasi Password
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Konfirmasi password',
              prefixIcon: Icon(Icons.lock_reset),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
            style: ElevatedButton.styleFrom(
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