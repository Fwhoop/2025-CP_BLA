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
        useMaterial3: true,
        primaryColor: Color(0xFF99272D),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF99272D),
          secondary: Color(0xFF36454F),
          background: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
          error: Color(0xFFB3261E),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF36454F)),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF36454F)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF36454F)),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF99272D),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFFCDD5DF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF99272D), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFFB3261E)),
          ),
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          labelStyle: TextStyle(color: Color(0xFF36454F)),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF99272D),
            foregroundColor: Color(0xFFFFFFFF),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF36454F),
          contentTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Colors.white),
          checkColor: MaterialStateProperty.all(Color(0xFF99272D)),
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(
              color: states.contains(MaterialState.selected)
                  ? Color(0xFF99272D)
                  : Color(0xFFCDD5DF),
              width: 2,
            ),
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
  bool _showHistory = true;

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
          leading: IconButton(
            icon: Icon(_showHistory ? Icons.chevron_left : Icons.chevron_right),
            tooltip: _showHistory ? 'Hide history' : 'Show history',
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
          ),
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
            if (_showHistory)
              Container(
                width: 300,
                color: Color(0xFF36454F),
                child: ChatHistorySidebar(
                  chatProvider: _chatProvider,
                  onToggle: () {
                    setState(() {
                      _showHistory = false;
                    });
                  },
                ),
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