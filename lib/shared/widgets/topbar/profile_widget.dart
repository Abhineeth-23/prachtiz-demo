import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../app_avatar.dart';

class ProfileWidget extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  final VoidCallback? onTap;

  const ProfileWidget({
    super.key,
    required this.initials,
    required this.name,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool showName = screenWidth > 950;

    return Semantics(
      button: true,
      label: "Profile options for $name, $role",
      child: Tooltip(
        message: "View profile settings",
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAvatar(
                  initials: initials,
                  radius: 18.0,
                  backgroundColor: const Color(0xFF24C06F)
                      .withOpacity(0.15), // Brand green tint
                  textColor: const Color(0xFF24C06F), // Brand green text
                  semanticLabel: "Doctor profile avatar initials $initials",
                ),
                if (showName) ...[
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.bodySemibold.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        role,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 16, color: AppColors.gray400),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
