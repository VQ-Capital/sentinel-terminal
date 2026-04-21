// ========== DOSYA: sentinel-terminal/lib/main.dart ==========
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/terminal_stream.dart';
import 'generated/sentinel/execution/v1/execution.pb.dart';

void main() {
  runApp(const ProviderScope(child: VQTerminalApp()));
}

class VQTerminalApp extends StatelessWidget {
  const VQTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VQ-Capital Pro Terminal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(vqPipelineProvider, (previous, next) {
      if (next.hasValue && next.value!.hasReport()) {
        ref.read(reportListProvider("all").notifier).addReport(next.value!.report);
      }
    });

    final reports = ref.watch(reportListProvider("all"));
    final lastTradeAsync = ref.watch(liveTradesProvider);

    final totalPnL = reports.fold<double>(0, (sum, item) => sum + item.realizedPnl);

    // Kümülatif PnL Hesaplaması (Grafik İçin)
    List<double> pnlHistory = [0.0]; // Başlangıç noktası 0
    double currentPnL = 0.0;
    // Raporlar ekranda en yeni en üstte (reversed) göründüğü için, grafiğe çizerken kronolojik sıraya diziyoruz
    for (var r in reports.reversed) {
      currentPnL += r.realizedPnl;
      pnlHistory.add(currentPnL);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🦅 Sentinel',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 18),
        ),
        actions: [
          lastTradeAsync.when(
            data: (t) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  '${t.symbol}: ${t.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            loading: () => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            error: (_, __) => const Icon(Icons.error_outline, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          // ÜST STATİSTİK PANELİ
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatCard("TOTAL PnL", "${totalPnL.toStringAsFixed(2)} USD", 
                    totalPnL >= 0 ? Colors.greenAccent : Colors.redAccent),
                const SizedBox(width: 12),
                _buildStatCard("TRADES", "${reports.length}", Colors.blueAccent),
                const SizedBox(width: 12),
                _buildActionCard(context), // Kill Switch Butonu Alanı
              ],
            ),
          ),
          
          // PNL GRAFİĞİ (NATIVE CUSTOM PAINT)
          if (pnlHistory.length > 1)
            Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: CustomPaint(
                painter: PnLChartPainter(pnlHistory),
              ),
            ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Divider(height: 1, color: Colors.white10),
          ),

          // CANLI İŞLEM LİSTESİ
          Expanded(
            child: reports.isEmpty
                ? const Center(
                    child: Text("Sinyal Bekleniyor... Ham Veri Hattı Aktif.", 
                    style: TextStyle(color: Colors.white24, fontSize: 16)))
                : ListView.builder(
                    itemCount: reports.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return _buildTradeRow(reports[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }

  // Acil Durum / Kill Switch Butonu
  Widget _buildActionCard(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // İleride WebSocket kanalına ControlCommand basılacak
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🚨 KILL SWITCH: Sinyal API\'ye gönderildi!'), backgroundColor: Colors.red),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_rounded, color: Colors.redAccent, size: 20),
              SizedBox(height: 4),
              Text("EMERGENCY STOP", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeRow(ExecutionReport r) {
    final isBuy = r.side == "BUY";
    final pnlColor = r.realizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Row(
        children: [
          Icon(isBuy ? Icons.add_circle_outline : Icons.remove_circle_outline, 
               color: isBuy ? Colors.green : Colors.red, size: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text("${r.quantity} Qty", style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(r.executionPrice.toStringAsFixed(2), style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w500)),
              Text("${r.latencyMs}ms", style: const TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
          const SizedBox(width: 20),
          Container(
            width: 85,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: pnlColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${r.realizedPnl >= 0 ? '+' : ''}${r.realizedPnl.toStringAsFixed(2)}",
              textAlign: TextAlign.right,
              style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

// NATIVE KÜMÜLATİF PNL ÇİZİCİ (Zero-Dependency)
class PnLChartPainter extends CustomPainter {
  final List<double> history;
  PnLChartPainter(this.history);

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final paint = Paint()
      ..color = history.last >= 0 ? Colors.greenAccent : Colors.redAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final minPnl = history.reduce(min);
    final maxPnl = history.reduce(max);
    final range = (maxPnl - minPnl) == 0 ? 1.0 : (maxPnl - minPnl);

    final path = Path();
    final dx = size.width / (history.length > 1 ? history.length - 1 : 1);

    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      // Y değerini normalize et (Aşağısı 0, Yukarısı size.height)
      final normalizedY = (history[i] - minPnl) / range;
      final y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Eğer min < 0 ve max > 0 ise, tam sıfır noktasına referans çizgisi çiz
    if (minPnl < 0 && maxPnl > 0) {
      final zeroY = size.height - ((0 - minPnl) / range) * size.height;
      final zeroPaint = Paint()
        ..color = Colors.white24
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PnLChartPainter oldDelegate) => true;
}