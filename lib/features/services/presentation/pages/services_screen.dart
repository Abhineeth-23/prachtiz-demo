import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class ServicePriceItem {
  final String code;
  final String name;
  double price;

  ServicePriceItem({
    required this.code,
    required this.name,
    required this.price,
  });
}

class ServicesScreen extends StatefulWidget {
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<ServicePriceItem> _services = [
    ServicePriceItem(code: "SRV-01", name: "General Physician Consultation", price: 50.0),
    ServicePriceItem(code: "SRV-02", name: "Electrocardiogram (ECG) Test", price: 40.0),
    ServicePriceItem(code: "SRV-03", name: "Complete Blood Count (CBC) Panel", price: 30.0),
    ServicePriceItem(code: "SRV-04", name: "Hepatitis B Vaccine Dose", price: 25.0),
    ServicePriceItem(code: "SRV-05", name: "Telemedicine Video Consultation", price: 45.0),
  ];

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
                  Text("Clinical Services & Tariffs", style: AppStyles.titleMedium),
                  Text("Update and manage clinic consulting fees and lab diagnostic prices", style: AppStyles.bodySmall),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, size: 16),
                label: const Text("Save Tariffs", style: TextStyle(fontSize: 12)),
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
                          Text("Tariffs Saved"),
                        ],
                      ),
                      content: const Text("Clinic service list pricing codes and diagnostic rates updated successfully."),
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

          // Catalog list
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tariffs Configuration List", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 36,
                    columns: const [
                      DataColumn(label: Text("SERVICE CODE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("SERVICE DESCRIPTION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("BASE TARIFF (USD)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("EDIT PRICE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    rows: _services.map((srv) {
                      return DataRow(
                        cells: [
                          DataCell(Text(srv.code, style: AppStyles.bodySemibold.copyWith(color: AppColors.primary, fontSize: 12))),
                          DataCell(Text(srv.name, style: AppStyles.bodySemibold.copyWith(fontSize: 12))),
                          DataCell(Text("\$${srv.price.toStringAsFixed(2)}", style: AppStyles.bodyBase)),
                          DataCell(
                            SizedBox(
                              width: 80,
                              height: 30,
                              child: TextField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  prefixText: "\$",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                ),
                                style: const TextStyle(fontSize: 12),
                                controller: TextEditingController(text: srv.price.toStringAsFixed(0)),
                                onSubmitted: (val) {
                                  double? parsed = double.tryParse(val);
                                  if (parsed != null) {
                                    setState(() {
                                      srv.price = parsed;
                                    });
                                  }
                                },
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
}
