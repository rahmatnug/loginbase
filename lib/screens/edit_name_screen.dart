// lib/screens/edit_name_screen.dart
import 'package:flutter/material.dart';
import '../utils/user_session.dart';
import 'home_screen.dart';

class EditNameScreen extends StatefulWidget {
  final String currentUsername;
  const EditNameScreen({super.key, required this.currentUsername});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final _newNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveNewName() async {
    final newName = _newNameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama baru tidak boleh kosong')),
      );
      return;
    }
    if (newName == widget.currentUsername) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama baru sama dengan nama lama')),
      );
      return;
    }
    if (UserSession.usernameExists(newName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username sudah digunakan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await UserSession.updateUsername(widget.currentUsername, newName);
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Akun tidak ditemukan')),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(username: newName)),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _newNameController.text = widget.currentUsername;
  }

  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Username'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Username saat ini: ${widget.currentUsername}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _newNameController,
              decoration: const InputDecoration(
                labelText: 'Username Baru',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveNewName(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveNewName,
              icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
              label: Text(_isLoading ? 'MENYIMPAN...' : 'SIMPAN PERUBAHAN'),
            ),
          ],
        ),
      ),
    );
  }
}