import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/screens/ui/feature_placeholder.dart';
import 'package:barangay_legal_aid/services/auth_service.dart';

class SuperAdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperAdmin Dashboard'),
        backgroundColor: Color(0xFF99272D),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await AuthService().logout();
              // Ensure we exit dashboard stack completely
              // and land on the login page
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
              title: 'Barangays',
              icon: '🏢',
              description: 'Manage all barangays',
              color: Color(0xFF99272D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Barangays',
                      description: 'Manage all barangays',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Admins',
              icon: '👑',
              description: 'Manage administrators',
              color: Color(0xFF36454F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Admins',
                      description: 'Manage administrators',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'System',
              icon: '⚙️',
              description: 'System configuration',
              color: Color(0xFF99272D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'System Configuration',
                      description: 'Configure system-wide settings',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Backup',
              icon: '💾',
              description: 'Data management',
              color: Color(0xFF36454F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Backup',
                      description: 'Manage data backups',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Analytics',
              icon: '📈',
              description: 'System-wide analytics',
              color: Color(0xFF99272D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Analytics',
                      description: 'View system-wide analytics',
                    ),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              title: 'Logs',
              icon: '📋',
              description: 'System logs',
              color: Color(0xFF36454F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeaturePlaceholder(
                      title: 'Logs',
                      description: 'View system logs',
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