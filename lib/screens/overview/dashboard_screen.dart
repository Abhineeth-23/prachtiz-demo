import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class DashboardScreen extends StatefulWidget {
  final Function(String) onNavigate;

  DashboardScreen({required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _currentTime;
  late Timer _clockTimer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppStyles.radiusLg,
              boxShadow: AppStyles.shadowMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good morning, Dr. Jenkins!",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You have 18 appointments scheduled for today. Your first shift starts shortly.",
                        style: AppStyles.bodyBase.copyWith(color: Colors.white.withOpacity(0.9)),
                      ),
                      const SizedBox(height: 16),
                      // Shift info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.25),
                              border: Border.all(color: AppColors.accentGreenBright.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Morning Shift: 08:00 AM - 01:00 PM",
                              style: AppStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 40),
                  // Animated Clock face
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.35), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          _currentTime.second.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            color: AppColors.accentGreenBright,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Main Stats cards
          LayoutBuilder(builder: (context, constraints) {
            int gridCount = constraints.maxWidth < 600 ? 1 : 2;
            return GridView.count(
              crossAxisCount: gridCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3.2,
              children: [
                _buildMainStatCard(
                  title: "Total Registered Patients",
                  value: "1,248",
                  trend: "+12.4% this month",
                  isUp: true,
                  icon: Icons.people_outline,
                  color: AppColors.primary,
                  onTap: () => widget.onNavigate("/patients"),
                ),
                _buildMainStatCard(
                  title: "Consultations Finished Today",
                  value: "10",
                  trend: "Target: 18",
                  isUp: true,
                  icon: Icons.event_note,
                  color: AppColors.accentGreen,
                  onTap: () => widget.onNavigate("/appointments"),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Mini Stats Grid
          Text("Quick Operations Monitor", style: AppStyles.titleSmall),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            int crossCount = constraints.maxWidth < 500
                ? 1
                : constraints.maxWidth < 900
                    ? 2
                    : 3;
            return GridView.count(
              crossAxisCount: crossCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.8,
              children: [
                _buildMiniStatCard("Telehealth Queue", "5", Icons.video_camera_front_outlined, AppColors.accentBlue, "/telemedicine"),
                _buildMiniStatCard("Pending Lab Reports", "12", Icons.biotech_outlined, AppColors.accentOrange, "/lab-results"),
                _buildMiniStatCard("Prescriptions Issued Today", "45", Icons.medication_outlined, AppColors.accentPurple, "/prescriptions"),
                _buildMiniStatCard("Vaccine Inventory", "320", Icons.vaccines_outlined, AppColors.accentTeal, "/vaccinations"),
                _buildMiniStatCard("Outstanding Bills", "3", Icons.receipt_long_outlined, AppColors.accentRed, "/invoices"),
                _buildMiniStatCard("Active Services", "24", Icons.medical_services_outlined, AppColors.accentGreen, "/services"),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Bottom Section (Calendar + Table)
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  _buildCalendarCard(),
                  const SizedBox(height: 20),
                  _buildQueueTable(),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildCalendarCard()),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: _buildQueueTable()),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMainStatCard({
    required String title,
    required String value,
    required String trend,
    required bool isUp,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: AppStyles.cardDecoration(),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppStyles.radiusLg,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: AppStyles.radiusMd,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: AppStyles.bodySmall),
                    const SizedBox(height: 2),
                    Text(value, style: AppStyles.titleMedium.copyWith(fontSize: 20)),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    isUp ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isUp ? AppColors.accentGreen : AppColors.accentRed,
                    size: 16,
                  ),
                  Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isUp ? AppColors.accentGreen : AppColors.accentRed,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatCard(String label, String value, IconData icon, Color color, String route) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: AppStyles.radiusMd,
        boxShadow: AppStyles.shadowSm,
      ),
      child: InkWell(
        onTap: () => widget.onNavigate(route),
        borderRadius: AppStyles.radiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppStyles.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(value, style: AppStyles.titleSmall.copyWith(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("June 2026", style: AppStyles.bodySemibold),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          // Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("S", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
              Text("M", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
              Text("T", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
              Text("W", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
              Text("T", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
              Text("F", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
              Text("S", style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 12),
          // Simple Grid
          Table(
            children: [
              _buildCalendarRow(["31", "1", "2", "3", "4", "5", "6"], currentMonth: false),
              _buildCalendarRow(["7", "8", "9", "10", "11", "12", "13"], currentMonth: true, today: "13"),
              _buildCalendarRow(["14", "15", "16", "17", "18", "19", "20"], currentMonth: true),
              _buildCalendarRow(["21", "22", "23", "24", "25", "26", "27"], currentMonth: true),
              _buildCalendarRow(["28", "29", "30", "1", "2", "3", "4"], currentMonth: false),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildCalendarRow(List<String> days, {bool currentMonth = true, String? today}) {
    return TableRow(
      children: days.map((day) {
        bool isToday = day == today;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            height: 28,
            alignment: Alignment.center,
            decoration: isToday
                ? const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              day,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday
                    ? Colors.white
                    : currentMonth
                        ? AppColors.gray800
                        : AppColors.gray300,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQueueTable() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Appointments Queue", style: AppStyles.titleSmall),
              InkWell(
                onTap: () => widget.onNavigate("/appointments"),
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowHeight: 32,
              dataRowHeight: 46,
              columns: const [
                DataColumn(label: Text("PATIENT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                DataColumn(label: Text("TIME", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                DataColumn(label: Text("TYPE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                DataColumn(label: Text("STATUS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
              ],
              rows: [
                _buildQueueRow("John Doe", "08:30 AM", "Telemedicine", "Pending", AppColors.accentOrange),
                _buildQueueRow("Jane Smith", "09:00 AM", "In-Person", "Checked In", AppColors.accentBlue),
                _buildQueueRow("Robert Lee", "09:30 AM", "Review", "Active", AppColors.accentGreen),
              ],
            ),
          )
        ],
      ),
    );
  }

  DataRow _buildQueueRow(String patient, String time, String type, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primaryBg,
                child: Text(
                  patient[0],
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text(patient, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
            ],
          ),
        ),
        DataCell(Text(time, style: AppStyles.bodySmall)),
        DataCell(Text(type, style: AppStyles.bodySmall)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.35)),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
