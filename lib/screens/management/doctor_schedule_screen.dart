import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class ShiftBlock {
  final String day;
  final String time;
  final String department;
  bool isAvailable;

  ShiftBlock({
    required this.day,
    required this.time,
    required this.department,
    this.isAvailable = true,
  });
}

class DoctorScheduleScreen extends StatefulWidget {
  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  final List<ShiftBlock> _schedule = [
    ShiftBlock(day: "Monday", time: "08:00 AM - 01:00 PM", department: "General Medicine"),
    ShiftBlock(day: "Tuesday", time: "08:00 AM - 01:00 PM", department: "General Medicine"),
    ShiftBlock(day: "Wednesday", time: "02:00 PM - 07:00 PM", department: "Cardiology"),
    ShiftBlock(day: "Thursday", time: "08:00 AM - 01:00 PM", department: "General Medicine"),
    ShiftBlock(day: "Friday", time: "02:00 PM - 07:00 PM", department: "Pediatrics"),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Doctor Roster & Shifts Planner", style: AppStyles.titleMedium),
          Text("Manage weekly consulting sessions, hospital rounds, and availability blocks", style: AppStyles.bodySmall),
          const SizedBox(height: 20),

          // Core weekly shifts list
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weekly Duty Roster", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _schedule.length,
                  itemBuilder: (context, index) {
                    final block = _schedule[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: block.isAvailable ? AppColors.white : AppColors.gray50,
                          borderRadius: AppStyles.radiusMd,
                          border: Border.all(color: AppColors.gray200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: block.isAvailable ? AppColors.primaryBg : AppColors.gray100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: block.isAvailable ? AppColors.primary : AppColors.gray400,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(block.day, style: AppStyles.bodySemibold),
                                  Text("${block.time} • ${block.department}", style: AppStyles.bodySmall.copyWith(fontSize: 10)),
                                ],
                              ),
                            ),
                            Switch(
                              value: block.isAvailable,
                              activeColor: AppColors.accentGreen,
                              onChanged: (val) {
                                setState(() {
                                  block.isAvailable = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
