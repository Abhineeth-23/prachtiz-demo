import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NotificationButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final Color badgeColor;
  final String tooltip;
  final VoidCallback? onPressed;

  const NotificationButton({
    super.key,
    required this.icon,
    required this.badgeCount,
    required this.badgeColor,
    required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip +
          (badgeCount > 0 ? " ($badgeCount unread notifications)" : ""),
      child: Tooltip(
        message: tooltip,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onPressed ?? () {},
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F223D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Icon(icon, size: 20, color: AppColors.gray300),
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF13294B), width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
