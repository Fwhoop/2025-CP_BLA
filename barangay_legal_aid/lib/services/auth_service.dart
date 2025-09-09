import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Map<String, String> _demoUsers = {
    'user@legalaid.com': 'password123',
    'demo@legalaid.com': 'demo123',
    'test@legalaid.com': 'test123',
  };

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String barangay,
  }) async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setString('barangay', barangay);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', true);

    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    
    if (_demoUsers.containsKey(email) && _demoUsers[email] == password) {
      await _setLoginState(true, rememberMe, email);
      return true;
    }

    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');
    
    if (storedEmail == email && storedPassword == password) {
      await _setLoginState(true, rememberMe, email);
      return true;
    }

    return false;
  }

  Future<void> _setLoginState(bool isLoggedIn, bool rememberMe, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setBool('rememberMe', rememberMe);
    await prefs.setString('lastLogin', DateTime.now().toString());
    
    if (_demoUsers.containsKey(email)) {
      await prefs.setString('firstName', 'Demo');
      await prefs.setString('lastName', 'User');
      await prefs.setString('email', email);
      await prefs.setString('phone', '09123456789');
      await prefs.setString('address', '123 Demo Street');
      await prefs.setString('barangay', 'Barangay 1');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    
    if (rememberMe && isLoggedIn) {
      return true;
    }
    
    final lastLogin = prefs.getString('lastLogin');
    if (lastLogin != null) {
      final lastLoginDate = DateTime.parse(lastLogin);
      final difference = DateTime.now().difference(lastLoginDate);
      
      if (difference.inDays < 7) {
        return isLoggedIn;
      }
    }
    
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    
    if (!rememberMe) {
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('lastLogin');
    }
  }

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'email': prefs.getString('email') ?? '',
      'phone': prefs.getString('phone') ?? '',
      'address': prefs.getString('address') ?? '',
      'barangay': prefs.getString('barangay') ?? '',
    };
  }

  Future<bool> hasUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') != null;
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}