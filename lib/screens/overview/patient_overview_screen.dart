import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class PatientOverviewScreen extends StatefulWidget {
  @override
  State<PatientOverviewScreen> createState() => _PatientOverviewScreenState();
}

class _PatientOverviewScreenState extends State<PatientOverviewScreen> {
  // Mock patients database
  final List<Patient> _patients = [
    Patient(
      id: "PT-0482",
      name: "Marcus Vance",
      age: 67,
      gender: "Male",
      contact: "+1 (555) 019-2834",
      condition: "Acute Coronary Syndrome",
      vitalStatus: VitalStatus.critical,
      dob: "1959-04-12",
      allergies: ["Penicillin", "Sulfa Drugs"],
      vitalsHistory: [
        VitalReading(heartRate: 104, bloodPressure: "148/96", temperature: 37.8, spo2: 91, timestamp: "Just now"),
      ],
    ),
    Patient(
      id: "PT-0913",
      name: "John Doe",
      age: 42,
      gender: "Male",
      contact: "+1 (555) 014-9821",
      condition: "Essential Hypertension",
      vitalStatus: VitalStatus.warning,
      dob: "1884-11-23",
      allergies: ["Peanuts", "Shellfish"],
      vitalsHistory: [
        VitalReading(heartRate: 88, bloodPressure: "135/88", temperature: 36.6, spo2: 97, timestamp: "Just now"),
      ],
    ),
    Patient(
      id: "PT-1204",
      name: "Emily Watson",
      age: 29,
      gender: "Female",
      contact: "+1 (555) 018-4720",
      condition: "Routine Pregnancy check",
      vitalStatus: VitalStatus.normal,
      dob: "1997-08-30",
      allergies: ["Lactose"],
      vitalsHistory: [
        VitalReading(heartRate: 72, bloodPressure: "116/78", temperature: 36.8, spo2: 99, timestamp: "Just now"),
      ],
    ),
    Patient(
      id: "PT-0311",
      name: "Sophia Diaz",
      age: 10,
      gender: "Female",
      contact: "+1 (555) 011-8291",
      condition: "Childhood Asthma",
      vitalStatus: VitalStatus.normal,
      dob: "2016-01-15",
      allergies: ["Dust Mites", "Pollen"],
      vitalsHistory: [
        VitalReading(heartRate: 78, bloodPressure: "105/70", temperature: 36.4, spo2: 98, timestamp: "Just now"),
      ],
    ),
  ];

  late Patient _selectedPatient;

  @override
  void initState() {
    super.initState();
    _selectedPatient = _patients[0];
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    Widget patientsList = ListView.builder(
      shrinkWrap: true,
      physics: isMobile ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final p = _patients[index];
        bool isSelected = p.id == _selectedPatient.id;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBg.withOpacity(0.4) : AppColors.white,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.gray200,
                width: isSelected ? 1.5 : 1.0,
              ),
              borderRadius: AppStyles.radiusMd,
            ),
            child: ListTile(
              onTap: () {
                setState(() {
                  _selectedPatient = p;
                });
              },
              leading: CircleAvatar(
                backgroundColor: _getVitalColor(p.vitalStatus),
                child: Text(
                  p.initials,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              title: Text(p.name, style: AppStyles.bodySemibold.copyWith(fontSize: 13)),
              subtitle: Text(p.condition, style: AppStyles.bodySmall.copyWith(fontSize: 10)),
              trailing: Icon(
                Icons.circle,
                size: 10,
                color: _getVitalColor(p.vitalStatus),
              ),
            ),
          ),
        );
      },
    );

    Widget patientDetails = _buildDetailsPanel(_selectedPatient);

    return isMobile
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Patient", style: AppStyles.titleSmall),
                const SizedBox(height: 8),
                patientsList,
                const SizedBox(height: 20),
                Text("Patient Profile", style: AppStyles.titleSmall),
                const SizedBox(height: 8),
                patientDetails,
              ],
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Patients Directory", style: AppStyles.titleSmall),
                    const SizedBox(height: 10),
                    Expanded(child: patientsList),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: patientDetails,
              ),
            ],
          );
  }

  Color _getVitalColor(VitalStatus status) {
    switch (status) {
      case VitalStatus.normal:
        return AppColors.accentGreen;
      case VitalStatus.warning:
        return AppColors.accentOrange;
      case VitalStatus.critical:
        return AppColors.accentRed;
      case VitalStatus.inactive:
        return AppColors.gray400;
    }
  }

  Widget _buildDetailsPanel(Patient p) {
    VitalReading latestVitals = p.vitalsHistory.isNotEmpty
        ? p.vitalsHistory[0]
        : VitalReading(heartRate: 75, bloodPressure: "120/80", temperature: 36.7, spo2: 98, timestamp: "N/A");

    Color statusColor = _getVitalColor(p.vitalStatus);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: AppStyles.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Demographic header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: statusColor,
                  child: Text(
                    p.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: AppStyles.titleMedium.copyWith(fontSize: 18)),
                      Text("DOB: ${p.dob} (Age: ${p.age} • ${p.gender})", style: AppStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    border: Border.all(color: statusColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p.vitalStatus.name.toUpperCase(),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 9),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Condition & Contact
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CHIEF DIAGNOSIS", style: AppStyles.caption),
                    Text(p.condition, style: AppStyles.bodySemibold.copyWith(color: AppColors.primary)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("CONTACT INFO", style: AppStyles.caption),
                    Text(p.contact, style: AppStyles.bodySemibold),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // Interactive Vitals grid
            Text("LATEST TELEMETRY", style: AppStyles.caption),
            const SizedBox(height: 8),
            LayoutBuilder(builder: (context, constraints) {
              int gridCount = constraints.maxWidth < 450 ? 2 : 4;
              return GridView.count(
                crossAxisCount: gridCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
                children: [
                  _buildVitalCard("HEART RATE", "${latestVitals.heartRate} bpm", Icons.favorite, AppColors.accentRed),
                  _buildVitalCard("BLOOD PRESSURE", latestVitals.bloodPressure, Icons.speed, AppColors.accentBlue),
                  _buildVitalCard("TEMPERATURE", "${latestVitals.temperature}°C", Icons.thermostat, AppColors.accentOrange),
                  _buildVitalCard("SPO2 LEVEL", "${latestVitals.spo2}%", Icons.bloodtype, AppColors.accentTeal),
                ],
              );
            }),

            const SizedBox(height: 20),

            // Allergies
            Text("KNOWN ALLERGIES", style: AppStyles.caption),
            const SizedBox(height: 8),
            p.allergies.isEmpty
                ? Text("No known drug or food allergies.", style: AppStyles.bodySmall)
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.allergies.map((allergy) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentRedLight,
                          border: Border.all(color: AppColors.accentRed.withOpacity(0.35)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          allergy,
                          style: const TextStyle(color: AppColors.accentRed, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: AppStyles.radiusMd,
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppStyles.caption.copyWith(fontSize: 8)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(
            value,
            style: AppStyles.bodySemibold.copyWith(
              fontSize: 14,
              color: AppColors.gray800,
            ),
          ),
        ],
      ),
    );
  }
}
