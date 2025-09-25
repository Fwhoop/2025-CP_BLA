// main.dart - Update the home logic
import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/screens/signup_page.dart';
import 'package:barangay_legal_aid/screens/login_page.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';
import 'package:barangay_legal_aid/models/user_model.dart';
import 'chat_screen.dart';
import 'chat_provider.dart';
import 'chat_history.dart';
import 'package:barangay_legal_aid/screens/admin_dashboard.dart';
import 'package:barangay_legal_aid/screens/superadmin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barangay Legal Aid Chatbot',
      theme: ThemeData(
        primaryColor: Color(0xFF99272D),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF99272D),
          secondary: Color(0xFF36454F),
          background: Color(0xFFFFFFFF),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF99272D),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 3,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      home: isLoggedIn ? HomeScreen() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomeScreen(),
        '/admin': (context) => AdminDashboard(),
        '/superadmin': (context) => SuperAdminDashboard(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatProvider _chatProvider = ChatProvider();
  final AuthService _authService = AuthService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _getHomeScreen() {
    if (_currentUser?.isSuperAdmin == true) {
      return SuperAdminDashboard();
    } else if (_currentUser?.isAdmin == true) {
      return AdminDashboard();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Barangay Legal Aid Chatbot'),
          backgroundColor: Color(0xFF99272D),
          actions: [
            TextButton(
              onPressed: _logout,
              child: Text(
                'LOGOUT',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Container(
              width: 300,
              color: Color(0xFF36454F),
              child: ChatHistorySidebar(chatProvider: _chatProvider),
            ),
            Expanded(
              child: ChatScreen(chatProvider: _chatProvider),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getHomeScreen();
  }
}