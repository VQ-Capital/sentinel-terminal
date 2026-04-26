import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

class ZScoreRadarPanel extends ConsumerWidget {
  const ZScoreRadarPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vectors = ref.watch(zScoreProvider);
    final reports = ref.watch(reportListProvider); // SLA için raporları dinle

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ÜST BAŞLIK VE SLA BİLGİSİ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("V4 OMNISCIENCE REAL-TIME RADAR", 
                style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              _buildSlaMiniTracker(reports), // Sağ üste minik SLA özeti
            ],
          ),
          const SizedBox(height: 16),
          
          if (vectors.isEmpty) 
            const Expanded(child: Center(child: Text("HFT Veri Akışı Bekleniyor...", style: TextStyle(color: Colors.white24))))
          else 
            Expanded(
              child: GridView.builder( // Daha iyi alan kullanımı için Grid!
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Yan yana iki coin
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemCount: vectors.length,
                itemBuilder: (context, index) {
                  final symbol = vectors.keys.elementAt(index);
                  final vec = vectors[symbol]!;
                  return _buildDetailedCoinCard(symbol, vec);
                },
              ),
            ),
        ],
      ),
    );
  }

  // Minik SLA Isı Haritası (Radar içine gömülü)
  Widget _buildSlaMiniTracker(List<dynamic> reports) {
    return Row(
      children: [
        const Text("SLA:", style: TextStyle(color: Colors.white38, fontSize: 9)),
        const SizedBox(width: 6),
        ...reports.take(10).map((r) {
          Color c = r.latencyMs > 50 ? Colors.redAccent : (r.latencyMs > 25 ? Colors.orangeAccent : Colors.greenAccent);
          return Container(width: 6, height: 6, margin: const EdgeInsets.only(left: 2), decoration: BoxDecoration(color: c, shape: BoxShape.circle));
        }),
      ],
    );
  }  

  Widget _buildDetailedCoinCard(String symbol, dynamic vec) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(symbol, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          _buildZLine("VEL", vec.priceVelocity, Colors.blueAccent),
          _buildZLine("IMB", vec.volumeImbalance, Colors.orangeAccent),
          _buildZLine("SENT", vec.sentimentScore, Colors.purpleAccent),
          _buildZLine("URG", vec.chainUrgency, Colors.greenAccent),
        ],
      ),
    );
  }  

  Widget _buildZLine(String label, double value, Color color) {
    final double normalized = ((value + 3.0) / 6.0).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(width: 28, child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold))),
        Expanded(
          child: Stack(
            children: [
              Container(height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
              FractionallySizedBox(
                widthFactor: normalized,
                child: Container(height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text("${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}", 
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
      ],
    );
  }
}

  Widget _buildCoinRadarCard(String symbol, dynamic vec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(symbol, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              const Icon(Icons.bolt, color: Colors.blueAccent, size: 12),
            ],
          ),
          const SizedBox(height: 8),
          _buildZRow("VEL", vec.priceVelocity, Colors.blueAccent, "Fiyat Hızı"),
          _buildZRow("IMB", vec.volumeImbalance, Colors.orangeAccent, "Tahta Dengesi"),
          _buildZRow("SNT", vec.sentimentScore, Colors.purpleAccent, "NLP Duygu"),
          _buildZRow("URG", vec.chainUrgency, Colors.greenAccent, "Zincir Aciliyeti"),
        ],
      ),
    );
  }

  Widget _buildZRow(String label, double value, Color color, String tooltip) {
    final double normalized = ((value + 3.0) / 6.0).clamp(0.0, 1.0);
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            SizedBox(width: 25, child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold))),
            Expanded(
              child: Stack(
                children: [
                  Container(height: 5, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
                  FractionallySizedBox(
                    widthFactor: normalized,
                    child: Container(
                      height: 5, 
                      decoration: BoxDecoration(
                        color: color, 
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 2)]
                      ),
                    ),
                  ),
                  Align(alignment: Alignment.center, child: Container(width: 1, height: 5, color: Colors.white24)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text("${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}σ", 
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              ),
            ),
          ],
        ),
      ),
    );
  }


// --- SLA HEALTH PANELİNİ DE KÜÇÜLTELİM Kİ TAŞMASIN ---
class SlaHeatmapPanel extends ConsumerWidget {
  const SlaHeatmapPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // ÖNEMLİ: Taşı önlemek için
        children: [
          const Text("SLA HEALTH (LAST 32)", style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView( // Scroll eklendi
            scrollDirection: Axis.horizontal,
            child: Row(
              children: reports.take(32).map((r) {
                Color c = Colors.greenAccent;
                if (r.latencyMs > 50) c = Colors.redAccent;
                else if (r.latencyMs > 25) c = Colors.orangeAccent;
                return Container(
                  margin: const EdgeInsets.only(right: 3),
                  width: 8, height: 8, 
                  decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(1)),
                );
              }).toList(),
            ),
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