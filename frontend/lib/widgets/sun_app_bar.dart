import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class SunAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final VoidCallback? onMenuPressed;
  const SunAppBar({super.key, required this.isDesktop, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: isDesktop
          ? null
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: onMenuPressed,
            ),
      title: Text(
        'SUN ERP',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
      backgroundColor: SunTheme.sunOrange,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
