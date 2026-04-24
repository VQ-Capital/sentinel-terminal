import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

// --- Z-SCORE RADAR PANELI (Düzeltildi) ---
class ZScoreRadarPanel extends ConsumerWidget {
  const ZScoreRadarPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vectors = ref.watch(zScoreProvider);
    // HFT gösterimi için şu an BTCUSDT odaklı (İleride dinamik seçilebilir)
    final vec = vectors["BTCUSDT"]; 

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ekranı patlatmaması için
        children: [
          const Text("V3 NEURAL RADAR (BTCUSDT)", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 16),
          if (vec == null) 
            const Expanded(child: Center(child: Text("Sinyal Bekleniyor...", style: TextStyle(color: Colors.white24, fontSize: 10))))
          else ...[
            _buildZBar("VELOCITY", vec.priceVelocity, Colors.blueAccent),
            const SizedBox(height: 14),
            _buildZBar("IMBALANCE", vec.volumeImbalance, Colors.orangeAccent),
            const SizedBox(height: 14),
            _buildZBar("SENTIMENT", vec.sentimentScore, Colors.purpleAccent),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Son Eşleşme: ${DateTime.now().toString().substring(11,19)}", style: const TextStyle(color: Colors.white24, fontSize: 8)),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildZBar(String label, double value, Color color) {
    final double normalized = ((value + 3.0) / 6.0).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
            Text("${value.toStringAsFixed(2)}σ", style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(height: 6, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(3))),
            FractionallySizedBox(
              widthFactor: normalized,
              child: Container(
                height: 6, 
                decoration: BoxDecoration(
                  color: color, 
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)]
                )
              ),
            ),
            Align(alignment: const Alignment(0, 0), child: Container(width: 2, height: 6, color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

// --- SLA HEATMAP PANELI (Düzeltildi) ---
class SlaHeatmapPanel extends ConsumerWidget {
  const SlaHeatmapPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SLA HEALTH (LAST 32)", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: reports.take(32).map((r) {
              Color c = Colors.greenAccent;
              if (r.latencyMs > 50) c = Colors.redAccent;
              else if (r.latencyMs > 25) c = Colors.orangeAccent;
              return Container(
                width: 12, height: 12, 
                decoration: BoxDecoration(
                  color: c, 
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [BoxShadow(color: c.withOpacity(0.4), blurRadius: 2)]
                )
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// --- PNL CHART KAPSAYICI ---
class PnlChartWidget extends StatelessWidget {
  final List<double> history;
  final double currentPnl;
  const PnlChartWidget({super.key, required this.history, required this.currentPnl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("KÜMÜLATİF PnL", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Text("${currentPnl >= 0 ? '+' : ''}\$${currentPnl.toStringAsFixed(2)}",
                  style: TextStyle(color: currentPnl >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: ClipRect(child: CustomPaint(painter: PnLChartPainter(history), size: Size.infinite))),
        ],
      ),
    );
  }
}

// --- LATENCY CHART KAPSAYICI ---
class LatencyChartWidget extends StatelessWidget {
  final List<int> latencies;
  final int avgLatency;
  const LatencyChartWidget({super.key, required this.latencies, required this.avgLatency});

  @override
  Widget build(BuildContext context) {
    Color latColor = avgLatency > 50 ? Colors.redAccent : (avgLatency > 20 ? Colors.blueAccent : Colors.greenAccent);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- DEĞİŞİKLİK BURADA: Flexible eklendi ---
              const Flexible(
                child: Text("SLA WATCHDOG (LATENCY)", 
                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis, // Sığmazsa üç nokta koy
                ),
              ),
              const SizedBox(width: 4), // Küçük bir boşluk
              Text("${avgLatency}ms", style: TextStyle(color: latColor, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: ClipRect(child: CustomPaint(painter: LatencyChartPainter(latencies), size: Size.infinite))),
        ],
      ),
    );
  }
}

// Custom Painter Sınıfları (Eskisiyle aynı)
class PnLChartPainter extends CustomPainter {
  final List<double> history;
  PnLChartPainter(this.history);

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 1;
    for (int i = 1; i < 4; i++) { canvas.drawLine(Offset(0, size.height * (i / 4)), Offset(size.width, size.height * (i / 4)), gridPaint); }

    final isProfit = history.last >= 0;
    final paint = Paint()..color = isProfit ? Colors.greenAccent : Colors.redAccent..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final minPnl = history.reduce(min); final maxPnl = history.reduce(max);
    final range = (maxPnl - minPnl) == 0 ? 1.0 : (maxPnl - minPnl);
    final paddedRange = range * 1.3; final paddedMin = minPnl - (range * 0.15);

    final path = Path();
    final dx = size.width / (history.length > 1 ? history.length - 1 : 1);
    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      final y = size.height - (((history[i] - paddedMin) / paddedRange) * size.height);
      if (i == 0) path.moveTo(x, y);
      else {
        final prevX = (i - 1) * dx;
        final prevY = size.height - (((history[i - 1] - paddedMin) / paddedRange) * size.height);
        path.cubicTo(prevX + (dx / 2), prevY, prevX + (dx / 2), y, x, y);
      }
    }
    if (minPnl < 0 && maxPnl > 0) {
      final zeroY = size.height - ((0 - paddedMin) / paddedRange) * size.height;
      final zeroPaint = Paint()..color = Colors.white38..strokeWidth = 1.0..style = PaintingStyle.stroke;
      for (double i = 0; i < size.width; i += 10) canvas.drawLine(Offset(i, zeroY), Offset(i + 5, zeroY), zeroPaint);
    }
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant PnLChartPainter oldDelegate) => true;
}

class LatencyChartPainter extends CustomPainter {
  final List<int> latencies;
  LatencyChartPainter(this.latencies);
  @override
  void paint(Canvas canvas, Size size) {
    if (latencies.isEmpty) return;
    int maxLat = latencies.reduce(max); if (maxLat < 60) maxLat = 60;
    final double slaY = size.height - ((50 / maxLat) * size.height);
    final slaPaint = Paint()..color = Colors.redAccent.withOpacity(0.5)..strokeWidth = 1..style = PaintingStyle.stroke;
    for (double i = 0; i < size.width; i += 10) canvas.drawLine(Offset(i, slaY), Offset(i + 5, slaY), slaPaint);

    final actualBarWidth = ((size.width / latencies.length) - 2).clamp(1.0, double.infinity);
    for (int i = 0; i < latencies.length; i++) {
      final lat = latencies[i];
      final x = i * (size.width / latencies.length);
      final y = size.height - ((lat / maxLat) * size.height);
      Color barColor = lat > 50 ? Colors.redAccent : (lat > 20 ? Colors.blueAccent : Colors.greenAccent);
      final rect = Rect.fromLTWH(x, y, actualBarWidth, size.height - y);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), Paint()..color = barColor);
    }
  }
  @override bool shouldRepaint(covariant LatencyChartPainter oldDelegate) => true;
}