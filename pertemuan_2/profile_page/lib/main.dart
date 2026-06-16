import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page & Widget Gallery',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

// ==========================================
// PROFILE PAGE (LENGKAP DENGAN STATE)
// ==========================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1; // Index profil (0: Home, 1: Profil, 2: Pesan, 3: Setting)

  // Profile State Variables
  String _name = 'Jenas Aldera';
  String _role = 'Game Developer | Mahasiswa Teknik Informatika';
  String _location = 'Bandung, Indonesia';
  String _about = 'Halo! Saya adalah mahasiswa Teknik Informatika yang sangat antusias dengan pengembangan Game.';
  String _education = '🎓 Universitas Pasundan - Semester 6\n📚 Teknik Informatika\n⭐ IPK: 4.0\n🏆 Best Student Award 2077';
  String _contact = '📧 jenasaldera1425@gmail.com\n📱 +62 896-6230-8886\n💻 github.com/jenasaldera\n🔗 linkedin.com/in/jenasaldera';
  List<String> _skills = ['Dart', 'Git', 'UI/UX', 'Unity'];
  String? _profileImagePath;
  String _profileImageUrl = 'https://avatars.githubusercontent.com/u/145580540?v=4';

  // Experience State Variables (Bonus)
  String _expTitle = 'Game Dev Intern - PT AnTech Async (2077)';
  String _expDesc = 'Mengerjakan berbagai proyek game menggunakan Unity.';
  String? _expImagePath;

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Placeholder untuk navigasi antar halaman
    switch (index) {
      case 0:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Home akan segera hadir')),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Pesan akan segera hadir')),
        );
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Setting akan segera hadir')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========== APPBAR ==========
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue.shade100,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur pencarian belum tersedia')),
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Pengaturan'), value: 'settings'),
              const PopupMenuItem(child: Text('Tentang'), value: 'about'),
            ],
            onSelected: (value) {
              if (value == 'settings') {
                _showSettingsDialog(context);
              } else if (value == 'about') {
                _showAboutDialog(context);
              }
            },
          ),
        ],
      ),

      // ========== DRAWER ==========
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: _profileImagePath != null
                        ? (kIsWeb ? NetworkImage(_profileImagePath!) : FileImage(File(_profileImagePath!))) as ImageProvider
                        : NetworkImage(_profileImageUrl) as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    _contact.split('\n').first.replaceAll('📧 ', ''),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kembali ke Beranda')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Saya'),
              tileColor: Colors.blue.shade50,
              onTap: () => Navigator.pop(context),
            ),
            // ========== MENU EDIT PENGALAMAN (Bonus) ==========
            ListTile(
              leading: const Icon(Icons.work_history, color: Colors.blue),
              title: const Text('Edit Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExperiencePage(
                      initialTitle: _expTitle,
                      initialDesc: _expDesc,
                      initialImagePath: _expImagePath,
                    ),
                  ),
                );

                if (result != null && result is Map<String, String?>) {
                  setState(() {
                    _expTitle = result['title'] ?? _expTitle;
                    _expDesc = result['desc'] ?? _expDesc;
                    _expImagePath = result['imagePath'];
                  });
                }
              },
            ),
            // ========== MENU WIDGET GALLERY ==========
            ListTile(
              leading: const Icon(Icons.widgets, color: Colors.orange),
              title: const Text(
                'Widget Gallery',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),

      // ========== BODY ==========
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER PROFIL
            Center(
              child: Column(
                children: [
                  // CircleAvatar dengan NetworkImage (Tugas 1) - FIXED: pakai gambar yang valid
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: _profileImagePath != null
                              ? (kIsWeb ? NetworkImage(_profileImagePath!) : FileImage(File(_profileImagePath!))) as ImageProvider
                              : NetworkImage(_profileImageUrl) as ImageProvider,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _role,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(_location, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // BARIS STATISTIK (Row + Expanded)
            Row(
              children: [
                Expanded(child: _StatBox(label: 'Posts', value: '69', icon: Icons.article)),
                Expanded(child: _StatBox(label: 'Friends', value: '6.7K', icon: Icons.people)),
                Expanded(child: _StatBox(label: 'Likes', value: '4.2M', icon: Icons.favorite)),
              ],
            ),
            const SizedBox(height: 24),

            // SECTION CARDS
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: _about,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: _education,
            ),

            // SKILLS SECTION (Tugas 3 - dengan Wrap dan Chip)
            _SkillsCard(
              skills: _skills,
            ),

            // EXPERIENCE SECTION (Bonus)
            _ExperienceCard(
              title: _expTitle,
              description: _expDesc,
              imagePath: _expImagePath,
            ),

            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: _contact,
            ),

            const _SectionCard(
              icon: Icons.language,
              title: 'Bahasa',
              content: '🇮🇩 Indonesia (Native)\n'
                  '🇬🇧 English (Professional)\n'
                  '🇯🇵 Japanese (Basic)',
            ),

            const SizedBox(height: 80), // Ruang agar FAB tidak nutupi konten
          ],
        ),
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                initialName: _name,
                initialRole: _role,
                initialLocation: _location,
                initialAbout: _about,
                initialEducation: _education,
                initialContact: _contact,
                initialSkills: _skills,
                initialImagePath: _profileImagePath,
                initialImageUrl: _profileImageUrl,
              ),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _name = result['name'] ?? _name;
              _role = result['role'] ?? _role;
              _location = result['location'] ?? _location;
              _about = result['about'] ?? _about;
              _education = result['education'] ?? _education;
              _contact = result['contact'] ?? _contact;
              _skills = result['skills'] ?? _skills;
              _profileImagePath = result['imagePath'];
            });
          }
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),
      ),

      // ========== BOTTOM NAVIGATION BAR (Material 3) ==========
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavigationTap,
        elevation: 4,
        animationDuration: const Duration(milliseconds: 200),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home', selectedIcon: Icon(Icons.home)),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil', selectedIcon: Icon(Icons.person)),
          NavigationDestination(icon: Icon(Icons.message_outlined), label: 'Pesan', selectedIcon: Icon(Icons.message)),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Setting', selectedIcon: Icon(Icons.settings)),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings, color: Colors.blue),
            SizedBox(width: 8),
            Text('Pengaturan'),
          ],
        ),
        content: const Text('Halaman pengaturan akan segera hadir di update berikutnya.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Profile Page & Widget Gallery',
        applicationVersion: '1.0.0',
        applicationIcon: const Icon(Icons.person, size: 40, color: Colors.blue),
        children: const [
          Text('Aplikasi ini dibuat sebagai referensi belajar Flutter.'),
          SizedBox(height: 8),
          Text('© 2026 - Jenas Aldera'),
        ],
      ),
    );
  }
}

// ========== HELPER WIDGET: STATBOX ==========
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== HELPER WIDGET: SECTIONCARD ==========
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
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
                  Text(
                    content,
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== HELPER WIDGET: EXPERIENCE CARD (Bonus) ==========
class _ExperienceCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imagePath;

  const _ExperienceCard({
    required this.title,
    required this.description,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.work, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Pengalaman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                        imagePath!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagePath!),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== HELPER WIDGET: SKILLSCARD (Tugas 3) ==========
class _SkillsCard extends StatelessWidget {
  final List<String> skills;

  const _SkillsCard({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Skills & Tools',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.blue.shade50,
                  avatar: const Icon(Icons.code, size: 16, color: Colors.blue),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET GALLERY (LANGKAH 5)
// ==========================================

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      GalleryCategory('Display', Icons.image, Colors.blue, 'Widget untuk menampilkan konten'),
      GalleryCategory('Input', Icons.edit, Colors.green, 'Widget untuk menerima input pengguna'),
      GalleryCategory('Button', Icons.smart_button, Colors.orange, 'Widget tombol interaktif'),
      GalleryCategory('Feedback', Icons.notifications, Colors.purple, 'Widget untuk feedback pengguna'),
      GalleryCategory('Layout', Icons.dashboard, Colors.teal, 'Widget untuk mengatur tata letak'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final category = categories[i];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: category.color.withOpacity(0.2),
                child: Icon(category.icon, color: category.color, size: 28),
              ),
              title: Text(
                category.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(category.description, style: TextStyle(color: Colors.grey.shade600)),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_forward_ios, color: category.color, size: 16),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(name: category.name),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GalleryCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  GalleryCategory(this.name, this.icon, this.color, this.description);
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (name) {
      case 'Display':
        body = const _DisplayDemo();
        break;
      case 'Input':
        body = const _InputDemo();
        break;
      case 'Button':
        body = const _ButtonDemo();
        break;
      case 'Feedback':
        body = const _FeedbackDemo();
        break;
      case 'Layout':
        body = const _LayoutDemo();
        break;
      default:
        body = const Center(child: Text('Kategori tidak ditemukan'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

// ========== DEMO DISPLAY ==========
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card
        const Text('📦 Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const ListTile(
            leading: Icon(Icons.album, color: Colors.blue),
            title: Text('Album Indie Hits'),
            subtitle: Text('2026 - 12 lagu'),
            trailing: Icon(Icons.play_arrow),
          ),
        ),
        const SizedBox(height: 20),

        // Chip - FIXED: Icons.git_branch diganti dengan Icons.code
        const Text('🏷️ Chip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter'), avatar: CircleAvatar(child: Icon(Icons.mobile_friendly))),
            Chip(label: Text('Dart'), avatar: CircleAvatar(child: Icon(Icons.code))),
            Chip(label: Text('Firebase'), avatar: CircleAvatar(child: Icon(Icons.fireplace))),
            Chip(label: Text('Git'), avatar: CircleAvatar(child: Icon(Icons.code))), // FIXED
          ],
        ),
        const SizedBox(height: 20),

        // ListTile
        const Text('📋 ListTile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Card(
          child: const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('John Doe'),
            subtitle: Text('Online'),
            trailing: Icon(Icons.chat_bubble_outline),
          ),
        ),
        const SizedBox(height: 20),

        // CircleAvatar
        const Text('🟢 CircleAvatar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        const Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=JD')),
            SizedBox(width: 16),
            CircleAvatar(radius: 30, backgroundColor: Colors.green, child: Text('A')),
            SizedBox(width: 16),
            CircleAvatar(radius: 30, backgroundColor: Colors.orange, child: Icon(Icons.person)),
          ],
        ),
        const SizedBox(height: 20),

        // Divider
        const Divider(thickness: 1),
        const Text('Divider sebagai pemisah', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// ========== DEMO INPUT ==========
class _InputDemo extends StatefulWidget {
  const _InputDemo();

  @override
  State<_InputDemo> createState() => __InputDemoState();
}

class __InputDemoState extends State<_InputDemo> {
  bool _isChecked = false;
  bool _isSwitched = false;
  double _sliderValue = 0.5;
  String? _selectedFruit;

  final List<String> _fruits = ['Apel', 'Jeruk', 'Mangga', 'Anggur'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📝 TextField', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Masukkan nama Anda',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),

        const Text('☑️ Checkbox', style: TextStyle(fontWeight: FontWeight.bold)),
        CheckboxListTile(
          title: const Text('Setuju dengan syarat dan ketentuan'),
          value: _isChecked,
          onChanged: (value) => setState(() => _isChecked = value ?? false),
          activeColor: Colors.green,
        ),
        const SizedBox(height: 8),

        const Text('🔘 Switch', style: TextStyle(fontWeight: FontWeight.bold)),
        SwitchListTile(
          title: const Text('Aktifkan Notifikasi'),
          value: _isSwitched,
          onChanged: (value) => setState(() => _isSwitched = value),
          activeColor: Colors.blue,
        ),
        const SizedBox(height: 8),

        const Text('🎚️ Slider', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _sliderValue,
          onChanged: (value) => setState(() => _sliderValue = value),
          divisions: 10,
          label: '${(_sliderValue * 100).round()}%',
        ),
        Text('Nilai: ${(_sliderValue * 100).round()}%'),
        const SizedBox(height: 8),

        const Text('📋 DropdownButton', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedFruit,
          hint: const Text('Pilih buah favorit'),
          isExpanded: true,
          items: _fruits.map((fruit) {
            return DropdownMenuItem(value: fruit, child: Text(fruit));
          }).toList(),
          onChanged: (value) => setState(() => _selectedFruit = value),
        ),
        if (_selectedFruit != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Anda memilih: $_selectedFruit', style: const TextStyle(color: Colors.green)),
          ),
      ],
    );
  }
}

// ========== DEMO BUTTON ==========
class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();

  void _showButtonMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('🔘 Jenis-jenis Button', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () => _showButtonMessage(context, 'ElevatedButton ditekan'),
          child: const Text('Elevated Button'),
        ),
        const SizedBox(height: 12),

        FilledButton(
          onPressed: () => _showButtonMessage(context, 'FilledButton ditekan'),
          child: const Text('Filled Button'),
        ),
        const SizedBox(height: 12),

        OutlinedButton(
          onPressed: () => _showButtonMessage(context, 'OutlinedButton ditekan'),
          child: const Text('Outlined Button'),
        ),
        const SizedBox(height: 12),

        TextButton(
          onPressed: () => _showButtonMessage(context, 'TextButton ditekan'),
          child: const Text('Text Button'),
        ),
        const SizedBox(height: 12),

        ElevatedButton.icon(
          onPressed: () => _showButtonMessage(context, 'Button dengan Icon ditekan'),
          icon: const Icon(Icons.send),
          label: const Text('Kirim Pesan'),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: () => _showButtonMessage(context, 'Download ditekan'),
          icon: const Icon(Icons.download),
          label: const Text('Download'),
        ),
        const SizedBox(height: 20),

        const Text('🎯 IconButton', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => _showButtonMessage(context, 'Favorite'),
              icon: const Icon(Icons.favorite, color: Colors.red, size: 32),
            ),
            IconButton(
              onPressed: () => _showButtonMessage(context, 'Share'),
              icon: const Icon(Icons.share, color: Colors.green, size: 32),
            ),
            IconButton(
              onPressed: () => _showButtonMessage(context, 'Settings'),
              icon: const Icon(Icons.settings, color: Colors.blue, size: 32),
            ),
          ],
        ),
      ],
    );
  }
}

// ========== DEMO FEEDBACK ==========
class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('🍞 SnackBar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showSnackBar(context, '✨ Ini adalah SnackBar!'),
          child: const Text('Tampilkan SnackBar'),
        ),
        const SizedBox(height: 20),

        const Text('💬 AlertDialog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Apakah Anda yakin ingin melanjutkan?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSnackBar(context, 'Anda memilih Ya!');
                    },
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Tampilkan Dialog'),
        ),
        const SizedBox(height: 20),

        const Text('📊 Progress Indicator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        const LinearProgressIndicator(value: 0.65, backgroundColor: Colors.grey, color: Colors.blue),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            height: 80,
            width: 80,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              value: 0.75,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
        ),
      ],
    );
  }
}

// ========== DEMO LAYOUT ==========
class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📐 Row & Column', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          color: Colors.grey.shade200,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Icon(Icons.star, color: Colors.orange),
              Icon(Icons.star, color: Colors.orange),
              Icon(Icons.star, color: Colors.orange),
              Icon(Icons.star, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text('📦 Expanded & Flexible', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(width: 60, height: 50, color: Colors.red, child: const Center(child: Text('Fix'))),
            Expanded(child: Container(height: 50, color: Colors.green, child: const Center(child: Text('Expanded')))),
            Flexible(
              child: Container(height: 50, color: Colors.blue, child: const Center(child: Text('Flexible'))),
            ),
          ],
        ),
        const SizedBox(height: 20),

        const Text('📚 Stack', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: Stack(
            children: [
              Container(color: Colors.blue.shade100),
              Container(
                margin: const EdgeInsets.all(20),
                color: Colors.blue.shade300,
              ),
              const Positioned(
                bottom: 20,
                right: 20,
                child: Icon(Icons.star, size: 40, color: Colors.white),
              ),
              const Positioned(
                top: 20,
                left: 20,
                child: Chip(label: Text('Top Left')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text('🎨 Wrap (Auto wrap)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(12, (i) => Chip(label: Text('Item ${i + 1}'))),
        ),
        const SizedBox(height: 20),

        const Text('📱 SizedBox & Container', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Container')),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              height: 80,
              child: Container(color: Colors.orange, child: const Center(child: Text('SizedBox'))),
            ),
          ],
        ),
      ],
    );
  }
}

// ========== PAGE: EDIT PROFILE ==========
class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialRole;
  final String initialLocation;
  final String initialAbout;
  final String initialEducation;
  final String initialContact;
  final List<String> initialSkills;
  final String? initialImagePath;
  final String initialImageUrl;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialRole,
    required this.initialLocation,
    required this.initialAbout,
    required this.initialEducation,
    required this.initialContact,
    required this.initialSkills,
    this.initialImagePath,
    required this.initialImageUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _locationController;
  late TextEditingController _aboutController;
  late TextEditingController _educationController;
  late TextEditingController _contactController;
  late TextEditingController _skillsController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _roleController = TextEditingController(text: widget.initialRole);
    _locationController = TextEditingController(text: widget.initialLocation);
    _aboutController = TextEditingController(text: widget.initialAbout);
    _educationController = TextEditingController(text: widget.initialEducation);
    _contactController = TextEditingController(text: widget.initialContact);
    _skillsController = TextEditingController(text: widget.initialSkills.join(', '));
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, {
                'name': _nameController.text,
                'role': _roleController.text,
                'location': _locationController.text,
                'about': _aboutController.text,
                'education': _educationController.text,
                'contact': _contactController.text,
                'skills': _skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                'imagePath': _imagePath,
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _imagePath != null
                        ? (kIsWeb ? NetworkImage(_imagePath!) : FileImage(File(_imagePath!))) as ImageProvider
                        : NetworkImage(widget.initialImageUrl) as ImageProvider,
                  ),
                  IconButton.filled(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Pekerjaan/Status', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _aboutController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Tentang Saya', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _educationController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Pendidikan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Kontak', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills (pisahkan dengan koma)',
                border: OutlineInputBorder(),
                hintText: 'Flutter, Dart, UI/UX',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'role': _roleController.text,
                    'location': _locationController.text,
                    'about': _aboutController.text,
                    'education': _educationController.text,
                    'contact': _contactController.text,
                    'skills': _skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    'imagePath': _imagePath,
                  });
                },
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PAGE: EDIT EXPERIENCE (Bonus) ==========
class EditExperiencePage extends StatefulWidget {
  final String initialTitle;
  final String initialDesc;
  final String? initialImagePath;

  const EditExperiencePage({
    super.key,
    required this.initialTitle,
    required this.initialDesc,
    this.initialImagePath,
  });

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDesc);
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengalaman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(_imagePath!, fit: BoxFit.cover)
                            : Image.file(File(_imagePath!), fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Pilih Gambar Pengalaman', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Pengalaman', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Deskripsi Singkat', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'title': _titleController.text,
                    'desc': _descController.text,
                    'imagePath': _imagePath,
                  });
                },
                child: const Text('Simpan Pengalaman'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
