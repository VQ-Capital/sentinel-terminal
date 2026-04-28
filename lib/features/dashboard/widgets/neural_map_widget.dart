// ========== DOSYA: sentinel-terminal/lib/features/dashboard/widgets/neural_map_widget.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

final Map<String, List<Offset>> _trailMap = {};

class NeuralGalaxyPanel extends ConsumerWidget {
  const NeuralGalaxyPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vectors = ref.watch(zScoreProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔥 CERRAHİ: Taşmayı önlemek için Expanded ve FittedBox eklendi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("🌌 ONNX 12D DECISION MANIFOLD", 
                        style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    ),
                    Text("Vektörel Olasılık Haritası", style: TextStyle(color: Colors.white24, fontSize: 9)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: RadarBackgroundPainter(),
                    ),
                    
                    ...vectors.entries.map((entry) {
                      final symbol = entry.key;
                      final vec = entry.value;
                      
                      final double centerX = constraints.maxWidth / 2;
                      final double centerY = constraints.maxHeight / 2;
                      final double x = (vec.priceVelocity * (centerX / 3)).clamp(0.0, constraints.maxWidth);
                      final double y = (centerY - (vec.volumeImbalance * (centerY / 3))).clamp(0.0, constraints.maxHeight);

                      _trailMap.putIfAbsent(symbol, () => []);
                      final trail = _trailMap[symbol]!;
                      trail.add(Offset(x, y));
                      if (trail.length > 8) trail.removeAt(0);

                      return Stack(
                        children: [
                          ...trail.asMap().entries.map((trailEntry) {
                            final idx = trailEntry.key;
                            final pos = trailEntry.value;
                            final opacity = (idx / trail.length) * 0.4;
                            return Positioned(
                              left: pos.dx - 4,
                              top: pos.dy - 4,
                              child: Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: _getColorForSymbol(symbol).withOpacity(opacity),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          }),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                            left: x - 10,
                            top: y - 10,
                            child: _buildInstitutionalPointer(symbol, _getColorForSymbol(symbol)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionalPointer(String symbol, Color color) {
    return Column(
      children: [
        Container(
          width: 20, height: 20,
          decoration: BoxDecoration(
            color: color, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(symbol[0], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
          child: Text(symbol.replaceAll("USDT", ""), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Color _getColorForSymbol(String symbol) {
    if (symbol.contains("BTC")) return Colors.orangeAccent;
    if (symbol.contains("ETH")) return Colors.blueAccent;
    if (symbol.contains("SOL")) return Colors.purpleAccent;
    return Colors.yellowAccent;
  }

  Widget _buildStatusBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        const Text("CUDA", style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paintLine = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 1;

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paintLine);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paintLine);

    _drawZoneText(canvas, "Q1: POSITIVE DRIFT", Offset(size.width - 100, 10), Colors.greenAccent.withOpacity(0.3));
    _drawZoneText(canvas, "Q3: NEGATIVE DRIFT", Offset(10, size.height - 20), Colors.redAccent.withOpacity(0.3));
    _drawZoneText(canvas, "Q4: MEAN REV (BID)", Offset(size.width - 100, size.height - 20), Colors.blueAccent.withOpacity(0.3));
    _drawZoneText(canvas, "Q2: MEAN REV (ASK)", Offset(10, 10), Colors.orangeAccent.withOpacity(0.3));
    
    canvas.drawCircle(center, 4, Paint()..color = Colors.white10);
  }

  void _drawZoneText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}