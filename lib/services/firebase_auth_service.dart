import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  static Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      print('=== FIREBASE REGISTRATION START ===');
      print('Email: $email');
      print('Firebase project: ${_auth.app.options.projectId}');
      print('Firebase API key: ${_auth.app.options.apiKey}');
      
      // Create user account
      print('Creating user account...');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(Duration(seconds: 30));
      
      print('User created successfully!');
      print('User ID: ${result.user?.uid}');
      print('User email: ${result.user?.email}');

      User? user = result.user;

      if (user != null) {
        print('Creating Firestore profile...');
        
        // Create user profile in Firestore
        UserProfile userProfile = UserProfile(
          id: user.uid,
          email: email,
          name: name,
          role: role,
          skillLevel: 'Beginner',
          interests: [],
          preferredLearningStyle: 'Hands-on',
          availableHoursPerWeek: 10,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );

        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userProfile.toJson());
          print('User profile saved to Firestore successfully');
        } catch (firestoreError) {
          print('Firestore error (non-critical): $firestoreError');
          // Continue even if Firestore fails - auth is more important
        }
        
        print('=== REGISTRATION COMPLETED SUCCESSFULLY ===');
        return user;
      } else {
        throw Exception('User creation failed - null result');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      print('Error details: ${e.toString()}');
      
      // Provide more specific error messages
      switch (e.code) {
        case 'operation-not-allowed':
          throw Exception('Firebase authentication is not enabled. Please enable Email/Password authentication in Firebase Console.');
        case 'weak-password':
          throw Exception('Password is too weak. Please choose a stronger password.');
        case 'email-already-in-use':
          throw Exception('An account with this email already exists.');
        case 'invalid-email':
          throw Exception('Invalid email address format.');
        case 'network-request-failed':
          throw Exception('Network error. Please check your internet connection and try again.');
        case 'too-many-requests':
          throw Exception('Too many failed attempts. Please wait a moment and try again.');
        default:
          throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e, stackTrace) {
      print('Registration error: $e');
      print('Stack trace: $stackTrace');
      
      if (e.toString().toLowerCase().contains('timeout')) {
        throw Exception('Registration timed out. Please check your internet connection and try again.');
      }
      
      rethrow;
    }
  }

  // Simple fallback for testing - create a basic user object
  static dynamic createTestUser(String email, String name, String role) {
    print('Creating test user (Firebase may not be configured)');
    print('Email: $email, Name: $name, Role: $role');
    return {
      'uid': 'test_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'name': name,
      'role': role,
      'isTestUser': true,
    };
  }

  // Check Firebase project configuration
  static Future<bool> checkFirebaseConnection() async {
    try {
      print('Checking Firebase connection...');
      print('Firebase app name: ${_auth.app.name}');
      print('Firebase project ID: ${_auth.app.options.projectId}');
      print('Firebase API key: ${_auth.app.options.apiKey}');
      
      // Test if we can reach Firebase
      await _auth.authStateChanges().first.timeout(Duration(seconds: 5));
      print('Firebase connection test: SUCCESS');
      return true;
    } catch (e) {
      print('Firebase connection test failed: $e');
      return false;
    }
  }

  // Sign in with email and password
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user profile from Firestore
  static Future<UserProfile?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserProfile.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting user profile: $e');
    }
    return null;
  }

  // Update user profile
  static Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      userProfile.updatedAt = DateTime.now();
      await _firestore
          .collection('users')
          .doc(userProfile.id)
          .update(userProfile.toJson());
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}