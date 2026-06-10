import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ==========================================
// DATA MODEL
// ==========================================
class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim; // [TUGAS 3]
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });

  // === Dart object → row Map ===
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'email_pengirim': emailPengirim,
    'dibuat_pada': dibuatPada.millisecondsSinceEpoch,
  };

  // === Row Map → Dart object ===
  static Catatan fromMap(Map<String, Object?> m) => Catatan(
    id: m['id'] as int?,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
    kategori: m['kategori'] as String,
    emailPengirim: m['email_pengirim'] as String? ?? '',
    dibuatPada: DateTime.fromMillisecondsSinceEpoch(m['dibuat_pada'] as int),
  );

  // Helper untuk Edit — copy dengan beberapa field diganti.
  Catatan copyWith({
    String? judul,
    String? isi,
    String? kategori,
    String? emailPengirim,
  }) =>
      Catatan(
        id: id,
        judul: judul ?? this.judul,
        isi: isi ?? this.isi,
        kategori: kategori ?? this.kategori,
        emailPengirim: emailPengirim ?? this.emailPengirim,
        dibuatPada: dibuatPada,
      );
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

  late Future<List<Catatan>> _futureCatatan;

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futureCatatan = DbHelper.instance.getAll();
    });
  }

  Future<void> _bukaTambahCatatan() async {
    await Navigator.pushNamed(context, '/tambah');
    _muatUlang();
  }

  // [TUGAS 1] Fungsi untuk navigasi ke detail dan menangkap perubahan (edit)
  Future<void> _bukaDetailCatatan(Catatan c) async {
    await Navigator.pushNamed(context, '/detail', arguments: c);
    _muatUlang();
  }

  Future<void> _konfirmasiHapus(Catatan c) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('"${c.judul}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      await DbHelper.instance.delete(c.id!);
      if (!mounted) return;
      _muatUlang();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${c.judul}" berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // [TUGAS 2] Dropdown Filter di AppBar
          Padding(
            padding: const EdgeInsets.only(right: 8),
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: FutureBuilder<List<Catatan>>(
        future: _futureCatatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? [];
          final listTampil = _kategoriTerpilih == 'Semua'
              ? data
              : data.where((c) => c.kategori == _kategoriTerpilih).toList();

          if (listTampil.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    _kategoriTerpilih == 'Semua'
                        ? 'Belum ada catatan.'
                        : 'Belum ada catatan untuk kategori "$_kategoriTerpilih".',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
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
                    onPressed: () => _konfirmasiHapus(c),
                  ),
                  onTap: () => _bukaDetailCatatan(c),
                ),
              );
            },
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
  bool _menyimpan = false;

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

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _menyimpan = true);

    try {
      if (widget.catatanLama != null) {
        // Mode EDIT
        final updated = widget.catatanLama!.copyWith(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
          emailPengirim: _emailCtrl.text.trim(),
        );
        await DbHelper.instance.update(updated);
      } else {
        // Mode TAMBAH
        final catatanBaru = Catatan(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
          emailPengirim: _emailCtrl.text.trim(),
          dibuatPada: DateTime.now(),
        );
        await DbHelper.instance.insert(catatanBaru);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.catatanLama != null ? 'Catatan diperbarui' : 'Catatan ditambahkan',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
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
              onPressed: _menyimpan ? null : _simpan,
              icon: _menyimpan
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Icon(isEdit ? Icons.edit : Icons.save),
              label: Text(
                _menyimpan
                    ? 'Menyimpan...'
                    : (isEdit ? 'Update Catatan' : 'Simpan Catatan'),
              ),
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
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    final waktuStr = catatan.dibuatPada.toString().split('.')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          // [TUGAS 1] Tombol Edit di Detail
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(
                  context,
                  '/tambah',
                  arguments: catatan
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(catatan.kategori),
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
                  catatan.emailPengirim,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1.5),
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
