import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Ahmad Surya');
  final _emailController = TextEditingController(text: 'ahmad@example.com');
  final _bioController = TextEditingController(text: 'Mahasiswa Informatika');
  final _majorController = TextEditingController(text: 'Teknik Informatika');
  final _institutionController = TextEditingController(text: 'Universitas Indonesia');
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditingProfile = false;
  bool _isChangingPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        actions: [
          IconButton(
            icon: Icon(_isEditingProfile ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditingProfile = !_isEditingProfile;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () {
                          // Change profile picture
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Profile Information
            const Text(
              'Informasi Profil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditingProfile,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditingProfile,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditingProfile,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _majorController,
              decoration: const InputDecoration(
                labelText: 'Jurusan',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditingProfile,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institusi',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditingProfile,
            ),
            const SizedBox(height: 24),
            // Change Password Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ubah Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(_isChangingPassword ? Icons.close : Icons.lock),
                  onPressed: () {
                    setState(() {
                      _isChangingPassword = !_isChangingPassword;
                    });
                  },
                ),
              ],
            ),
            if (_isChangingPassword) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password Lama',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Change password logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password berhasil diubah')),
                  );
                  setState(() {
                    _isChangingPassword = false;
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                  });
                },
                child: const Text('Ubah Password'),
              ),
            ],
            const SizedBox(height: 24),
            // Account Status
            const Text(
              'Status Akun',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Role: Mahasiswa'),
                    SizedBox(height: 8),
                    Text('Status: Aktif'),
                    SizedBox(height: 8),
                    Text('Bergabung sejak: Januari 2023'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}