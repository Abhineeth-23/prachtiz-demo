import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class PrescriptionItem {
  final String drugName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String status;

  PrescriptionItem({
    required this.drugName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.status,
  });
}

class PrescriptionsScreen extends StatefulWidget {
  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  final List<PrescriptionItem> _prescriptions = [
    PrescriptionItem(drugName: "Amlodipine Besylate", dosage: "5mg", frequency: "Once daily (Morning)", durationDays: 30, status: "Active"),
    PrescriptionItem(drugName: "Atorvastatin Calcium", dosage: "20mg", frequency: "Once daily (Bedtime)", durationDays: 90, status: "Active"),
    PrescriptionItem(drugName: "Metformin Hydrochloride", dosage: "500mg", frequency: "Twice daily (With meals)", durationDays: 60, status: "Active"),
  ];

  final _drugController = TextEditingController();
  final _dosageController = TextEditingController();
  String _selectedFrequency = "Once daily (Morning)";
  int _selectedDuration = 30;

  @override
  Widget build(BuildContext context) {
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
                  Text("Digital Prescriptions Builder", style: AppStyles.titleMedium),
                  Text("Build, sign, and issue pharmaceutical prescriptions", style: AppStyles.bodySmall),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Create Rx", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusSm),
                ),
                onPressed: () => _showAddPrescriptionDialog(context),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Prescriptions List
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Active Medication Scripts", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(label: Text("DRUG NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("DOSAGE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("FREQUENCY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("DURATION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("STATUS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    rows: _prescriptions.map((rx) {
                      return DataRow(
                        cells: [
                          DataCell(Text(rx.drugName, style: AppStyles.bodySemibold.copyWith(fontSize: 12))),
                          DataCell(Text(rx.dosage, style: AppStyles.bodyBase)),
                          DataCell(Text(rx.frequency, style: AppStyles.bodySmall)),
                          DataCell(Text("${rx.durationDays} Days", style: AppStyles.bodySmall)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accentGreenLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.accentGreen.withOpacity(0.35)),
                              ),
                              child: Text(
                                rx.status,
                                style: const TextStyle(color: AppColors.accentGreenDark, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
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

  void _showAddPrescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusLg),
              title: Text("Issue Digital Prescription", style: AppStyles.titleSmall),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _drugController,
                    decoration: const InputDecoration(
                      labelText: "Medication Name",
                      hintText: "e.g. Amoxicillin",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelText: "Dosage Strength",
                      hintText: "e.g. 500mg",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedFrequency,
                    decoration: const InputDecoration(labelText: "Frequency", border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: "Once daily (Morning)", child: Text("Once daily (Morning)")),
                      DropdownMenuItem(value: "Once daily (Bedtime)", child: Text("Once daily (Bedtime)")),
                      DropdownMenuItem(value: "Twice daily (With meals)", child: Text("Twice daily (With meals)")),
                      DropdownMenuItem(value: "Three times daily", child: Text("Three times daily")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          _selectedFrequency = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _selectedDuration,
                    decoration: const InputDecoration(labelText: "Duration (Days)", border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 7, child: Text("7 Days")),
                      DropdownMenuItem(value: 14, child: Text("14 Days")),
                      DropdownMenuItem(value: 30, child: Text("30 Days")),
                      DropdownMenuItem(value: 60, child: Text("60 Days")),
                      DropdownMenuItem(value: 90, child: Text("90 Days")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          _selectedDuration = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    if (_drugController.text.isNotEmpty && _dosageController.text.isNotEmpty) {
                      setState(() {
                        _prescriptions.add(PrescriptionItem(
                          drugName: _drugController.text,
                          dosage: _dosageController.text,
                          frequency: _selectedFrequency,
                          durationDays: _selectedDuration,
                          status: "Active",
                        ));
                      });
                      _drugController.clear();
                      _dosageController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Issue Rx", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
