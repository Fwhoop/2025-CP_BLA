import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontTester extends StatelessWidget {
  const FontTester({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Font Tester', style: GoogleFonts.roboto()),
        backgroundColor: Color(0xFF99272D),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFontWeight('Thin', FontWeight.w100),
              _buildFontWeight('Light', FontWeight.w300),
              _buildFontWeight('Regular', FontWeight.w400),
              _buildFontWeight('Medium', FontWeight.w500),
              _buildFontWeight('Bold', FontWeight.w700),
              _buildFontWeight('Black', FontWeight.w900),
              SizedBox(height: 30),
              _buildStyleSample('Headline Large', Theme.of(context).textTheme.headlineLarge!),
              _buildStyleSample('Headline Medium', Theme.of(context).textTheme.headlineMedium!),
              _buildStyleSample('Headline Small', Theme.of(context).textTheme.headlineSmall!),
              _buildStyleSample('Title Large', Theme.of(context).textTheme.titleLarge!),
              _buildStyleSample('Title Medium', Theme.of(context).textTheme.titleMedium!),
              _buildStyleSample('Title Small', Theme.of(context).textTheme.titleSmall!),
              _buildStyleSample('Body Large', Theme.of(context).textTheme.bodyLarge!),
              _buildStyleSample('Body Medium', Theme.of(context).textTheme.bodyMedium!),
              _buildStyleSample('Body Small', Theme.of(context).textTheme.bodySmall!),
              _buildStyleSample('Label Large', Theme.of(context).textTheme.labelLarge!),
              _buildStyleSample('Label Small', Theme.of(context).textTheme.labelSmall!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontWeight(String name, FontWeight weight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Roboto $name - The quick brown fox jumps over the lazy dog',
        style: GoogleFonts.roboto(
          fontWeight: weight,
          fontSize: 16,
          color: Color(0xFF36454F),
        ),
      ),
    );
  }

  Widget _buildStyleSample(String name, TextStyle style) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            color: Color(0xFF99272D),
          )),
          Text(
            'Sample text for $name style',
            style: style.copyWith(color: Color(0xFF36454F)),
          ),
          Divider(color: Color(0xFF36454F).withOpacity(0.2)),
        ],
      ),
    );
  }
}