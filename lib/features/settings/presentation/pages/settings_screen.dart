import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _clinicNameController = TextEditingController(text: "PraCHtiz Medical Center");
  final _emailController = TextEditingController(text: "contact@prachtiz.com");
  final _phoneController = TextEditingController(text: "+1 (555) 018-9900");
  final _addressController = TextEditingController(text: "120 Medical Plaza, Suite 400, New York, NY");

  bool _enableSmsAlerts = true;
  bool _enableEmailReports = false;

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
                  Text("System Settings & Config", style: AppStyles.titleMedium),
                  Text("Configure practice profile metrics, notification triggers, and clinic details", style: AppStyles.bodySmall),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: const Text("Save System Settings", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                          Text("Settings Configured"),
                        ],
                      ),
                      content: const Text("Clinic configurations and security preferences saved successfully."),
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
          ),
          const SizedBox(height: 20),

          // Clinic profile form
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Practice Profile Profile", style: AppStyles.titleSmall),
                const Divider(height: 20),
                _buildFormField("Practice Clinic Name", _clinicNameController),
                const SizedBox(height: 12),
                _buildFormField("Support / Billing Email", _emailController),
                const SizedBox(height: 12),
                _buildFormField("Clinic Landline Contact", _phoneController),
                const SizedBox(height: 12),
                _buildFormField("Physical Address Location", _addressController),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Alerts and triggers
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Automated Notification Rules", style: AppStyles.titleSmall),
                const Divider(height: 20),
                SwitchListTile(
                  title: const Text("Enable Patient SMS Reminders", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: const Text("Send automated text warnings 1 hour prior to appointment booking schedule.", style: TextStyle(fontSize: 10, color: AppColors.gray500)),
                  value: _enableSmsAlerts,
                  activeColor: AppColors.accentGreen,
                  onChanged: (val) {
                    setState(() {
                      _enableSmsAlerts = val;
                    });
                  },
                ),
                const Divider(height: 10),
                SwitchListTile(
                  title: const Text("Daily Revenue Email Digests", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: const Text("Send automated summaries of point-of-sale checkouts and invoices to accounting.", style: TextStyle(fontSize: 10, color: AppColors.gray500)),
                  value: _enableEmailReports,
                  activeColor: AppColors.accentGreen,
                  onChanged: (val) {
                    setState(() {
                      _enableEmailReports = val;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.caption.copyWith(color: AppColors.primary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(10)),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
