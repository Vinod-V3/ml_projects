import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nevil Mathew',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ML Engineer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Profile Information
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.email,
              title: 'Email',
              value: 'nevil.mathew@example.com',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.phone,
              title: 'Phone',
              value: '+1 234 567 8900',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.location_on,
              title: 'Location',
              value: 'San Francisco, CA',
            ),
            
            const SizedBox(height: 32),
            
            // Statistics
            _buildSectionTitle('Statistics'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Projects',
                    value: '12',
                    icon: Icons.folder,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Models',
                    value: '24',
                    icon: Icons.model_training,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Accuracy',
                    value: '92%',
                    icon: Icons.analytics,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Experience',
                    value: '5 yrs',
                    icon: Icons.work,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Settings
            _buildSectionTitle('Settings'),
            const SizedBox(height: 16),
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            _buildSettingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Language',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
