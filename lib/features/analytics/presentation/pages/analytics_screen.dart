import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';

const _kPanelBg = Color(0xFF0F172A);
const _kPanelAlt = Color(0xFF111C33);
const _kPanelBorder = Color(0xFF1E293B);
const _kBrandBlue = Color(0xFF315BFF);
const _kBrandGreen = Color(0xFF24C06F);
const _kMuted = Color(0xFF94A3B8);

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1180;
    final isTablet = width >= 760 && width < 1180;
    final pagePadding = width < 700 ? 16.0 : AppDimensions.pagePaddingHorizontal;
    final gap = width < 700 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: pagePadding,
          vertical: AppDimensions.pagePaddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalyticsHeader(isCompact: width < 760)
                .animate()
                .fadeIn(duration: 360.ms)
                .slideY(begin: -0.04, end: 0, curve: Curves.easeOutCubic),
            SizedBox(height: gap),
            _MetricGrid(columns: isDesktop ? 4 : (isTablet ? 2 : 1))
                .animate()
                .fadeIn(delay: 90.ms, duration: 380.ms)
                .slideY(begin: 0.04, end: 0, curve: Curves.easeOutCubic),
            SizedBox(height: gap),
            if (isDesktop)
              SizedBox(
                height: 440,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 7, child: _PatientVolumeCard())
                        .animate()
                        .fadeIn(delay: 160.ms, duration: 380.ms)
                        .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                    SizedBox(width: gap),
                    const Expanded(flex: 5, child: _ChannelMixCard())
                        .animate()
                        .fadeIn(delay: 180.ms, duration: 380.ms)
                        .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              )
            else
              Column(
                children: [
                  const _PatientVolumeCard()
                      .animate()
                      .fadeIn(delay: 160.ms, duration: 380.ms)
                      .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                  SizedBox(height: gap),
                  const _ChannelMixCard()
                      .animate()
                      .fadeIn(delay: 180.ms, duration: 380.ms)
                      .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            SizedBox(height: gap),
            if (isDesktop)
              SizedBox(
                height: 330,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 6, child: _HourlyLoadCard())
                        .animate()
                        .fadeIn(delay: 220.ms, duration: 380.ms)
                        .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                    SizedBox(width: gap),
                    const Expanded(flex: 6, child: _PartnerPerformanceCard())
                        .animate()
                        .fadeIn(delay: 240.ms, duration: 380.ms)
                        .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              )
            else
              Column(
                children: [
                  const _HourlyLoadCard()
                      .animate()
                      .fadeIn(delay: 220.ms, duration: 380.ms)
                      .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                  SizedBox(height: gap),
                  const _PartnerPerformanceCard()
                      .animate()
                      .fadeIn(delay: 240.ms, duration: 380.ms)
                      .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsHeader extends StatelessWidget {
  final bool isCompact;

  const _AnalyticsHeader({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFF13294B),
      borderRadius: AppRadius.radius18,
      border: Border.all(color: Colors.white.withOpacity(0.08)),
      padding: EdgeInsets.all(isCompact ? 18 : 24),
      child: Wrap(
        spacing: 18,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: isCompact ? double.infinity : 520,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Practice Analytics',
                  style: AppTypography.sectionTitle.copyWith(
                    color: Colors.white,
                    fontSize: isCompact ? 22 : 26,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Clinical throughput, consultation quality, payer mix, and operational load for 16 June 2026.',
                  style: AppTypography.body.copyWith(
                    color: _kMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _HeaderPill(icon: Icons.calendar_today_outlined, label: 'Today'),
              _HeaderPill(icon: Icons.location_on_outlined, label: 'Hyderabad'),
              _HeaderPill(icon: Icons.verified_outlined, label: 'Live data'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _kBrandGreen),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.bodySemibold.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final int columns;

  const _MetricGrid({required this.columns});

  @override
  Widget build(BuildContext context) {
    final metrics = const [
      _MetricData(
          'Daily Intake', '48', '+18%', Icons.groups_outlined, _kBrandBlue),
      _MetricData('Telemedicine', '42%', '+5%', Icons.videocam_outlined,
          Color(0xFF0EA5E9)),
      _MetricData(
          'Avg Wait Time', '14m', '-8%', Icons.timer_outlined, _kBrandGreen),
      _MetricData('Rx Fill Rate', '94.8%', '+1.2%', Icons.medication_outlined,
          Color(0xFFF59E0B)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * 16)) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: itemWidth,
                child: _MetricCard(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _MetricData(this.label, this.value, this.change, this.icon, this.color);
}

class _MetricCard extends StatefulWidget {
  final _MetricData metric;

  const _MetricCard({required this.metric});

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final positive = !widget.metric.change.startsWith('-');
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 138,
        padding: const EdgeInsets.all(18),
        transform: Matrix4.identity()..translate(0.0, _hovered ? -3.0 : 0.0),
        decoration: BoxDecoration(
          color: _kPanelBg,
          borderRadius: AppRadius.radius18,
          border: Border.all(
            color: _hovered
                ? widget.metric.color.withOpacity(0.36)
                : Colors.white.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.18 : 0.1),
              blurRadius: _hovered ? 16 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: widget.metric.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.metric.icon,
                      color: widget.metric.color, size: 20),
                ),
                const Spacer(),
                _ChangeBadge(value: widget.metric.change, positive: positive),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.metric.value,
                  style: AppTypography.cardValue
                      .copyWith(color: Colors.white, fontSize: 32),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.metric.label,
                  style:
                      AppTypography.body.copyWith(color: _kMuted, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final String value;
  final bool positive;

  const _ChangeBadge({required this.value, required this.positive});

  @override
  Widget build(BuildContext context) {
    final color = positive ? _kBrandGreen : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.24)),
      ),
      child: Text(
        value,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _PatientVolumeCard extends StatelessWidget {
  const _PatientVolumeCard();

  @override
  Widget build(BuildContext context) {
    return _ChartPanel(
      title: 'Weekly Patient Volume',
      subtitle: 'Consultations by day and care channel',
      child: BarChart(
        BarChartData(
          maxY: 72,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: _kPanelBorder, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  final index = value.toInt();
                  if (index < 0 || index >= days.length)
                    return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(days[index],
                        style: AppTypography.caption.copyWith(color: _kMuted)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            _bar(0, 42, 15),
            _bar(1, 58, 22),
            _bar(2, 46, 18),
            _bar(3, 63, 27),
            _bar(4, 51, 20),
            _bar(5, 38, 14),
            _bar(6, 28, 10),
          ],
        ),
      ),
      footer: const Wrap(
        spacing: 14,
        runSpacing: 8,
        children: [
          _LegendDot(label: 'Clinic', color: _kBrandBlue),
          _LegendDot(label: 'Telemedicine', color: _kBrandGreen),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double clinic, double virtual) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: clinic,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          color: _kBrandBlue,
        ),
        BarChartRodData(
          toY: virtual,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          color: _kBrandGreen,
        ),
      ],
    );
  }
}

class _ChannelMixCard extends StatelessWidget {
  const _ChannelMixCard();

  @override
  Widget build(BuildContext context) {
    return _ChartPanel(
      title: 'Care Channel Mix',
      subtitle: 'Distribution across appointment sources',
      child: Align(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 54,
              sectionsSpace: 3,
              sections: [
                PieChartSectionData(
                    value: 38, color: _kBrandBlue, radius: 42, showTitle: false),
                PieChartSectionData(
                    value: 26, color: _kBrandGreen, radius: 42, showTitle: false),
                PieChartSectionData(
                    value: 21,
                    color: const Color(0xFF0EA5E9),
                    radius: 42,
                    showTitle: false),
                PieChartSectionData(
                    value: 15,
                    color: const Color(0xFFF59E0B),
                    radius: 42,
                    showTitle: false),
              ],
            ),
          ),
        ),
      ),
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('186',
              style: AppTypography.cardValue
                  .copyWith(color: Colors.white, fontSize: 28)),
          Text('cases', style: AppTypography.caption.copyWith(color: _kMuted)),
        ],
      ),
      footer: const Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _LegendDot(label: 'CH', color: _kBrandGreen),
          _LegendDot(label: 'SBI', color: _kBrandBlue),
          _LegendDot(label: 'HDFC', color: Color(0xFF0EA5E9)),
          _LegendDot(label: 'Private', color: Color(0xFFF59E0B)),
        ],
      ),
    );
  }
}

class _ChartPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? center;
  final Widget? footer;

  const _ChartPanel({
    required this.title,
    required this.subtitle,
    required this.child,
    this.center,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: _kPanelBg,
      borderRadius: AppRadius.radius18,
      border: Border.all(color: Colors.white.withOpacity(0.08)),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(title: title, subtitle: subtitle),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(child: child),
                if (center != null) center!,
              ],
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 16),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _HourlyLoadCard extends StatelessWidget {
  const _HourlyLoadCard();

  @override
  Widget build(BuildContext context) {
    final rows = const [
      _LoadRow('08:00 - 10:00', 'Rush load', 0.85, AppColors.danger),
      _LoadRow('10:00 - 12:00', 'Moderate', 0.62, Color(0xFFF59E0B)),
      _LoadRow('12:00 - 14:00', 'Low', 0.28, _kBrandGreen),
      _LoadRow('14:00 - 17:00', 'High', 0.74, _kBrandBlue),
    ];

    return _ListPanel(
      title: 'Hourly Clinical Load',
      subtitle: 'Capacity pressure by session block',
      children: [
        for (final row in rows) _LoadTile(row: row),
      ],
    );
  }
}

class _LoadRow {
  final String time;
  final String status;
  final double value;
  final Color color;

  const _LoadRow(this.time, this.status, this.value, this.color);
}

class _LoadTile extends StatelessWidget {
  final _LoadRow row;

  const _LoadTile({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(row.time,
                    style: AppTypography.bodySemibold
                        .copyWith(color: Colors.white)),
              ),
              Text(
                row.status,
                style: TextStyle(
                    color: row.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: row.value,
              minHeight: 8,
              backgroundColor: _kPanelBorder,
              valueColor: AlwaysStoppedAnimation<Color>(row.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerPerformanceCard extends StatelessWidget {
  const _PartnerPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return _ListPanel(
      title: 'Partner Performance',
      subtitle: 'Appointments, collections, and completion rate',
      children: const [
        _PartnerRow(
            asset: AppAssets.logoCallHealth,
            label: 'CallHealth',
            count: '42',
            revenue: '₹21k',
            color: _kBrandGreen),
        _PartnerRow(
            asset: AppAssets.logoSbi,
            label: 'SBI',
            count: '31',
            revenue: '₹15.5k',
            color: _kBrandBlue),
        _PartnerRow(
            asset: AppAssets.logoHdfc,
            label: 'HDFC',
            count: '28',
            revenue: '₹14k',
            color: Color(0xFF0EA5E9)),
      ],
    );
  }
}

class _PartnerRow extends StatelessWidget {
  final String asset;
  final String label;
  final String count;
  final String revenue;
  final Color color;

  const _PartnerRow({
    required this.asset,
    required this.label,
    required this.count,
    required this.revenue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kPanelAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Image.asset(asset,
                fit: BoxFit.contain, filterQuality: FilterQuality.high),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.bodySemibold
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 3),
                Text('$count appointments',
                    style: AppTypography.caption.copyWith(color: _kMuted)),
              ],
            ),
          ),
          Text(
            revenue,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ListPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _ListPanel({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: _kPanelBg,
      borderRadius: AppRadius.radius18,
      border: Border.all(color: Colors.white.withOpacity(0.08)),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(title: title, subtitle: subtitle),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PanelTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.sectionTitle.copyWith(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(color: _kMuted, height: 1.4),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.caption.copyWith(color: _kMuted)),
      ],
    );
  }
}
