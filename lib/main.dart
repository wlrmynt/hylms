import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/kursus_mandiri_screen.dart';
import 'screens/kelas_terstruktur_screen.dart';
import 'screens/tugas_screen.dart';
import 'screens/forum_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/certificate_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HYLMS - Hybrid Learning Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(), // Start with login
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const MainNavigation(),
        '/kursus_mandiri': (context) => const KursusMandiriScreen(),
        '/kelas_terstruktur': (context) => const KelasTerstrukturScreen(),
        '/tugas': (context) => const TugasScreen(),
        '/forum': (context) => const ForumScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/certificate': (context) => const CertificateScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    KursusMandiriScreen(),
    KelasTerstrukturScreen(),
    TugasScreen(),
    ForumScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.school, color: Colors.white, size: 28),
        title: const Text('HYLMS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nama Pengguna',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'email@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Progress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/progress');
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Sertifikat'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/certificate');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.blue),
            activeIcon: Icon(Icons.dashboard, color: Colors.purple),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.blue),
            activeIcon: Icon(Icons.book, color: Colors.purple),
            label: 'Kursus Mandiri',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.blue),
            activeIcon: Icon(Icons.school, color: Colors.purple),
            label: 'Kelas Terstruktur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.blue),
            activeIcon: Icon(Icons.assignment, color: Colors.purple),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum, color: Colors.blue),
            activeIcon: Icon(Icons.forum, color: Colors.purple),
            label: 'Forum',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
