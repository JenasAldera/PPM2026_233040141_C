import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello Flutter'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('\u{1F44B}', style: TextStyle(fontSize: 64)), // Emoji Tangan
              const SizedBox(height: 16),
              const Text(
                'Halo, Jenas Aldera!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selamat datang di dunia Flutter.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NRP: 233040166', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Prodi: Informatika', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Universitas Pasundan', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Memberi jarak 24 pixel
              ElevatedButton(
                onPressed: () {
                  // Logika akan dipelajari di praktikum berikutnya
                },
                child: const Text('Tap Saya'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}