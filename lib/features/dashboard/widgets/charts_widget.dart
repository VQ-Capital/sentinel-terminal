// ========== DOSYA: sentinel-terminal/lib/features/dashboard/widgets/charts_widget.dart ==========
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

class ZScoreRadarPanel extends ConsumerWidget {
  const ZScoreRadarPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vectors = ref.watch(zScoreProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.05), blurRadius: 20)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("🧠 AI 12D ONNX FUSION RADAR", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Tooltip(
                message: "Yapay zeka piyasayı 12 boyutta (ONNX) analiz eder.\nAşağıdaki 4 metrik ana bileşenlerdir (PCA Base).\nBarlar sağa kayarsa ALIM (Yeşil/Mavi),\nsola kayarsa SATIŞ (Kırmızı) baskısı vardır.",
                child: Icon(Icons.help_outline, color: Colors.blueAccent.withOpacity(0.5), size: 16),
              )
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          
          if (vectors.isEmpty) 
            const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)))
          else 
            Expanded(
              child: ListView.separated(
                itemCount: vectors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final symbol = vectors.keys.elementAt(index);
                  return _buildCoinRadarCard(symbol, vectors[symbol]!);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCoinRadarCard(String symbol, dynamic vec) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(symbol.replaceAll('USDT', ''), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              _buildGeneralStatusBadge(vec.priceVelocity), 
            ],
          ),
          const SizedBox(height: 12),
          _buildZRow("HIZ (VEL)", vec.priceVelocity, Colors.blueAccent, "Fiyat İvmesi (Price Velocity)"),
          _buildZRow("TAHTA (IMB)", vec.volumeImbalance, Colors.orangeAccent, "Emir Defteri Dengesizliği (Orderbook Imbalance)"),
          _buildZRow("DUYGU (NLP)", vec.sentimentScore, Colors.purpleAccent, "Yapay Zeka Haber Duygusu (Neural Sentiment)"),
          _buildZRow("ZİNCİR (URG)", vec.chainUrgency, Colors.greenAccent, "Mempool Ağ Tıkanıklığı (On-Chain Urgency)"),
        ],
      ),
    );
  }

  Widget _buildGeneralStatusBadge(double velocity) {
    String text = "NEUTRAL";
    Color color = Colors.white54;
    
    if (velocity > 1.5) { text = "STRONG BUY"; color = Colors.greenAccent; }
    else if (velocity > 0.5) { text = "BUY PRESSURE"; color = Colors.green; }
    else if (velocity < -1.5) { text = "PANIC SELL"; color = Colors.redAccent; }
    else if (velocity < -0.5) { text = "SELL PRESSURE"; color = Colors.red; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withOpacity(0.5))),
      child: Text(text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildZRow(String label, double value, Color color, String tooltip) {
    final bool isPositive = value >= 0;

    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(width: 60, child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold))),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final center = width / 2;
                  final barWidth = (value.abs() / 3.0).clamp(0.0, 1.0) * center;
                  
                  return SizedBox(
                    height: 12,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
                        Container(width: 2, height: 12, color: Colors.white54),
                        Positioned(
                          left: isPositive ? center : center - barWidth,
                          width: barWidth,
                          child: Container(
                            height: 4, 
                            decoration: BoxDecoration(color: isPositive ? color : Colors.redAccent, borderRadius: BorderRadius.circular(2))
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 50,
              child: Text("${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}σ", 
                textAlign: TextAlign.right,
                style: TextStyle(color: isPositive ? color : Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ),
          ],
        ),
      ),
    );
  }
}

class PnlChartWidget extends StatelessWidget {
  final List<double> balanceHistory;
  final List<double> equityHistory;
  final double currentPnl;
  
  const PnlChartWidget({super.key, required this.balanceHistory, required this.equityHistory, required this.currentPnl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("EQUITY vs BALANCE EĞRİSİ", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Text("${currentPnl >= 0 ? '+' : ''}\$${currentPnl.toStringAsFixed(0)}",
                  style: TextStyle(color: currentPnl >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: ClipRect(child: CustomPaint(painter: PnLChartPainter(balanceHistory, equityHistory), size: Size.infinite))),
        ],
      ),
    );
  }
}

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
              const Flexible(
                child: Text("SLA WATCHDOG (LATENCY)", 
                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
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

// 🔥 CERRAHİ: Unutulan SlaHeatmapPanel Sınıfı Eklendi
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("SLA HEALTH (LAST 32)", style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
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

class PnLChartPainter extends CustomPainter {
  final List<double> balanceHistory;
  final List<double> equityHistory;

  PnLChartPainter(this.balanceHistory, this.equityHistory);

  @override
  void paint(Canvas canvas, Size size) {
    if (balanceHistory.isEmpty || equityHistory.isEmpty) return;
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 1;
    for (int i = 1; i < 4; i++) { canvas.drawLine(Offset(0, size.height * (i / 4)), Offset(size.width, size.height * (i / 4)), gridPaint); }

    final minBal = balanceHistory.reduce(min); final maxBal = balanceHistory.reduce(max);
    final minEq = equityHistory.reduce(min); final maxEq = equityHistory.reduce(max);
    final globalMin = min(minBal, minEq); final globalMax = max(maxBal, maxEq);
    
    final range = (globalMax - globalMin) == 0 ? 1.0 : (globalMax - globalMin);
    final paddedRange = range * 1.3; final paddedMin = globalMin - (range * 0.15);

    final dx = size.width / (balanceHistory.length > 1 ? balanceHistory.length - 1 : 1);

    final eqPath = Path();
    for (int i = 0; i < equityHistory.length; i++) {
      final x = i * dx;
      final y = size.height - (((equityHistory[i] - paddedMin) / paddedRange) * size.height);
      if (i == 0) eqPath.moveTo(x, y);
      else {
        final prevX = (i - 1) * dx;
        final prevY = size.height - (((equityHistory[i - 1] - paddedMin) / paddedRange) * size.height);
        eqPath.cubicTo(prevX + (dx / 2), prevY, prevX + (dx / 2), y, x, y);
      }
    }
    final eqPaint = Paint()..color = Colors.yellowAccent.withOpacity(0.6)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawPath(eqPath, eqPaint);

    final balPath = Path();
    for (int i = 0; i < balanceHistory.length; i++) {
      final x = i * dx;
      final y = size.height - (((balanceHistory[i] - paddedMin) / paddedRange) * size.height);
      if (i == 0) balPath.moveTo(x, y);
      else {
        final prevX = (i - 1) * dx;
        final prevY = size.height - (((balanceHistory[i - 1] - paddedMin) / paddedRange) * size.height);
        balPath.cubicTo(prevX + (dx / 2), prevY, prevX + (dx / 2), y, x, y);
      }
    }
    final balPaint = Paint()..color = Colors.blueAccent..strokeWidth = 3.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawPath(balPath, balPaint);
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
      Color barColor = lat > 50 ? Colors.redAccent : (lat > 25 ? Colors.blueAccent : Colors.greenAccent);
      final rect = Rect.fromLTWH(x, y, actualBarWidth, size.height - y);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), Paint()..color = barColor);
    }
  }
  @override bool shouldRepaint(covariant LatencyChartPainter oldDelegate) => true;
}