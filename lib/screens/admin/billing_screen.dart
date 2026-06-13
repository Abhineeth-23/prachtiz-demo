import 'package:flutter/material.dart';
import '../../models/billing.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class BillingScreen extends StatefulWidget {
  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  // Available services catalog
  final List<Map<String, dynamic>> _catalog = [
    {"code": "SRV-01", "name": "General Physician Consultation", "price": 50.0},
    {"code": "SRV-02", "name": "Electrocardiogram (ECG)", "price": 40.0},
    {"code": "SRV-03", "name": "Complete Blood Count (CBC) Panel", "price": 30.0},
    {"code": "SRV-04", "name": "Hepatitis B Vaccine Shot", "price": 25.0},
  ];

  // Active items in the checkout cart
  final List<BillingItem> _cart = [];
  Map<String, dynamic>? _selectedCatalogItem;
  double _discountPercent = 0.0;
  final _patientNameController = TextEditingController(text: "Marcus Vance");

  @override
  void initState() {
    super.initState();
    _selectedCatalogItem = _catalog[0];
  }

  void _addToCart() {
    if (_selectedCatalogItem == null) return;
    
    setState(() {
      String code = _selectedCatalogItem!['code'];
      String name = _selectedCatalogItem!['name'];
      double price = _selectedCatalogItem!['price'];

      // Check if item already exists in cart, increment quantity
      int existingIdx = _cart.indexWhere((item) => item.code == code);
      if (existingIdx != -1) {
        BillingItem current = _cart[existingIdx];
        _cart[existingIdx] = BillingItem(
          code: code,
          description: name,
          unitPrice: price,
          quantity: current.quantity + 1,
        );
      } else {
        _cart.add(BillingItem(
          code: code,
          description: name,
          unitPrice: price,
          quantity: 1,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = _cart.fold(0.0, (sum, item) => sum + item.total);
    double discountAmount = subtotal * (_discountPercent / 100.0);
    double taxAmount = (subtotal - discountAmount) * 0.05;
    double total = (subtotal - discountAmount) + taxAmount;

    bool isMobile = MediaQuery.of(context).size.width <= 768;

    Widget cartSummary = Container(
      padding: const EdgeInsets.all(16.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Checkout Cart Summary", style: AppStyles.titleSmall),
          const Divider(height: 20),
          _cart.isEmpty
              ? const SizedBox(
                  height: 100,
                  child: Center(child: Text("Cart is empty. Add services catalog items.", style: TextStyle(fontSize: 12, color: AppColors.gray400))),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    final item = _cart[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.description, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
                                Text("${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}", style: AppStyles.bodySmall.copyWith(fontSize: 10)),
                              ],
                            ),
                          ),
                          Text("\$${item.total.toStringAsFixed(2)}", style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.accentRed),
                            onPressed: () {
                              setState(() {
                                _cart.removeAt(index);
                              });
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
          const Divider(height: 20),
          // Subtotal, Discount, Tax, Total
          _buildReceiptRow("Subtotal:", "\$${subtotal.toStringAsFixed(2)}"),
          _buildReceiptRow("Discount (${_discountPercent.toInt()}%):", "-\$${discountAmount.toStringAsFixed(2)}"),
          _buildReceiptRow("Tax (5%):", "+\$${taxAmount.toStringAsFixed(2)}"),
          const Divider(height: 16),
          _buildReceiptRow("TOTAL DUE:", "\$${total.toStringAsFixed(2)}", isTotal: true),
          const SizedBox(height: 16),
          // Action button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
              onPressed: _cart.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusLg),
                          title: Row(
                            children: const [
                              Icon(Icons.receipt, color: AppColors.accentGreen),
                              SizedBox(width: 10),
                              Text("Invoice Generated"),
                            ],
                          ),
                          content: Text("Point-of-Sale check-out completed for ${_patientNameController.text}.\nTotal billed: \$${total.toStringAsFixed(2)}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _cart.clear();
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Done"),
                            )
                          ],
                        ),
                      );
                    },
              child: const Text("Generate Bill / Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          )
        ],
      ),
    );

    Widget formBuilder = Container(
      padding: const EdgeInsets.all(16.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("POS Item Entry", style: AppStyles.titleSmall),
          const Divider(height: 20),
          TextField(
            controller: _patientNameController,
            decoration: const InputDecoration(labelText: "Billed Patient Name", border: OutlineInputBorder()),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<Map<String, dynamic>>(
            value: _selectedCatalogItem,
            decoration: const InputDecoration(labelText: "Select Catalog Service", border: OutlineInputBorder()),
            items: _catalog.map((item) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: item,
                child: Text("${item['name']} - \$${item['price']}", style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedCatalogItem = val;
              });
            },
          ),
          const SizedBox(height: 14),
          // Discount slider
          Text("Discount Offer: ${_discountPercent.toInt()}%", style: AppStyles.bodySmall),
          Slider(
            value: _discountPercent,
            min: 0,
            max: 50,
            divisions: 10,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() {
                _discountPercent = val;
              });
            },
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              label: const Text("Add to Cart", style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusSm),
              ),
              onPressed: _addToCart,
            ),
          )
        ],
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("POS Clinical Billing Console", style: AppStyles.titleMedium),
          Text("Configure point-of-sale receipts and print billing invoices", style: AppStyles.bodySmall),
          const SizedBox(height: 20),

          isMobile
              ? Column(
                  children: [
                    formBuilder,
                    const SizedBox(height: 16),
                    cartSummary,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: formBuilder),
                    const SizedBox(width: 16),
                    Expanded(flex: 4, child: cartSummary),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String val, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? AppStyles.bodySemibold.copyWith(fontSize: 14) : AppStyles.bodySmall),
          Text(val, style: isTotal ? AppStyles.bodySemibold.copyWith(fontSize: 15, color: AppColors.primary) : AppStyles.bodySemibold.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
