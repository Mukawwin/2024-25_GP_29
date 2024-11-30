import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/Firebase/database.dart';
import 'package:mukawwin_3/models/UserModel.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    _showLoadingDialog(context); // Show loading dialog

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user UID
      String uid = userCredential.user!.uid;

      // Save user details in Firestore database
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'uid': uid,
        'username': username,
      });
      await userCredential.user!.sendEmailVerification();
      Navigator.of(context).pushReplacementNamed("verify");
      // Close the loading dialog
      _showSnackbar(context, 'User registered successfully!');
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      _showSnackbar(context, 'Error: ${e.message}');
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      _showSnackbar(context, 'An unexpected error occurred: $e');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _showLoadingDialog(context); // Show loading dialog

    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the email is verified
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        // If not verified, send verification email again
        await user.sendEmailVerification();
        Navigator.of(context).pop(); // Close the loading dialog

        // Show dialog to notify user about the verification email
        _showVerificationDialog(context);
      } else {
        await checkUseSetAllergiesNavigation(
            context); // Close the loading dialog
        _showSnackbar(context, 'Sign in successful!');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      _showSnackbar(context, 'Error: ${e.message}');
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      _showSnackbar(context, 'An unexpected error occurred: $e');
    }
  }

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Email Sent'),
        content: const Text(
          'We have sent you another verification email. Please verify your email to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in was canceled.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<User?> signUpWithGoogle(BuildContext context) async {
    User? user = await signInWithGoogle();
    if (user != null) {
      // Optional: Store user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'username': user.displayName,
      });
      print('User signed up successfully!');
      print(user);
      await checkUseSetAllergiesNavigation(context);
    }
    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> checkUseSetAllergiesNavigation(context) async {
    DatabaseService databaseService = DatabaseService();
    List data = await databaseService.getUserAllergies();
    if (data.isEmpty) {
      Navigator.of(context).pushReplacementNamed("allergies");
    } else {
      Navigator.of(context).pushReplacementNamed("account");
    }
  }

  Future<bool> checkUseSetAllergies() async {
    DatabaseService databaseService = DatabaseService();
    List data = await databaseService.getUserAllergies();
    return data.isNotEmpty;
  }

  Future<void> checkWelcomNavigate(BuildContext context) async {
    if (_auth.currentUser == null || !_auth.currentUser!.emailVerified) {
      Navigator.of(context).pushReplacementNamed("signin");
    } else {
      await checkUseSetAllergiesNavigation(context);
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      String userUid = _auth.currentUser!.uid;

      // Query Firestore to find the document with the current user's UID
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: userUid)
          .limit(1) // Limit to 1 since UID should be unique
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the first matching document
        var doc = snapshot.docs.first;
        // Create a UserModel from the document data
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        print('No user found with this UID.');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showDialog(
        context: context,
        title: 'Password Reset Email Sent',
        message:
            'Check your inbox and follow the instructions to reset your password.',
      );
    } catch (e) {
      _showDialog(
        context: context,
        title: 'Error',
        message: 'Failed to send password reset email. ${e.toString()}',
      );
    }
  }

  void _showDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
