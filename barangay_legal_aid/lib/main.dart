import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/screens/signup_page.dart';
import 'package:barangay_legal_aid/screens/login_page.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';
import 'chat_screen.dart';
import 'chat_history.dart';
import 'chat_provider.dart';

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
      theme: _buildThemeData(),
      home: isLoggedIn ? HomeScreen() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }

  ThemeData _buildThemeData() {
    final baseTheme = ThemeData.light();
    
    return baseTheme.copyWith(
      primaryColor: Color(0xFF99272D),
      scaffoldBackgroundColor: Color(0xFFFFFFFF),
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: Color(0xFF99272D),
        secondary: Color(0xFF36454F),
        background: Color(0xFFFFFFFF),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF99272D),
          foregroundColor: Color(0xFFFFFFFF),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF99272D),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF36454F).withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF36454F).withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF99272D), width: 2),
        ),
      ),
      // REMOVE cardTheme if it's causing issues - it's optional
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

  @override
  void initState() {
    super.initState();
    _chatProvider.addListener(_refresh);
  }

  @override
  void dispose() {
    _chatProvider.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barangay Legal Aid Chatbot'),
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        child: Row(
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Color(0xFF36454F),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(2, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: ChatHistorySidebar(chatProvider: _chatProvider),
              ),
            ),
            Expanded(
              child: ChatScreen(chatProvider: _chatProvider),
            ),
          ],
        ),
      ),
    );
  }
}