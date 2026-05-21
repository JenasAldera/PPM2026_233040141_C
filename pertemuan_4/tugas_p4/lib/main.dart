import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// DATA MODEL
// ==========================================
class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim; // [TUGAS 3]
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

// ==========================================
// MAIN APPLICATION & ROUTING
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            // [TUGAS 1] Reuse TambahCatatanPage for Edit
            final arg = settings.arguments;
            if (arg is Catatan) {
              return MaterialPageRoute(
                builder: (_) => TambahCatatanPage(catatanLama: arg),
              );
            }
            return MaterialPageRoute(builder: (_) => const TambahCatatanPage());
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// ==========================================
// 1. HOME PAGE (STATEFUL WIDGET)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // [TUGAS 2] Filter Kategori
  String _kategoriTerpilih = 'Semua';
  final List<String> _filterOpsi = ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation pada Pertemuan 3.',
      kategori: 'Kuliah',
      emailPengirim: 'mhs@unpas.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" berhasil ditambahkan')),
      );
    }
  }

  // [TUGAS 1] Fungsi untuk navigasi ke detail dan menangkap perubahan (edit)
  Future<void> _bukaDetailCatatan(Catatan c, int index) async {
    final hasil = await Navigator.pushNamed(context, '/detail', arguments: c);
    
    // Jika hasil adalah Catatan (berarti di-edit), update list
    if (hasil is Catatan) {
      setState(() {
        _catatan[index] = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // [TUGAS 2] Logika Filter
    final listTampil = _kategoriTerpilih == 'Semua'
        ? _catatan
        : _catatan.where((c) => c.kategori == _kategoriTerpilih).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // [TUGAS 2] Dropdown Filter di AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButton<String>(
              value: _kategoriTerpilih,
              underline: const SizedBox(),
              icon: const Icon(Icons.filter_list),
              items: _filterOpsi.map((k) {
                return DropdownMenuItem(value: k, child: Text(k));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _kategoriTerpilih = v!;
                });
              },
            ),
          ),
        ],
      ),
      body: listTampil.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada catatan untuk kategori "$_kategoriTerpilih".',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: listTampil.length,
              itemBuilder: (context, i) {
                final c = listTampil[i];
                final tanggalStr = c.dibuatPada.toString().split(' ')[0];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      c.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${c.kategori} • $tanggalStr'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          // Gunakan index dari list asli untuk menghapus
                          _catatan.remove(c);
                        });
                      },
                    ),
                    onTap: () {
                      // Cari index asli di _catatan agar update tepat sasaran
                      final indexAsli = _catatan.indexOf(c);
                      _bukaDetailCatatan(c, indexAsli);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// 2. TAMBAH/EDIT CATATAN PAGE
// ==========================================
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanLama; // [TUGAS 1] Parameter opsional untuk mode Edit

  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl; // [TUGAS 3]
  late String _kategori;
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // [TUGAS 1] Inisialisasi controller dengan data lama jika mode edit
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanLama?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.emailPengirim ?? '');
    _kategori = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(), // Tetap tanggal lama jika edit
    );

    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.catatanLama != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal harus 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _kategori = v!;
                });
              },
            ),
            const SizedBox(height: 16),
            // [TUGAS 3] Field Email dengan Validasi Regex
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                // Regex standar email (titik di dalam [] tidak perlu escape di Dart)
                final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v.trim())) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Lengkap Catatan',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Isi catatan tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEdit ? Icons.edit : Icons.save),
              label: Text(isEdit ? 'Update Catatan' : 'Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. DETAIL CATATAN PAGE (STATELESS WIDGET)
// ==========================================
class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late Catatan _catatanAktif;

  @override
  void initState() {
    super.initState();
    _catatanAktif = widget.catatan;
  }

  @override
  Widget build(BuildContext context) {
    final waktuStr = _catatanAktif.dibuatPada.toString().split('.')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _catatanAktif),
        ),
        actions: [
          // [TUGAS 1] Tombol Edit di Detail
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final hasil = await Navigator.pushNamed(
                context, 
                '/tambah', 
                arguments: _catatanAktif
              );

              if (hasil is Catatan) {
                setState(() {
                  _catatanAktif = hasil;
                });
              }
            },
          ),
        ],
      ),
      // [TUGAS 1] PopScope untuk mengembalikan data ke Home saat back (tombol sistem)
      body: PopScope(
        canPop: false, // Kita handle pop manual agar bisa kirim result
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.pop(context, _catatanAktif);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _catatanAktif.judul,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text(_catatanAktif.kategori),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    waktuStr,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // [TUGAS 3] Tampilkan Email
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Text(
                    _catatanAktif.emailPengirim,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const Divider(height: 32, thickness: 1.5),
              Text(
                _catatanAktif.isi,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
