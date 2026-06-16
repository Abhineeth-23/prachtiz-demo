import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_typography.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final double width;
  final double height;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search patients, ap...',
    this.onChanged,
    this.width = 420.0,
    this.height = 40.0, // Match height of topbar elements in Image 2
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Search patients, files, or clinical options',
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF0F223D),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hintText,
                  hintStyle: AppTypography.body.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
                style: AppTypography.bodySemibold.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Inline Search Badges
            _SearchBadge(
              icon: Icons.calendar_today_outlined,
              value: '12',
              color: const Color(0xFF3B82F6), // Blue
            ),
            _SearchBadge(
              icon: Icons.people_outline,
              value: '8',
              color: const Color(0xFFF59E0B), // Orange
            ),
            _SearchBadge(
              icon: Icons.videocam_outlined,
              value: '2',
              color: const Color(0xFF6366F1), // Indigo
            ),
            _SearchBadge(
              icon: Icons.check_circle_outline,
              value: '6',
              color: const Color(0xFF24C06F), // Green
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _SearchBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
