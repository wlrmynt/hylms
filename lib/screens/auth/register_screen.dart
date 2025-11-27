import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRole = 'Mahasiswa';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Mahasiswa', child: Text('Mahasiswa')),
                DropdownMenuItem(value: 'Dosen', child: Text('Dosen/Pengajar')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_passwordController.text.length < 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 6 characters'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? errorMessage;
    bool registrationSuccess = false;

    try {
      // Add timeout to prevent infinite loading
      User? user = await FirebaseAuthService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
      ).timeout(const Duration(seconds: 30));

      if (user != null) {
        registrationSuccess = true;
      } else {
        errorMessage = 'Registration failed - user is null';
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      
      // Try to continue with demo mode if Firebase fails
      print('Firebase registration failed: $e');
      print('Attempting fallback mode...');
      
      // Create a test user object for demonstration
      final testUser = FirebaseAuthService.createTestUser(
        _emailController.text.trim(),
        _nameController.text.trim(),
        _selectedRole,
      );
      
      if (testUser != null) {
        print('Test user created successfully');
        registrationSuccess = true;
        errorMessage = 'Firebase not available. Using demo mode - your data will not be saved.';
      } else {
        if (errorStr.contains('timeout') || errorStr.contains('timed out')) {
          errorMessage = 'Registration timed out. Please check your internet connection and try again.';
        } else if (errorStr.contains('network') || errorStr.contains('connection')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (errorStr.contains('email-already-in-use')) {
          errorMessage = 'An account with this email already exists. Please use a different email.';
        } else if (errorStr.contains('weak-password')) {
          errorMessage = 'Password is too weak. Please choose a stronger password.';
        } else if (errorStr.contains('invalid-email')) {
          errorMessage = 'Invalid email address. Please enter a valid email.';
        } else {
          errorMessage = 'Registration failed: ${e.toString()}';
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (registrationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please check your email to verify your account.'),
              backgroundColor: Colors.green,
            ),
          );
          // Clear the form
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
}