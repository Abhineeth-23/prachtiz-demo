import 'package:flutter/material.dart';
import '../../models/billing.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class InvoicesScreen extends StatefulWidget {
  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final List<Invoice> _invoices = [
    Invoice(
      id: "INV-1092",
      patientName: "Marcus Vance",
      date: "2026-06-12",
      status: InvoiceStatus.paid,
      items: [
        BillingItem(code: "SRV-01", description: "General Physician Consultation", unitPrice: 50.0, quantity: 1),
        BillingItem(code: "SRV-02", description: "Electrocardiogram (ECG)", unitPrice: 40.0, quantity: 1),
      ],
      discount: 10,
    ),
    Invoice(
      id: "INV-1093",
      patientName: "Emily Watson",
      date: "2026-06-11",
      status: InvoiceStatus.pending,
      items: [
        BillingItem(code: "SRV-01", description: "General Physician Consultation", unitPrice: 50.0, quantity: 1),
      ],
    ),
    Invoice(
      id: "INV-1094",
      patientName: "John Doe",
      date: "2026-06-05",
      status: InvoiceStatus.overdue,
      items: [
        BillingItem(code: "SRV-01", description: "General Physician Consultation", unitPrice: 50.0, quantity: 1),
        BillingItem(code: "SRV-03", description: "Complete Blood Count (CBC) Panel", unitPrice: 30.0, quantity: 2),
      ],
    ),
  ];

  String _filterStatus = "All";

  @override
  Widget build(BuildContext context) {
    List<Invoice> filteredInvoices = _filterStatus == "All"
        ? _invoices
        : _invoices.where((inv) => inv.status.name == _filterStatus.toLowerCase()).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Invoices Registry", style: AppStyles.titleMedium),
          Text("Track payment histories, outstanding balances, and receipt status codes", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          // Filters Choice Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Paid", "Pending", "Overdue"].map((status) {
                bool isSelected = _filterStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(status, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.gray700)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.white,
                    onSelected: (val) {
                      setState(() {
                        _filterStatus = status;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Invoices Table
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppStyles.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Issued Invoices Ledger", style: AppStyles.titleSmall),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 36,
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text("INVOICE ID", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("PATIENT NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("DATE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("TOTAL AMOUNT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("STATUS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    rows: filteredInvoices.map((inv) {
                      Color statusColor = _getStatusColor(inv.status);
                      return DataRow(
                        onSelectChanged: (val) {
                          _showInvoiceDetailDialog(context, inv);
                        },
                        cells: [
                          DataCell(Text(inv.id, style: AppStyles.bodySemibold.copyWith(color: AppColors.primary, fontSize: 12))),
                          DataCell(Text(inv.patientName, style: AppStyles.bodySemibold.copyWith(fontSize: 12))),
                          DataCell(Text(inv.date, style: AppStyles.bodySmall)),
                          DataCell(Text("\$${inv.total.toStringAsFixed(2)}", style: AppStyles.bodySemibold.copyWith(fontSize: 12))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor.withOpacity(0.35)),
                              ),
                              child: Text(
                                inv.status.name.toUpperCase(),
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

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return AppColors.accentGreen;
      case InvoiceStatus.pending:
        return AppColors.accentOrange;
      case InvoiceStatus.unpaid:
        return AppColors.accentBlue;
      case InvoiceStatus.overdue:
        return AppColors.accentRed;
    }
  }

  void _showInvoiceDetailDialog(BuildContext context, Invoice inv) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusLg),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Invoice Details - ${inv.id}", style: AppStyles.titleSmall),
              IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
            ],
          ),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Patient: ${inv.patientName}", style: AppStyles.bodySemibold),
                Text("Billing Date: ${inv.date}", style: AppStyles.bodySmall),
                const Divider(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: inv.items.length,
                  itemBuilder: (context, index) {
                    final item = inv.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text("${item.quantity} x ${item.description}", style: AppStyles.bodySmall)),
                          Text("\$${item.total.toStringAsFixed(2)}", style: AppStyles.bodyBase),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 20),
                _buildModalRow("Subtotal:", "\$${inv.subtotal.toStringAsFixed(2)}"),
                _buildModalRow("Discount Offer:", "-\$${inv.discountAmount.toStringAsFixed(2)}"),
                _buildModalRow("Tax Rate (5%):", "+\$${inv.taxAmount.toStringAsFixed(2)}"),
                const Divider(height: 12),
                _buildModalRow("TOTAL:", "\$${inv.total.toStringAsFixed(2)}", isTotal: true),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.print, size: 16),
              label: const Text("Print Receipt", style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        );
      },
    );
  }

  Widget _buildModalRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppStyles.bodySemibold.copyWith(fontSize: 13) : AppStyles.bodySmall),
        Text(value, style: isTotal ? AppStyles.bodySemibold.copyWith(fontSize: 14, color: AppColors.primary) : AppStyles.bodySemibold.copyWith(fontSize: 11)),
      ],
    );
  }
}
