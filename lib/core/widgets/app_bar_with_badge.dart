import 'package:flutter/material.dart';

class AppBarWithBadge extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBadge({
    super.key,
    required this.title,
    required this.notificationsCount,
    this.onNotificationPressed,
    this.actions,
  });

  final String title;
  final int notificationsCount;
  final VoidCallback? onNotificationPressed;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        ...?actions,
        IconButton(
          onPressed: onNotificationPressed,
          icon: Badge(
            label: notificationsCount > 0 ? Text('$notificationsCount') : null,
            isLabelVisible: notificationsCount > 0,
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
