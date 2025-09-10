import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          rememberMe: _rememberMe,
        );

        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email or password. Please try again.'),
              backgroundColor: Color(0xFF99272D),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login error: $e'),
            backgroundColor: Color(0xFF99272D),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  void _navigateToForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Forgot password feature coming soon!'),
        backgroundColor: Color(0xFF36454F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Legal Aid'),
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLogo(),
                SizedBox(height: 40),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 15),
                _buildRememberMeCheckbox(),
                SizedBox(height: 25),
                _buildLoginButton(),
                SizedBox(height: 20),
                _buildDivider(),
                SizedBox(height: 20),
                _buildSignupLink(),
                SizedBox(height: 15),
                _buildForgotPasswordLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Icon(
          Icons.gavel,
          size: 80,
          color: Color(0xFF99272D),
        ),
        SizedBox(height: 10),
        Text(
          'Barangay Legal Aid',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF36454F),
          ),
        ),
        Text(
          'Welcome back! Please login to continue',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF36454F).withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email, color: Color(0xFF36454F)),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock, color: Color(0xFF36454F)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF36454F),
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() => _rememberMe = value ?? false);
          },
          activeColor: Color(0xFF99272D),
        ),
        Text('Remember me', style: TextStyle(color: Color(0xFF36454F))),
        Spacer(),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF99272D),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFFFFFFF),
                strokeWidth: 2,
              ),
            )
          : Text(
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFF36454F).withOpacity(0.3))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('OR', style: TextStyle(color: Color(0xFF36454F))),
        ),
        Expanded(child: Divider(color: Color(0xFF36454F).withOpacity(0.3))),
      ],
    );
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: Color(0xFF36454F))),
        SizedBox(width: 5),
        TextButton(
          onPressed: _navigateToSignup,
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF99272D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: _navigateToForgotPassword,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF99272D),
        ),
      ),
    );
  }
}