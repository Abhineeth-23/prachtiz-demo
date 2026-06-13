import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class DoctorStatus {
  final String label;
  final Color color;
  final Color hoverColor;

  DoctorStatus({required this.label, required this.color, required this.hoverColor});
}

class AppTopbar extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  final String pageTitle;

  AppTopbar({this.onMenuPressed, required this.pageTitle});

  @override
  State<AppTopbar> createState() => _AppTopbarState();
}

class _AppTopbarState extends State<AppTopbar> {
  String _currentStatus = "Available";
  final Map<String, DoctorStatus> _statuses = {
    "Available": DoctorStatus(label: "Available", color: AppColors.accentGreen, hoverColor: AppColors.accentGreenLight),
    "On-Call": DoctorStatus(label: "On-Call", color: AppColors.accentBlue, hoverColor: AppColors.accentBlueLight),
    "Busy": DoctorStatus(label: "Busy", color: AppColors.accentRed, hoverColor: AppColors.accentRedLight),
    "Offline": DoctorStatus(label: "Offline", color: AppColors.gray400, hoverColor: AppColors.gray100),
  };

  @override
  Widget build(BuildContext context) {
    DoctorStatus status = _statuses[_currentStatus] ?? _statuses["Available"]!;
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.88),
        border: const Border(bottom: BorderSide(color: AppColors.primary, width: 3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF273A91).withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          // Mobile Menu Icon
          if (isMobile) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.gray700),
              onPressed: widget.onMenuPressed,
            ),
            const SizedBox(width: 8),
          ],

          // Page Title
          Text(
            widget.pageTitle,
            style: AppStyles.titleSmall.copyWith(
              color: AppColors.gray800,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          
          if (!isMobile) ...[
            const SizedBox(width: 20),
            // Search Box
            Container(
              width: 200,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.gray50,
                border: Border.all(color: AppColors.gray200, width: 1.5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.search, size: 16, color: AppColors.gray400),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Search patients, files...",
                        hintStyle: TextStyle(color: AppColors.gray400, fontSize: 11),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Stats Ticker (Desktop only)
          if (!isMobile && MediaQuery.of(context).size.width > 1100) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primaryBorder),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Live Pulse: 8 Active Cases",
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.gray800,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Doctor Status Picker
          PopupMenuButton<String>(
            tooltip: "Change Status",
            onSelected: (String newStatus) {
              setState(() {
                _currentStatus = newStatus;
              });
            },
            offset: const Offset(0, 40),
            itemBuilder: (BuildContext context) {
              return _statuses.keys.map((String key) {
                DoctorStatus item = _statuses[key]!;
                return PopupMenuItem<String>(
                  value: key,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Text(item.label, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: status.hoverColor.withOpacity(0.4),
                border: Border.all(color: status.color.withOpacity(0.4), width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: status.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: status.color.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status.label,
                    style: TextStyle(
                      color: status.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.gray500),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // User Profile
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.accentGreen],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "SJ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dr. Sarah Jenkins",
                      style: AppStyles.bodySemibold.copyWith(fontSize: 12),
                    ),
                    Text(
                      "Clinical Director",
                      style: AppStyles.bodySmall.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
