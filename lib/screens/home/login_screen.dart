import 'package:flutter/material.dart';
import 'package:myapp/widgets/admin_widget.dart';
import 'package:myapp/widgets/main_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/hura_point_provider.dart';
import '../../utils/app_colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // State variables
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Controllers for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fetch user email from Supabase
  Future<String?> _getUserEmail() async {
    final user = Supabase.instance.client.auth.currentUser;
    "Current User Metadata: ${user?.userMetadata}";
    return user?.userMetadata?['email'];
  }

  // Handle navigation based on user email
  Future<void> _handleNavigation() async {
    final email = await _getUserEmail();

    if (email == 'admin1@test.com') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminWidget()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainWidget()),
      );
    }
  }

  // Perform login operation
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user != null) {
          // Update daily points on login
          final huraPointProvider =
              Provider.of<HuraPointProvider>(context, listen: false);
          huraPointProvider.updateDailyPointsOnLogin();

          // Show success dialog
          await _showSuccessDialog();
          print("User Metadata: ${response.user!.userMetadata}");
          // Lanjutkan dengan navigasi
          await Supabase.instance.client.auth.refreshSession();

          // Navigate based on user email
          await _handleNavigation();
        }
      } on AuthException catch (error) {
        _handleError(error.message);
      } catch (e) {
        _handleError('An unexpected error occurred: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show success dialog
  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Successful"),
        content: const Text("You have earned 1 daily point! 🎉"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Handle login errors
  void _handleError(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Main Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildLoginForm(context),
            ),
          ),
          // Loading Indicator Overlay
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  // Build Login Form
  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Tahura!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 30),
          _buildEmailField(),
          const SizedBox(height: 9),
          _buildPasswordField(),
          const SizedBox(height: 8),
          _buildRememberMeCheckbox(),
          const SizedBox(height: 30),
          _buildLoginButton(),
          const SizedBox(height: 10),
          _buildRegisterLink(),
        ],
      ),
    );
  }

  // Build Email Field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        isDense: true,
      ),
      style: const TextStyle(fontSize: 12),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  // Build Password Field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        isDense: true,
      ),
      obscureText: true,
      style: const TextStyle(fontSize: 12),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }

  // Build Remember Me Checkbox
  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value!;
            });
          },
          activeColor: AppColors.secondary,
        ),
        const Text(
          'Remember Me',
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  // Build Login Button
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Build Register Link
  Widget _buildRegisterLink() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: const Text(
          'Don\'t have an account? Register here.',
          style: TextStyle(
            fontSize: 11,
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  // Build Loading Indicator Overlay
  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
