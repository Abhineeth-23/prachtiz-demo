import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class StaffMember {
  final String name;
  final String role;
  final String department;
  final String email;
  final String status; // "Active", "Away", "Offline"

  StaffMember({
    required this.name,
    required this.role,
    required this.department,
    required this.email,
    required this.status,
  });
}

class StaffScreen extends StatefulWidget {
  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final List<StaffMember> _staff = [
    StaffMember(name: "Dr. Sarah Jenkins", role: "Clinical Director", department: "General Medicine", email: "s.jenkins@prachtiz.com", status: "Active"),
    StaffMember(name: "Dr. Michael Chen", role: "Sr. Cardiologist", department: "Cardiology", email: "m.chen@prachtiz.com", status: "Active"),
    StaffMember(name: "Dr. Amanda Ross", role: "Pediatrician", department: "Pediatrics", email: "a.ross@prachtiz.com", status: "Away"),
    StaffMember(name: "Nurse Emily Parker", role: "Head Nurse", department: "Nursing", email: "e.parker@prachtiz.com", status: "Active"),
    StaffMember(name: "Nurse John Smith", role: "Staff Nurse", department: "Nursing", email: "j.smith@prachtiz.com", status: "Offline"),
  ];

  String _activeTab = "All";

  @override
  Widget build(BuildContext context) {
    List<StaffMember> filteredStaff = _activeTab == "All"
        ? _staff
        : _staff.where((s) => s.department == _activeTab || (s.department == "Nursing" && _activeTab == "Nursing")).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Staff & Practitioner Directory", style: AppStyles.titleMedium),
          Text("Manage active physicians, nursing staff, and administrative rosters", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          // Department selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "General Medicine", "Cardiology", "Nursing"].map((dept) {
                bool isSelected = _activeTab == dept;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(dept, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.gray700)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.white,
                    onSelected: (val) {
                      setState(() {
                        _activeTab = dept;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Staff grid
          LayoutBuilder(builder: (context, constraints) {
            int count = constraints.maxWidth < 600 ? 1 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.6,
              ),
              itemCount: filteredStaff.length,
              itemBuilder: (context, index) {
                final member = filteredStaff[index];
                Color statusColor = _getStatusColor(member.status);
                return Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: AppStyles.cardDecoration(),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryBg,
                        child: Text(
                          member.name.split(' ').last[0],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(member.name, style: AppStyles.bodySemibold),
                            Text("${member.role} • ${member.department}", style: AppStyles.bodySmall.copyWith(fontSize: 10)),
                            const SizedBox(height: 4),
                            Text(member.email, style: TextStyle(fontSize: 10, color: AppColors.primary.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == "Active") return AppColors.accentGreen;
    if (status == "Away") return AppColors.accentOrange;
    return AppColors.gray400;
  }
}
