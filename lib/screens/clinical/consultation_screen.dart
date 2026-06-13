import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class ConsultationScreen extends StatefulWidget {
  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _subjectiveController = TextEditingController(text: "Patient complains of chest tightness, recurring headache, and fatigue. No dizziness or palpitations reported.");
  final _objectiveController = TextEditingController(text: "Vitals: BP: 142/96, HR: 104 bpm, Temp: 37.8°C, SpO2: 91%. Lungs clear to auscultation. S1/S2 heard normally.");
  final _assessmentController = TextEditingController(text: "Essential Hypertension; suspected Acute Coronary Syndrome (ACS) risk due to chest discomfort.");
  final _planController = TextEditingController(text: "Refer to cardiologist immediately for ECG/Echo. Rx: Amlodipine 5mg QD. Avoid strenuous activity.");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Soap Consultation Notes", style: AppStyles.titleMedium),
          Text("Document clinical assessments, symptoms, diagnoses, and medical advice", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          // Active Patient Box
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: AppStyles.cardDecoration(color: AppColors.primaryBg.withOpacity(0.3)),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.rate_review_outlined, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Active Session: Marcus Vance (ACS Case)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("Scheduled Slot: 08:30 AM Consultation", style: TextStyle(fontSize: 10, color: AppColors.gray500)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SOAP fields
          _buildSoapField("SUBJECTIVE (Symptoms & Patient History)", _subjectiveController),
          _buildSoapField("OBJECTIVE (Vitals, Lab Findings & Physical Exams)", _objectiveController),
          _buildSoapField("ASSESSMENT (Diagnoses & EMR Codes)", _assessmentController),
          _buildSoapField("PLAN (Rx Prescriptions, Referrals & Follow-ups)", _planController),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Discard"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.check, size: 16),
                label: const Text("File Session Note", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusSm),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusLg),
                      title: Row(
                        children: const [
                          Icon(Icons.check_circle, color: AppColors.accentGreen),
                          SizedBox(width: 10),
                          Text("Consultation Logged"),
                        ],
                      ),
                      content: const Text("The SOAP consultation record has been signed and filed into the patient's EMR successfully."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSoapField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: AppStyles.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppStyles.caption.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 3,
              style: AppStyles.bodyBase.copyWith(fontSize: 12),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
