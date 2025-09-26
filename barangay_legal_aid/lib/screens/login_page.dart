import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';
import 'package:barangay_legal_aid/models/user_model.dart';

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
        final User? user = await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          rememberMe: _rememberMe,
        );

        if (user != null) {
          if (user.isSuperAdmin) {
            Navigator.pushReplacementNamed(context, '/superadmin');
          } else if (user.isAdmin) {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
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
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogo(),
                    SizedBox(height: 32),
                    _buildEmailField(),
                    SizedBox(height: 16),
                    _buildPasswordField(),
                    SizedBox(height: 8),
                    _buildRememberMeCheckbox(),
                    SizedBox(height: 20),
                    _buildLoginButton(),
                    SizedBox(height: 16),
                    _buildDivider(),
                    SizedBox(height: 16),
                    _buildSignupLink(),
                    SizedBox(height: 8),
                    _buildForgotPasswordLink(),
                  ],
                ),
              ),
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
        labelText: 'Email address',
        hintText: 'you@example.com',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
        if (!emailRegex.hasMatch(value)) {
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
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
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
        ),
        Text('Remember me'),
        Spacer(),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Login',
            style: Theme.of(context).textTheme.labelLarge,
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