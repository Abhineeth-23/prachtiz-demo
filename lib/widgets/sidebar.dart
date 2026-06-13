import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class SidebarItem {
  final String label;
  final IconData icon;
  final String routeName;
  final String? badge;

  SidebarItem({
    required this.label,
    required this.icon,
    required this.routeName,
    this.badge,
  });
}

class SidebarSection {
  final String title;
  final List<SidebarItem> items;

  SidebarSection({
    required this.title,
    required this.items,
  });
}

class AppSidebar extends StatelessWidget {
  final String activeRoute;
  final Function(String) onNavigate;
  final bool isCollapsed;
  final VoidCallback? onToggle;

  AppSidebar({
    required this.activeRoute,
    required this.onNavigate,
    this.isCollapsed = false,
    this.onToggle,
  });

  final List<SidebarSection> sections = [
    SidebarSection(
      title: "Overview",
      items: [
        SidebarItem(label: "Dashboard", icon: Icons.dashboard_outlined, routeName: "/dashboard"),
        SidebarItem(label: "Analytics", icon: Icons.analytics_outlined, routeName: "/analytics"),
        SidebarItem(label: "Patient Overview", icon: Icons.personal_injury_outlined, routeName: "/patient-overview"),
      ],
    ),
    SidebarSection(
      title: "Clinical Services",
      items: [
        SidebarItem(label: "Appointments", icon: Icons.event_note_outlined, routeName: "/appointments", badge: "8"),
        SidebarItem(label: "Health Records", icon: Icons.folder_shared_outlined, routeName: "/health-records"),
        SidebarItem(label: "Prescriptions", icon: Icons.medication_outlined, routeName: "/prescriptions"),
        SidebarItem(label: "Lab Results", icon: Icons.biotech_outlined, routeName: "/lab-results"),
        SidebarItem(label: "Vaccinations", icon: Icons.vaccines_outlined, routeName: "/vaccinations"),
        SidebarItem(label: "Telemedicine", icon: Icons.video_camera_front_outlined, routeName: "/telemedicine"),
        SidebarItem(label: "Consultation", icon: Icons.health_and_safety_outlined, routeName: "/consultation"),
      ],
    ),
    SidebarSection(
      title: "Management",
      items: [
        SidebarItem(label: "Staff", icon: Icons.groups_outlined, routeName: "/staff"),
        SidebarItem(label: "Task Board", icon: Icons.view_kanban_outlined, routeName: "/kanban"),
        SidebarItem(label: "Vitals Monitor", icon: Icons.monitor_heart_outlined, routeName: "/vitals"),
        SidebarItem(label: "Patients List", icon: Icons.people_outline, routeName: "/patients"),
        SidebarItem(label: "Doctor Schedule", icon: Icons.calendar_month_outlined, routeName: "/doctor-schedule"),
      ],
    ),
    SidebarSection(
      title: "Systems & Admin",
      items: [
        SidebarItem(label: "Billing", icon: Icons.receipt_long_outlined, routeName: "/billing"),
        SidebarItem(label: "Invoices", icon: Icons.description_outlined, routeName: "/invoices"),
        SidebarItem(label: "Services", icon: Icons.medical_services_outlined, routeName: "/services"),
        SidebarItem(label: "Settings", icon: Icons.settings_outlined, routeName: "/settings"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double width = isCollapsed ? 70 : 230;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: double.infinity,
      decoration: AppStyles.glassDecoration(
        border: Border(right: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      child: Column(
        children: [
          // Sidebar Header (Logo)
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF6EB744), width: 3)),
            ),
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.medical_services,
                  color: AppColors.accentGreen,
                  size: 28,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 10),
                  Text(
                    "PraCHtiz",
                    style: AppStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ],
            ),
          ),

          // Scrollable Menu List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCollapsed) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0, left: 10.0, bottom: 4.0),
                        child: Text(
                          section.title,
                          style: AppStyles.caption,
                        ),
                      ),
                    ] else ...[
                      const Divider(height: 16, thickness: 0.5, indent: 8, endIndent: 8),
                    ],
                    ...section.items.map((item) {
                      bool isActive = activeRoute == item.routeName;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: AppStyles.radiusSm,
                          child: InkWell(
                            borderRadius: AppStyles.radiusSm,
                            onTap: () => onNavigate(item.routeName),
                            hoverColor: AppColors.accentGreenLight.withOpacity(0.4),
                            child: Container(
                              height: 38,
                              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
                              decoration: isActive
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.accentGreenLight.withOpacity(0.5),
                                          AppColors.accentGreenLight.withOpacity(0.2)
                                        ],
                                      ),
                                      borderRadius: AppStyles.radiusSm,
                                      border: Border.all(
                                        color: AppColors.accentGreen.withOpacity(0.28),
                                      ),
                                    )
                                  : null,
                              child: Row(
                                mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                                children: [
                                  // Leading Icon
                                  Icon(
                                    item.icon,
                                    size: 20,
                                    color: isActive ? AppColors.accentGreen : AppColors.gray500,
                                  ),
                                  if (!isCollapsed) ...[
                                    const SizedBox(width: 12),
                                    // Item Label
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: AppStyles.bodyBase.copyWith(
                                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                          color: isActive ? AppColors.accentGreenDark : AppColors.gray700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Badge (if any)
                                    if (item.badge != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentGreen,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item.badge!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),

          // Sidebar Footer (Collapsible trigger button)
          if (onToggle != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.gray100, width: 1)),
              ),
              child: InkWell(
                onTap: onToggle,
                borderRadius: AppStyles.radiusSm,
                child: Container(
                  height: 38,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCollapsed ? Icons.keyboard_double_arrow_right : Icons.keyboard_double_arrow_left,
                        color: AppColors.gray500,
                        size: 20,
                      ),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 8),
                        Text(
                          "Collapse Menu",
                          style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
