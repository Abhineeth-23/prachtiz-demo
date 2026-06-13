import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Practice Performance Analytics", style: AppStyles.titleMedium),
          Text("Statistical analysis of clinical caseloads and patient engagement", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          // Core Metric Row
          LayoutBuilder(builder: (context, constraints) {
            int gridCount = constraints.maxWidth < 600 ? 2 : 4;
            return GridView.count(
              crossAxisCount: gridCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _buildMetricCard("Daily Intake", "48", "+18%", true, AppColors.accentBlue),
                _buildMetricCard("Telemedicine Ratio", "42%", "+5%", true, AppColors.accentPurple),
                _buildMetricCard("Avg Wait Time", "14 min", "-8%", false, AppColors.accentGreen),
                _buildMetricCard("Rx Fill Rate", "94.8%", "+1.2%", true, AppColors.accentTeal),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Charts Container (Responsive Row)
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  _buildBarChartCard("Weekly Patient Volumes"),
                  const SizedBox(height: 16),
                  _buildPieChartCard("Department Allocation"),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildBarChartCard("Weekly Patient Volumes")),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildPieChartCard("Department Allocation")),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Performance Breakdown List
          _buildPerformanceBreakdownCard(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change, bool isPositive, Color color) {
    Color indicatorColor = isPositive ? AppColors.accentGreen : AppColors.accentRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppStyles.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: AppStyles.titleMedium.copyWith(fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: indicatorColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: indicatorColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(String title) {
    final List<double> values = [30, 45, 38, 60, 52, 40, 25];
    final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.titleSmall),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                double heightPercent = values[index] / 70.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 20,
                      height: 130 * heightPercent,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight.withOpacity(0.6)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(days[index], style: AppStyles.bodySmall.copyWith(fontSize: 10)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard(String title) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.titleSmall),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Beautiful Circular Indicator Ring representing the pie segments
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.45,
                      strokeWidth: 16,
                      backgroundColor: AppColors.accentBlueLight,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: 0.3,
                      strokeWidth: 10,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("186", style: AppStyles.bodySemibold.copyWith(fontSize: 16)),
                      Text("Total cases", style: AppStyles.bodySmall.copyWith(fontSize: 8)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Column(
            children: [
              _buildLegendItem("General Consult", "45%", AppColors.primary),
              _buildLegendItem("Pediatrics", "30%", AppColors.accentGreen),
              _buildLegendItem("Cardiology/Others", "25%", AppColors.accentBlue),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppStyles.bodySmall.copyWith(fontSize: 10))),
          Text(value, style: AppStyles.bodySemibold.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildPerformanceBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hourly Clinical Load Breakdown", style: AppStyles.titleSmall),
          const SizedBox(height: 12),
          _buildBreakdownRow("08:00 AM - 10:00 AM", 0.85, "High (Rush Hour)", AppColors.accentRed),
          _buildBreakdownRow("10:00 AM - 12:00 PM", 0.60, "Moderate", AppColors.accentOrange),
          _buildBreakdownRow("12:00 PM - 02:00 PM", 0.25, "Low (Midday)", AppColors.accentGreen),
          _buildBreakdownRow("02:00 PM - 05:00 PM", 0.70, "High", AppColors.accentRed),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String hourRange, double loading, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hourRange, style: AppStyles.bodySemibold.copyWith(fontSize: 12)),
              Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: loading,
              minHeight: 8,
              backgroundColor: AppColors.gray100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          )
        ],
      ),
    );
  }
}
