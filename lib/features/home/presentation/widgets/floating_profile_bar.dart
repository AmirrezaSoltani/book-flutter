import 'package:flutter/material.dart';

class FloatingProfileBar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const FloatingProfileBar({
    super.key,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
              backgroundColor: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Hello, Guest!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 28),
            onPressed: onNotificationTap,
          ),
        ],
      ),
    );
  }
} 