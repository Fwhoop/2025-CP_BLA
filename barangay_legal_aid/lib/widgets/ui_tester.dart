import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UITester extends StatelessWidget {
  const UITester({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UI Components Tester', style: GoogleFonts.roboto()),
        backgroundColor: Color(0xFF99272D),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection('Buttons'),
              ElevatedButton(
                onPressed: () {},
                child: Text('Primary Button', style: GoogleFonts.roboto()),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                child: Text('Outlined Button', style: GoogleFonts.roboto()),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text('Text Button', style: GoogleFonts.roboto()),
              ),
              
              _buildSection('Input Fields'),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Normal Text Field',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Focused Text Field',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                autofocus: true,
              ),
              
              _buildSection('Cards'),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Color(0xFF99272D)),
                  title: Text('Card Title', style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                  subtitle: Text('Card subtitle description', style: GoogleFonts.roboto()),
                ),
              ),
              
              _buildSection('Color Palette'),
              _buildColorSwatch('Primary Red', Color(0xFF99272D)),
              _buildColorSwatch('Charcoal', Color(0xFF36454F)),
              _buildColorSwatch('White', Color(0xFFFFFFFF)),
              
              _buildSection('Chat Bubbles Preview'),
              _buildChatBubble('Hello! This is a user message', true),
              _buildChatBubble('Hi there! This is a bot response', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF36454F),
        ),
      ),
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF36454F).withOpacity(0.3)),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              Text(color.value.toRadixString(16).toUpperCase(), style: GoogleFonts.roboto(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isUser) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? Color(0xFF99272D) : Color(0xFF36454F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: GoogleFonts.roboto(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
    );
  }
}