import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';
import 'package:barangay_legal_aid/screens/ui/feature_placeholder.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await AuthService().logout();
              // ignore: use_build_context_synchronously
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: Text(
              'LOGOUT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              title: 'Users',
              icon: '👥',
              description: 'Manage users',
              color: Color(0xFF99272D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Users',
                      description: 'Manage users',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Cases',
              icon: '📋',
              description: 'Track legal cases',
              color: Color(0xFF36454F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Cases',
                      description: 'Track and manage cases',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Chats',
              icon: '💬',
              description: 'Monitor conversations',
              color: Color(0xFF99272D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Chats',
                      description: 'Monitor conversations',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Reports',
              icon: '📊',
              description: 'View analytics',
              color: Color(0xFF36454F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Reports',
                      description: 'View analytics and reports',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Documents',
              icon: '📄',
              description: 'Manage templates',
              color: Color(0xFF99272D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Documents',
                      description: 'Manage templates and documents',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Settings',
              icon: '⚙️',
              description: 'Barangay settings',
              color: Color(0xFF36454F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Settings',
                      description: 'Barangay settings',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String icon,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}