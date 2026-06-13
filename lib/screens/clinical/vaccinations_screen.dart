import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class VaccineRecord {
  final String name;
  final String date;
  final String batch;
  final String administrator;

  VaccineRecord({
    required this.name,
    required this.date,
    required this.batch,
    required this.administrator,
  });
}

class VaccinationsScreen extends StatefulWidget {
  @override
  State<VaccinationsScreen> createState() => _VaccinationsScreenState();
}

class _VaccinationsScreenState extends State<VaccinationsScreen> {
  final List<VaccineRecord> _history = [
    VaccineRecord(name: "COVID-19 mRNA (Pfizer)", date: "2026-02-15", batch: "PZ-8201", administrator: "Nurse Emily Parker"),
    VaccineRecord(name: "Influenza Seasonal Quadrivalent", date: "2025-11-10", batch: "FL-9932", administrator: "Nurse Emily Parker"),
    VaccineRecord(name: "Tdap (Tetanus, Diphtheria, Pertussis)", date: "2022-04-18", batch: "TD-0481", administrator: "Dr. Sarah Jenkins"),
  ];

  final _vaccineNameController = TextEditingController();
  final _batchController = TextEditingController();

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
                  Text("Immunization & Vaccination Records", style: AppStyles.titleMedium),
                  Text("Register and track patient vaccine administrations and schedules", style: AppStyles.bodySmall),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Record Dose", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusSm),
                ),
                onPressed: () => _showAddVaccineDialog(context),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Vaccine History Card
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Administered Vaccine Doses", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(label: Text("VACCINE NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("DATE ADMINISTERED", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("BATCH NUMBER", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("ADMINISTRATOR", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    rows: _history.map((vac) {
                      return DataRow(
                        cells: [
                          DataCell(Text(vac.name, style: AppStyles.bodySemibold.copyWith(fontSize: 12))),
                          DataCell(Text(vac.date, style: AppStyles.bodyBase)),
                          DataCell(Text(vac.batch, style: AppStyles.bodySmall.copyWith(fontFamily: 'monospace'))),
                          DataCell(Text(vac.administrator, style: AppStyles.bodySmall)),
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upcoming Schedule Card
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Upcoming Due Dates (Schedules)", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                _buildUpcomingRow("Pneumococcal Conjugate (PCV13)", "Due: July 2026 (Age 65+ Routine)", AppColors.accentOrange),
                _buildUpcomingRow("Shingles (Shingrix) Dose 1", "Due: October 2026 (Age 50+ Routine)", AppColors.accentBlue),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUpcomingRow(String name, String scheduleText, Color alertColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: alertColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
                Text(scheduleText, style: AppStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.gray500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: alertColor.withOpacity(0.35)),
            ),
            child: Text(
              "SCHEDULED",
              style: TextStyle(color: alertColor, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void _showAddVaccineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusLg),
          title: Text("Record Vaccine Dose", style: AppStyles.titleSmall),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vaccineNameController,
                decoration: const InputDecoration(
                  labelText: "Vaccine Type/Brand",
                  hintText: "e.g. Hepatitis B (Engerix-B)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _batchController,
                decoration: const InputDecoration(
                  labelText: "Batch / Lot #",
                  hintText: "e.g. HB-7719",
                  border: OutlineInputBorder(),
                ),
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
                if (_vaccineNameController.text.isNotEmpty) {
                  setState(() {
                    _history.add(VaccineRecord(
                      name: _vaccineNameController.text,
                      date: "2026-06-13",
                      batch: _batchController.text.isNotEmpty ? _batchController.text : "N/A",
                      administrator: "Dr. Sarah Jenkins",
                    ));
                  });
                  _vaccineNameController.clear();
                  _batchController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Record", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
