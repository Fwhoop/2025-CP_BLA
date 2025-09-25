import 'package:flutter/material.dart';

class FeaturePlaceholder extends StatelessWidget {
  final String title;
  final String description;

  const FeaturePlaceholder({
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 72, color: Color(0xFF36454F)),
            SizedBox(height: 16),
            Text(
              '$title (Coming Soon)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF36454F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF36454F).withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF99272D)),
              child: Text('Back'),
            )
          ],
        ),
      ),
    );
  }
}


