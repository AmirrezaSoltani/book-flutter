import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // TODO: Navigate to settings
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Books Read', '24'),
                      _buildStatItem('Audiobooks', '12'),
                      _buildStatItem('Wishlist', '8'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.favorite,
                    title: 'Wishlist',
                    subtitle: 'Your saved books',
                    onTap: () {
                      // TODO: Navigate to wishlist
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Reading History',
                    subtitle: 'Track your progress',
                    onTap: () {
                      // TODO: Navigate to history
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your alerts',
                    onTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage your cards',
                    onTap: () {
                      // TODO: Navigate to payment
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get assistance',
                    onTap: () {
                      // TODO: Navigate to support
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 