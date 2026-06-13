import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  // Active appointment queue list
  final List<Appointment> _queue = [
    Appointment(id: "AP-3011", patientName: "Marcus Vance", doctorName: "Dr. Sarah Jenkins", time: "08:30 AM", date: "2026-06-13", type: "In-Person Consultation", status: AppointmentStatus.checkedIn),
    Appointment(id: "AP-3012", patientName: "Jane Smith", doctorName: "Dr. Sarah Jenkins", time: "09:00 AM", date: "2026-06-13", type: "Telemedicine", status: AppointmentStatus.active),
    Appointment(id: "AP-3013", patientName: "John Doe", doctorName: "Dr. Sarah Jenkins", time: "09:30 AM", date: "2026-06-13", type: "Follow-up Review", status: AppointmentStatus.pending),
    Appointment(id: "AP-3014", patientName: "Clara Jones", doctorName: "Dr. Sarah Jenkins", time: "10:15 AM", date: "2026-06-13", type: "In-Person Consultation", status: AppointmentStatus.pending),
    Appointment(id: "AP-3015", patientName: "David Brown", doctorName: "Dr. Sarah Jenkins", time: "11:00 AM", date: "2026-06-13", type: "Telemedicine", status: AppointmentStatus.pending),
  ];

  final _nameController = TextEditingController();
  String _selectedType = "In-Person Consultation";

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Appointments Scheduler", style: AppStyles.titleMedium),
                  Text("Real-time token management and consulting queue list", style: AppStyles.bodySmall),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Book New", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusSm),
                ),
                onPressed: () => _showAddBookingDialog(context),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Core queue table
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Patient Queue", style: AppStyles.titleSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${_queue.length} Scheduled",
                        style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: isMobile ? 18 : 36,
                    headingRowHeight: 38,
                    columns: const [
                      DataColumn(label: Text("TOKEN ID", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("PATIENT NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("TIME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("SESSION TYPE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("QUEUE STATUS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("ACTIONS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    rows: _queue.map((app) {
                      Color statusColor = _getStatusColor(app.status);
                      return DataRow(
                        cells: [
                          DataCell(Text(app.id, style: AppStyles.bodySemibold.copyWith(color: AppColors.primary, fontSize: 12))),
                          DataCell(Text(app.patientName, style: AppStyles.bodySemibold.copyWith(fontSize: 12))),
                          DataCell(Text(app.time, style: AppStyles.bodySmall)),
                          DataCell(Text(app.type, style: AppStyles.bodySmall)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor.withOpacity(0.35)),
                              ),
                              child: Text(
                                _getStatusText(app.status),
                                style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                if (app.status == AppointmentStatus.checkedIn)
                                  IconButton(
                                    tooltip: "Call Patient In",
                                    icon: const Icon(Icons.play_circle, color: AppColors.accentGreen, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        // Update status of app to active
                                        int index = _queue.indexOf(app);
                                        _queue[index] = app.copyWith(status: AppointmentStatus.active);
                                      });
                                    },
                                  ),
                                if (app.status == AppointmentStatus.active)
                                  IconButton(
                                    tooltip: "Complete Session",
                                    icon: const Icon(Icons.check_circle, color: AppColors.accentBlue, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        int index = _queue.indexOf(app);
                                        _queue[index] = app.copyWith(status: AppointmentStatus.completed);
                                      });
                                    },
                                  ),
                                IconButton(
                                  tooltip: "Remove / Cancel",
                                  icon: const Icon(Icons.cancel_outlined, color: AppColors.accentRed, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _queue.remove(app);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return AppColors.accentOrange;
      case AppointmentStatus.active:
        return AppColors.accentGreen;
      case AppointmentStatus.checkedIn:
        return AppColors.accentBlue;
      case AppointmentStatus.completed:
        return AppColors.gray400;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return "Waiting";
      case AppointmentStatus.active:
        return "In Consulting Room";
      case AppointmentStatus.checkedIn:
        return "Checked-In";
      case AppointmentStatus.completed:
        return "Completed";
    }
  }

  void _showAddBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusLg),
              title: Text("Book Clinic Appointment", style: AppStyles.titleSmall),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Patient Full Name",
                      hintText: "Enter name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: "Consultation Type",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "In-Person Consultation", child: Text("In-Person Consultation")),
                      DropdownMenuItem(value: "Telemedicine", child: Text("Telemedicine")),
                      DropdownMenuItem(value: "Follow-up Review", child: Text("Follow-up Review")),
                    ],
                    onChanged: (String? val) {
                      if (val != null) {
                        setDialogState(() {
                          _selectedType = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      setState(() {
                        String newId = "AP-${3000 + _queue.length + 12}";
                        _queue.add(Appointment(
                          id: newId,
                          patientName: _nameController.text,
                          doctorName: "Dr. Sarah Jenkins",
                          time: "11:30 AM",
                          date: "2026-06-13",
                          type: _selectedType,
                          status: AppointmentStatus.pending,
                        ));
                      });
                      _nameController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Book Token", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
