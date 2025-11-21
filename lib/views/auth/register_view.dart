import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstCtrl = TextEditingController();
  final TextEditingController _lastCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _rePasswordCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isReenterPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    _rePasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 1. Validate the form inputs
    if (!_formKey.currentState!.validate()) return;
    
    // 2. Additional check for password match
    if (_passwordCtrl.text != _rePasswordCtrl.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Passwords do not match.')),
        );
      }
      return;
    }

    debugPrint('📝 Form validated, starting registration...');
    setState(() => _isLoading = true);

    try {
      debugPrint('📞 Calling AuthService.signUpWithEmail...');
      
      // Register user with Firebase
      final result = await _authService.signUpWithEmail(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        firstName: _firstCtrl.text,
        lastName: _lastCtrl.text,
        address: _addressCtrl.text,
      );

      debugPrint('📬 Received result from AuthService: $result');

      if (!mounted) return;

      if (result['success']) {
        debugPrint('✅ Registration successful, navigating to role selection');
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to role selection (not login)
        Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelection);
      } else {
        debugPrint('❌ Registration failed: ${result['message']}');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Exception during registration: $e');
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      // Default border (no error)
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      // Error border styling
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      // Focused border styling
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppThemes.primaryGreen, width: 2),
      ),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppThemes.primaryGreen),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              Text('AgriLink',
                  style: TextStyle(
                    color: AppThemes.primaryGreen,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LilitaOne',
                  )),
              const SizedBox(height: 8),
              Text('Sign Up', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87)),
              SizedBox(height: size.height * 0.04),

              // First name
              Align(alignment: Alignment.centerLeft, child: Text('First Name', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstCtrl,
                decoration: _inputDecoration(hint: 'First name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Last name
              Align(alignment: Alignment.centerLeft, child: Text('Last Name', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastCtrl,
                decoration: _inputDecoration(hint: 'Last name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              Align(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(hint: 'you@example.com'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  }
                  // A simple regex check for email format
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              Align(alignment: Alignment.centerLeft, child: Text('Address', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressCtrl,
                decoration: _inputDecoration(hint: 'Your address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: 'Password (min 8 characters)',
                  suffix: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    color: Colors.grey,
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required.';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Re-enter password
              Align(alignment: Alignment.centerLeft, child: Text('Re-enter Password', style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _rePasswordCtrl,
                obscureText: !_isReenterPasswordVisible,
                decoration: _inputDecoration(
                  hint: 'Re-enter password',
                  suffix: IconButton(
                    icon: Icon(_isReenterPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    color: Colors.grey,
                    onPressed: () => setState(() => _isReenterPasswordVisible = !_isReenterPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your password.';
                  }
                  // Check if it matches the primary password
                  if (value != _passwordCtrl.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Sign up button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(text: 'Sign In', style: TextStyle(color: AppThemes.primaryGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}