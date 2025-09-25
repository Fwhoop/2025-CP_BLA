import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';
import 'package:barangay_legal_aid/models/user_model.dart'; // Add this import

class AuthTester extends StatefulWidget {
  const AuthTester({super.key});

  @override
  State<AuthTester> createState() => _AuthTesterState();
}

class _AuthTesterState extends State<AuthTester> {
  final AuthService _authService = AuthService();
  String _authStatus = 'Not checked';
  Map<String, String> _userData = {};
  User? _currentUser; // Store the current user

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    setState(() {
      _authStatus = isLoggedIn ? 'Logged In' : 'Logged Out';
    });
  }

  Future<void> _getUserData() async {
    final data = await _authService.getUserData();
    setState(() {
      _userData = data;
    });
  }

  Future<void> _getCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _simulateLogin() async {
    final User? user = await _authService.login(  // Fixed: Use User? instead of var/success
      email: 'test@legalaid.com',
      password: 'test123',
      rememberMe: true,
    );
    
    setState(() {
      _authStatus = user != null ? 'Login Successful' : 'Login Failed';  // Fixed condition
    });
    
    if (user != null) {  // Fixed condition
      await _getUserData();
      await _getCurrentUser();
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    setState(() {
      _authStatus = 'Logged Out';
      _userData = {};
      _currentUser = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _getUserData();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Flow Tester', style: GoogleFonts.roboto()),
        backgroundColor: Color(0xFF99272D),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(),
            SizedBox(height: 20),
            _buildUserDataCard(),
            SizedBox(height: 20),
            _buildCurrentUserCard(), // Add this card
            SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Authentication Status', style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              color: Color(0xFF36454F),
            )),
            SizedBox(height: 10),
            Text(_authStatus, style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: _authStatus.contains('Successful') || _authStatus == 'Logged In' 
                  ? Colors.green 
                  : Color(0xFF99272D),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDataCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Data from Storage', style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              color: Color(0xFF36454F),
            )),
            SizedBox(height: 10),
            if (_userData.isEmpty)
              Text('No user data available', style: GoogleFonts.roboto()),
            ..._userData.entries.map((entry) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text('${entry.key}: ', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                  Expanded(child: Text(entry.value, style: GoogleFonts.roboto())),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentUserCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current User Object', style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              color: Color(0xFF36454F),
            )),
            SizedBox(height: 10),
            if (_currentUser == null)
              Text('No user logged in', style: GoogleFonts.roboto()),
            if (_currentUser != null) ...[
              _buildUserInfo('Name', _currentUser!.fullName),
              _buildUserInfo('Email', _currentUser!.email),
              _buildUserInfo('Role', _currentUser!.roleDisplay),
              _buildUserInfo('Barangay', _currentUser!.barangay),
              _buildUserInfo('Is Admin', _currentUser!.isAdmin.toString()),
              _buildUserInfo('Is SuperAdmin', _currentUser!.isSuperAdmin.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: GoogleFonts.roboto())),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _simulateLogin,
          child: Text('Simulate Login', style: GoogleFonts.roboto()),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF36454F),
          ),
          child: Text('Logout', style: GoogleFonts.roboto()),
        ),
        SizedBox(height: 10),
        OutlinedButton(
          onPressed: _checkAuthStatus,
          child: Text('Refresh Status', style: GoogleFonts.roboto()),
        ),
        SizedBox(height: 10),
        // Add test buttons for different roles
        Wrap(
          spacing: 8,
          children: [
            FilledButton.tonal(
              onPressed: () => _testLogin('user@legalaid.com', 'password123'),
              child: Text('Test User', style: TextStyle(fontSize: 12)),
            ),
            FilledButton.tonal(
              onPressed: () => _testLogin('admin@legalaid.com', 'admin123'),
              child: Text('Test Admin', style: TextStyle(fontSize: 12)),
            ),
            FilledButton.tonal(
              onPressed: () => _testLogin('superadmin@legalaid.com', 'super123'),
              child: Text('Test SuperAdmin', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _testLogin(String email, String password) async {
    final User? user = await _authService.login(
      email: email,
      password: password,
      rememberMe: true,
    );
    
    setState(() {
      _authStatus = user != null ? 'Login as ${user.roleDisplay}' : 'Login Failed';
    });
    
    if (user != null) {
      await _getUserData();
      await _getCurrentUser();
    }
  }
}