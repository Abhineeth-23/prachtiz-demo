import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class HealthRecordsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _records = [
    {
      "date": "2026-05-10",
      "doctor": "Dr. Sarah Jenkins",
      "reason": "Chronic Headache & Hypertension Review",
      "vitals": "BP: 142/90, HR: 84 bpm, Temp: 37.0°C",
      "notes": "Patient reports mild relief after taking amlodipine daily. Complaining of evening headaches. Recommended lifestyle modifications and scheduled follow-up."
    },
    {
      "date": "2026-03-15",
      "doctor": "Dr. Michael Chen (Cardiologist)",
      "reason": "Annual Cardiac Checkup",
      "vitals": "BP: 135/82, HR: 72 bpm, Temp: 36.8°C",
      "notes": "ECG shows normal sinus rhythm. Left ventricular function preserved. Advised to continue current low-sodium diet regime."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Health Records Archive", style: AppStyles.titleMedium),
          Text("Complete medical checkup history and uploaded attachments", style: AppStyles.bodySmall),
          const SizedBox(height: 20),

          // Active Patient Box
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppStyles.cardDecoration(color: AppColors.primaryBg.withOpacity(0.3)),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.folder, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Currently Viewing: Marcus Vance (PT-0482)", style: AppStyles.bodySemibold),
                      Text("Chief Condition: Acute Coronary Syndrome", style: AppStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Timeline logs
          Text("Checkup Timeline Logs", style: AppStyles.titleSmall),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _records.length,
            itemBuilder: (context, index) {
              final record = _records[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: AppStyles.cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date: ${record['date']}", style: AppStyles.bodySemibold.copyWith(color: AppColors.primary)),
                          Text(record['doctor'], style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("REASON FOR CONSULTATION:", style: AppStyles.caption),
                      Text(record['reason'], style: AppStyles.bodySemibold),
                      const SizedBox(height: 8),
                      Text("VITAL READING SNAPSHOT:", style: AppStyles.caption),
                      Text(record['vitals'], style: AppStyles.bodyBase),
                      const SizedBox(height: 8),
                      Text("CLINICAL NOTES / RECOMMENDATION:", style: AppStyles.caption),
                      Text(record['notes'], style: AppStyles.bodySmall),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Mock Document panel
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Diagnostic Attachments", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                _buildAttachmentRow("Cardio_ECG_Report_05_26.pdf", "PDF Document", "2.4 MB"),
                _buildAttachmentRow("Chest_XRay_Digital_View.jpg", "Image Scan", "12.8 MB"),
                _buildAttachmentRow("Biochemical_Blood_Panel.pdf", "PDF Document", "1.1 MB"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentRow(String filename, String type, String size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: AppColors.gray500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
                Text("$type • $size", style: AppStyles.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, color: AppColors.primary, size: 18),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.accentGreen, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
