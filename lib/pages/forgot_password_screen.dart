import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSendingEmail = false;
  bool _emailSent = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isSendingEmail = true;
    });
    bool success = await resetPassword(_emailController.text.trim());
    setState(() {
      _isSendingEmail = false;
      _emailSent = success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email address to reset your password.'),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isSendingEmail ? null : _resetPassword,
              child: _isSendingEmail
                  ? const CircularProgressIndicator()
                  : const Text('Reset Password'),
            ),
            if (_emailSent)
              const Text(
                'Password reset email sent. Check your email inbox.',
                style: TextStyle(color: Colors.green),
              ),
            if (!_emailSent && _emailSent != null)
              const Text(
                'Failed to send password reset email. Please check your email address and try again.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
