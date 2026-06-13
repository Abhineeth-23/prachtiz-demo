import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class PatientsListScreen extends StatefulWidget {
  final Function(String) onNavigate;

  PatientsListScreen({required this.onNavigate});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  final List<Patient> _allPatients = [
    Patient(id: "PT-0482", name: "Marcus Vance", age: 67, gender: "Male", contact: "+1 (555) 019-2834", condition: "Acute Coronary Syndrome", vitalStatus: VitalStatus.critical, dob: "1959-04-12"),
    Patient(id: "PT-0913", name: "John Doe", age: 42, gender: "Male", contact: "+1 (555) 014-9821", condition: "Essential Hypertension", vitalStatus: VitalStatus.warning, dob: "1884-11-23"),
    Patient(id: "PT-1204", name: "Emily Watson", age: 29, gender: "Female", contact: "+1 (555) 018-4720", condition: "Routine Pregnancy check", vitalStatus: VitalStatus.normal, dob: "1997-08-30"),
    Patient(id: "PT-0311", name: "Sophia Diaz", age: 10, gender: "Female", contact: "+1 (555) 011-8291", condition: "Childhood Asthma", vitalStatus: VitalStatus.normal, dob: "2016-01-15"),
    Patient(id: "PT-1502", name: "Robert Lee", age: 54, gender: "Male", contact: "+1 (555) 017-3810", condition: "Type 2 Diabetes", vitalStatus: VitalStatus.warning, dob: "1972-06-11"),
  ];

  String _searchQuery = "";
  String _genderFilter = "All";
  String? _selectedPatientId;

  @override
  Widget build(BuildContext context) {
    // Perform filtering based on search query and gender select
    List<Patient> filteredPatients = _allPatients.where((p) {
      bool matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.condition.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.id.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesGender = _genderFilter == "All" || p.gender == _genderFilter;
      
      return matchesSearch && matchesGender;
    }).toList();

    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Patient Clinical Register", style: AppStyles.titleMedium),
          Text("Search, review vitals status, and navigate to medical records", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          // Stat boxes
          LayoutBuilder(builder: (context, constraints) {
            int gridCount = constraints.maxWidth < 600 ? 2 : 4;
            return GridView.count(
              crossAxisCount: gridCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.0,
              children: [
                _buildStatTile("Total Patients", "1,248", AppColors.accentBlue),
                _buildStatTile("Critical", "1", AppColors.accentRed),
                _buildStatTile("Warning Alerts", "2", AppColors.accentOrange),
                _buildStatTile("Consulting Today", "18", AppColors.accentGreen),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Table card container
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toolbar
                LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 10),
                        _buildFilterDropdown(),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: _buildSearchBar()),
                      const SizedBox(width: 16),
                      _buildFilterDropdown(),
                    ],
                  );
                }),

                const SizedBox(height: 16),

                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: isMobile ? 18 : 32,
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text("PATIENT ID", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("PATIENT NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("CONTACT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("AGE/GENDER", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("CONDITION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("VITALS STATUS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    rows: filteredPatients.map((p) {
                      bool isSelected = p.id == _selectedPatientId;
                      Color statusColor = _getVitalColor(p.vitalStatus);
                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (val) {
                          setState(() {
                            _selectedPatientId = p.id;
                          });
                          // Navigate to patient overview
                          widget.onNavigate("/patient-overview");
                        },
                        cells: [
                          DataCell(Text(p.id, style: AppStyles.bodySemibold.copyWith(color: AppColors.primary, fontSize: 12))),
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.primaryBg,
                                  child: Text(p.initials, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ),
                                const SizedBox(width: 8),
                                Text(p.name, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                          DataCell(Text(p.contact, style: AppStyles.bodySmall)),
                          DataCell(Text("${p.age} yrs • ${p.gender[0]}", style: AppStyles.bodySmall)),
                          DataCell(Text(p.condition, style: AppStyles.bodySmall)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor.withOpacity(0.35)),
                              ),
                              child: Text(
                                p.vitalStatus.name.toUpperCase(),
                                style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
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

  Widget _buildStatTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: AppStyles.cardDecoration(borderRadius: AppStyles.radiusMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppStyles.bodySmall.copyWith(fontSize: 10)),
          const SizedBox(height: 2),
          Text(value, style: AppStyles.titleMedium.copyWith(fontSize: 18, color: color)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200, width: 1.5),
        borderRadius: AppStyles.radiusMd,
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, size: 18, color: AppColors.gray400),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: const InputDecoration(
                isDense: true,
                hintText: "Search name, id, condition...",
                hintStyle: TextStyle(color: AppColors.gray400, fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200, width: 1.5),
        borderRadius: AppStyles.radiusMd,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _genderFilter,
          onChanged: (String? val) {
            if (val != null) {
              setState(() {
                _genderFilter = val;
              });
            }
          },
          items: const [
            DropdownMenuItem(value: "All", child: Text("Gender: All", style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: "Male", child: Text("Male Only", style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: "Female", child: Text("Female Only", style: TextStyle(fontSize: 12))),
          ],
        ),
      ),
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
}
