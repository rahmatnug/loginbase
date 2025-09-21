import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String nama;
  final String nim;
  final String jurusan;

  const DetailScreen({super.key, required this.nama, required this.nim, required this.jurusan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nama)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $nama', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('NIM: $nim', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Jurusan: $jurusan', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}