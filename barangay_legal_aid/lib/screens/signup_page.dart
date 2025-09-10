import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedBarangay;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _barangays = [
    'Barangay 1', 'Barangay 2', 'Barangay 3', 'Barangay 4',
    'Barangay 5', 'Barangay 6', 'Barangay 7', 'Barangay 8',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Color(0xFF99272D),
          ),
        );
        return;
      }

      if (_selectedBarangay == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select your barangay'),
            backgroundColor: Color(0xFF99272D),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final success = await _authService.signUp(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          barangay: _selectedBarangay!,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created successfully! Please login.'),
              backgroundColor: Color(0xFF36454F),
              duration: Duration(seconds: 3),
            ),
          );
          
          await Future.delayed(Duration(seconds: 2));
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup failed. Please try again.'),
              backgroundColor: Color(0xFF99272D),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Color(0xFF99272D),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
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
                SizedBox(height: 30),
                _buildNameFields(),
                SizedBox(height: 20),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 20),
                _buildConfirmPasswordField(),
                SizedBox(height: 20),
                _buildPhoneField(),
                SizedBox(height: 20),
                _buildAddressField(),
                SizedBox(height: 20),
                _buildBarangayDropdown(),
                SizedBox(height: 30),
                _buildSignupButton(),
                SizedBox(height: 20),
                _buildLoginLink(),
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
          'Create your account',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF36454F).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person, color: Color(0xFF36454F)),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFFFFFFF),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFFFFFFF),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
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
        if (!value.contains('@')) {
          return 'Please enter a valid email';
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
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF36454F)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF36454F),
          ),
          onPressed: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          },
        ),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: Icon(Icons.phone, color: Color(0xFF36454F)),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.length < 10) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: 'Complete Address',
        prefixIcon: Icon(Icons.home, color: Color(0xFF36454F)),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your address';
        }
        return null;
      },
    );
  }

  Widget _buildBarangayDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBarangay,
      decoration: InputDecoration(
        labelText: 'Select Barangay',
        prefixIcon: Icon(Icons.location_on, color: Color(0xFF36454F)),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      items: _barangays.map((String barangay) {
        return DropdownMenuItem<String>(
          value: barangay,
          child: Text(barangay, style: TextStyle(color: Color(0xFF36454F))),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => _selectedBarangay = newValue);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your barangay';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton() {
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
              'Create Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?', style: TextStyle(color: Color(0xFF36454F))),
        SizedBox(width: 5),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xFF99272D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}