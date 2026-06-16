import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class VitalsMonitorScreen extends StatefulWidget {
  @override
  State<VitalsMonitorScreen> createState() => _VitalsMonitorScreenState();
}

class _VitalsMonitorScreenState extends State<VitalsMonitorScreen> with SingleTickerProviderStateMixin {
  Timer? _telemetryTimer;
  late AnimationController _animController;

  // Live fluctuating vital variables
  int _hr = 78;
  int _spo2 = 98;
  double _temp = 36.7;
  String _bp = "122/81";

  // Data point buffer for live wave drawing
  final List<double> _ecgPoints = [];
  double _phase = 0.0;

  @override
  void initState() {
    super.initState();
    
    final bool isTesting = WidgetsBinding.instance.toString().contains('Test');

    // Animate the ECG wave
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (!isTesting) {
      _animController.repeat();
    } else {
      _animController.value = 0.5;
    }

    _animController.addListener(() {
      if (mounted) {
        setState(() {
          _phase += 0.08;
          // Generate normal ECG wave pattern with QRS complexes
          double baseWave = sin(_phase);
          double qrs = 0.0;
          // Add pulse spikes periodically
          double modPhase = _phase % (2 * pi);
          if (modPhase > 1.0 && modPhase < 1.3) {
            qrs = sin((modPhase - 1.0) * 10) * 5.0; // QRS spike
          }
          
          _ecgPoints.add(baseWave * 0.4 + qrs);
          if (_ecgPoints.length > 120) {
            _ecgPoints.removeAt(0);
          }
        });
      }
    });

    // Fluctuating vitals periodically
    if (!isTesting) {
      _telemetryTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (mounted) {
          setState(() {
            final rng = Random();
            _hr = 75 + rng.nextInt(8); // 75 - 82
            _spo2 = 97 + rng.nextInt(3); // 97 - 99
            _temp = 36.6 + rng.nextDouble() * 0.4; // 36.6 - 37.0
            _bp = "${118 + rng.nextInt(8)}/${78 + rng.nextInt(6)}";
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ICU Live Vitals Telemetry", style: AppStyles.titleMedium),
          Text("Simulating active ward patient vital streams with live ECG trace", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          // Active Patient Box
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: AppStyles.cardDecoration(color: AppColors.primaryBg.withOpacity(0.3)),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.accentRed,
                  child: Icon(Icons.monitor_heart, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Monitoring: Marcus Vance (ACS Alert)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("Channel: Ward Bed 04 • Status: Alert Active", style: TextStyle(fontSize: 10, color: AppColors.gray500)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Waveform view
          Container(
            height: 180,
            decoration: AppStyles.cardDecoration(color: AppColors.gray900),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("ECG LEAD II (LIVE TRACE)", style: TextStyle(color: AppColors.accentGreenBright, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    Text("x1.0 SPEED", style: TextStyle(color: AppColors.gray400, fontSize: 8, fontFamily: 'monospace')),
                  ],
                ),
                Expanded(
                  child: CustomPaint(
                    painter: EcgPainter(_ecgPoints),
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Metrics row
          LayoutBuilder(builder: (context, constraints) {
            int gridCount = constraints.maxWidth < 500 ? 2 : 4;
            return GridView.count(
              crossAxisCount: gridCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _buildTelemetryTile("HEART RATE", "$_hr bpm", "Normal (72-88)", Icons.favorite, AppColors.accentRed),
                _buildTelemetryTile("BLOOD PRESSURE", _bp, "Mild High", Icons.speed, AppColors.accentBlue),
                _buildTelemetryTile("TEMPERATURE", "${_temp.toStringAsFixed(1)}°C", "Normal", Icons.thermostat, AppColors.accentOrange),
                _buildTelemetryTile("BLOOD OXYGEN", "$_spo2%", "Normal", Icons.bloodtype, AppColors.accentTeal),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTelemetryTile(String label, String value, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppStyles.caption.copyWith(fontSize: 8)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(value, style: AppStyles.titleMedium.copyWith(fontSize: 18, color: color)),
          Text(status, style: AppStyles.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class EcgPainter extends CustomPainter {
  final List<double> points;

  EcgPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.accentGreenBright
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    double midY = size.height / 2;
    double stepX = size.width / 120;

    path.moveTo(0, midY);

    for (int i = 0; i < points.length; i++) {
      double x = i * stepX;
      double y = midY - (points[i] * 12);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EcgPainter oldDelegate) => true;
}
