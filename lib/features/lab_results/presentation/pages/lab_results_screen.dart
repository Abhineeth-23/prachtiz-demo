import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class LabTestItem {
  final String parameter;
  final String result;
  final String referenceRange;
  final String status; // "Normal", "High", "Low"

  LabTestItem({
    required this.parameter,
    required this.result,
    required this.referenceRange,
    required this.status,
  });
}

class LabResultsScreen extends StatefulWidget {
  @override
  State<LabResultsScreen> createState() => _LabResultsScreenState();
}

class _LabResultsScreenState extends State<LabResultsScreen> {
  final List<Map<String, dynamic>> _reports = [
    {
      "date": "2026-06-01",
      "testName": "Complete Blood Count (CBC)",
      "orderedBy": "Dr. Sarah Jenkins",
      "status": "Ready",
      "results": [
        LabTestItem(parameter: "Hemoglobin", result: "12.8 g/dL", referenceRange: "13.5 - 17.5 g/dL", status: "Low"),
        LabTestItem(parameter: "White Blood Cells (WBC)", result: "7.2 x10^3/uL", referenceRange: "4.5 - 11.0 x10^3/uL", status: "Normal"),
        LabTestItem(parameter: "Platelet Count", result: "245 x10^3/uL", referenceRange: "150 - 450 x10^3/uL", status: "Normal"),
        LabTestItem(parameter: "Red Blood Cells (RBC)", result: "4.2 million/uL", referenceRange: "4.3 - 5.9 million/uL", status: "Low"),
      ]
    },
    {
      "date": "2026-05-15",
      "testName": "Lipid Profile Panel",
      "orderedBy": "Dr. Sarah Jenkins",
      "status": "Ready",
      "results": [
        LabTestItem(parameter: "Total Cholesterol", result: "248 mg/dL", referenceRange: "< 200 mg/dL", status: "High"),
        LabTestItem(parameter: "Triglycerides", result: "165 mg/dL", referenceRange: "< 150 mg/dL", status: "High"),
        LabTestItem(parameter: "HDL Cholesterol", result: "42 mg/dL", referenceRange: "> 40 mg/dL", status: "Normal"),
        LabTestItem(parameter: "LDL Cholesterol", result: "173 mg/dL", referenceRange: "< 100 mg/dL", status: "High"),
      ]
    },
  ];

  late Map<String, dynamic> _selectedReport;

  @override
  void initState() {
    super.initState();
    _selectedReport = _reports[0];
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    Widget reportsList = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        bool isSelected = report['testName'] == _selectedReport['testName'];
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
              title: Text(report['testName'], style: AppStyles.bodySemibold.copyWith(fontSize: 13)),
              subtitle: Text("Ordered on: ${report['date']}", style: AppStyles.bodySmall.copyWith(fontSize: 10)),
              trailing: const Icon(Icons.chevron_right, size: 16, color: AppColors.gray500),
              onTap: () {
                setState(() {
                  _selectedReport = report;
                });
              },
            ),
          ),
        );
      },
    );

    Widget reportDetails = _buildResultsTable(_selectedReport);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Laboratory Diagnostic Reports", style: AppStyles.titleMedium),
          Text("Inspect biochemistry blood panels, cultures, and diagnostic reports", style: AppStyles.bodySmall),
          const SizedBox(height: 20),
          
          isMobile
              ? Column(
                  children: [
                    reportsList,
                    const SizedBox(height: 16),
                    reportDetails,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: reportsList),
                    const SizedBox(width: 20),
                    Expanded(flex: 3, child: reportDetails),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildResultsTable(Map<String, dynamic> report) {
    List<LabTestItem> items = report['results'] as List<LabTestItem>;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report['testName'], style: AppStyles.titleSmall),
                    Text("Attending: ${report['orderedBy']}", style: AppStyles.bodySmall),
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.file_download, size: 14),
                label: const Text("PDF", style: TextStyle(fontSize: 10)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusSm),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const Divider(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              Color statusColor = _getParameterColor(item.status);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.parameter, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
                          Text("Range: ${item.referenceRange}", style: AppStyles.bodySmall.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                    Text(
                      item.result,
                      style: AppStyles.bodySemibold.copyWith(
                        color: statusColor != AppColors.gray800 ? statusColor : null,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Color _getParameterColor(String status) {
    if (status == "Normal") return AppColors.accentGreen;
    if (status == "High") return AppColors.accentRed;
    if (status == "Low") return AppColors.accentOrange;
    return AppColors.gray800;
  }
}
