// ========== DOSYA: sentinel-terminal/lib/main.dart ==========
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/terminal_stream.dart';
import 'generated/sentinel/execution/v1/execution.pb.dart';

void main() { runApp(const ProviderScope(child: VQTerminalApp())); }

class VQTerminalApp extends StatelessWidget {
  const VQTerminalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VQ-Capital Pro Terminal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121214), elevation: 0),
        cardColor: const Color(0xFF18181B),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(vqPipelineProvider); 
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportListProvider);
    final lastTradeAsync = ref.watch(liveTradesProvider);
    
    // MİKRO-CÜZDAN AYARI (10.00 USD Başlangıç)
    const double initialBalance = 10.00;
    double totalRealizedPnL = 0.0;
    double posQty = 0.0;
    double avgPrice = 0.0;
    List<double> pnlHistory = [0.0];

    for (var r in reports.reversed) {
      totalRealizedPnL += r.realizedPnl;
      pnlHistory.add(totalRealizedPnL);

      if (r.side == "SELL" && posQty > 0.0) {
        double closeQty = min(r.quantity, posQty);
        posQty -= closeQty;
        if (posQty <= 0.000001) avgPrice = 0.0;
      } else if (r.side == "BUY" && posQty < 0.0) {
        double closeQty = min(r.quantity, posQty.abs());
        posQty += closeQty;
        if (posQty.abs() <= 0.000001) avgPrice = 0.0;
      } else {
        double newQty = r.side == "BUY" ? posQty + r.quantity : posQty - r.quantity;
        double totalValue = (posQty.abs() * avgPrice) + (r.quantity * r.executionPrice);
        avgPrice = totalValue / newQty.abs();
        posQty = newQty;
      }
    }

    final currentBalance = initialBalance + totalRealizedPnL;
    final currentPrice = lastTradeAsync.valueOrNull?.price ?? avgPrice;

    double unrealizedPnL = 0.0;
    if (posQty.abs() > 0.000001 && currentPrice > 0) {
      if (posQty > 0) { unrealizedPnL = (currentPrice - avgPrice) * posQty; } 
      else { unrealizedPnL = (avgPrice - currentPrice) * posQty.abs(); }
    }

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.amber, size: 20),
            const SizedBox(width: 10),
            const Text('VQ-CAPITAL', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18)),
            if (isDesktop) const Text(' | MICRO-WALLET HFT TEST', style: TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          lastTradeAsync.when(
            data: (t) => _buildLiveTicker(t.symbol, t.price),
            loading: () => const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))),
            error: (_, __) => const Icon(Icons.wifi_off, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isDesktop 
              ? Row(
                  children: [
                    _buildStatCard("WALLET BALANCE", "\$${currentBalance.toStringAsFixed(4)}", Colors.amberAccent, Icons.account_balance_wallet, "Başlangıç: \$10.00"),
                    const SizedBox(width: 12),
                    _buildStatCard("REALIZED PnL", "\$${totalRealizedPnL.toStringAsFixed(4)}", totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, Icons.monetization_on, "Kapanan işlemlerin kâr/zararı."),
                    const SizedBox(width: 12),
                    _buildStatCard("FLOATING PnL", "\$${unrealizedPnL.toStringAsFixed(4)}", unrealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, Icons.show_chart, "Açık pozisyonun anlık durumu."),
                    const SizedBox(width: 12),
                    _buildPositionCard(posQty, avgPrice),
                    const SizedBox(width: 12),
                    _buildActionCard(context),
                  ],
                )
              : Wrap(
                  spacing: 12, runSpacing: 12,
                  children: [
                    Row(
                      children: [
                        _buildStatCard("WALLET", "\$${currentBalance.toStringAsFixed(4)}", Colors.amberAccent, Icons.account_balance_wallet, ""),
                        const SizedBox(width: 12),
                        _buildPositionCard(posQty, avgPrice),
                      ],
                    ),
                    Row(
                      children: [
                        _buildStatCard("REALIZED", "\$${totalRealizedPnL.toStringAsFixed(4)}", totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, Icons.monetization_on, ""),
                        const SizedBox(width: 12),
                        _buildStatCard("FLOATING", "\$${unrealizedPnL.toStringAsFixed(4)}", unrealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, Icons.show_chart, ""),
                      ],
                    ),
                  ],
                ),
          ),
          
          if (pnlHistory.length > 1)
            Container(
              height: 100, width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 16.0), padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.05))),
              child: CustomPaint(painter: PnLChartPainter(pnlHistory)),
            ),

          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), child: Divider(height: 1, color: Colors.white10)),

          Expanded(
            child: reports.isEmpty
                ? const Center(child: Text("Sistem Aktif. Mikro-Lot Fırsatı Bekleniyor...", style: TextStyle(color: Colors.white24, fontSize: 16)))
                : ListView.builder(
                    itemCount: reports.length, padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) => _buildTradeRow(reports[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTicker(String symbol, double price) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.withOpacity(0.3))),
      child: Center(child: Text('$symbol: ${price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
    );
  }

  Widget _buildStatCard(String title, String value, Color valueColor, IconData icon, String tip) {
    return Expanded(
      child: Tooltip(
        message: tip, textStyle: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(color: Colors.amberAccent, borderRadius: BorderRadius.circular(6)), waitDuration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white38, size: 14), const SizedBox(width: 6),
                  Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildPositionCard(double posQty, double avgPrice) {
    final isFlat = posQty.abs() < 0.000001;
    final isLong = posQty > 0;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isFlat ? Theme.of(context).cardColor : (isLong ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12), border: Border.all(color: isFlat ? Colors.white.withOpacity(0.05) : (isLong ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3)))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.layers, color: Colors.white38, size: 14), SizedBox(width: 6),
                Text("NET POSITION", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 8),
            // HATAYI ÇÖZEN KISIM (Taşmayı Önler)
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(isFlat ? "FLAT" : "${posQty > 0 ? '+' : ''}${posQty.toStringAsFixed(5)}", 
                    style: TextStyle(color: isFlat ? Colors.white54 : (isLong ? Colors.greenAccent : Colors.redAccent), fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'monospace')
                  ),
                  if (!isFlat) ...[
                    const SizedBox(width: 10),
                    Text("@ ${avgPrice.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white38, fontSize: 14, fontFamily: 'monospace')),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.4))),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.power_settings_new, color: Colors.redAccent, size: 24), SizedBox(height: 4),
              Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeRow(ExecutionReport r) {
    final isBuy = r.side == "BUY";
    final pnlColor = r.realizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent;
    final timeStr = DateTime.fromMillisecondsSinceEpoch(r.timestamp.toInt()).toString().substring(11, 19); 

    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.02))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(isBuy ? Icons.arrow_upward : Icons.arrow_downward, color: isBuy ? Colors.greenAccent : Colors.redAccent, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                // BOL SIFIRLI MİKTAR
                Text("$timeStr • ${r.quantity.toStringAsFixed(5)} Qty", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$${r.executionPrice.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600, fontSize: 15)),
              Text("Lat: ${r.latencyMs}ms", style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 24),
          Container(
            width: 100, padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(color: pnlColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text("${r.realizedPnl >= 0 ? '+' : ''}${r.realizedPnl.toStringAsFixed(4)}", textAlign: TextAlign.right, style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class PnLChartPainter extends CustomPainter {
  final List<double> history;
  PnLChartPainter(this.history);

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    final paint = Paint()..color = history.last >= 0 ? Colors.greenAccent : Colors.redAccent..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final minPnl = history.reduce(min);
    final maxPnl = history.reduce(max);
    final range = (maxPnl - minPnl) == 0 ? 1.0 : (maxPnl - minPnl);
    final path = Path();
    final dx = size.width / (history.length > 1 ? history.length - 1 : 1);

    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      final normalizedY = (history[i] - minPnl) / range;
      final y = size.height - (normalizedY * size.height);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);

    if (minPnl < 0 && maxPnl > 0) {
      final zeroY = size.height - ((0 - minPnl) / range) * size.height;
      final zeroPaint = Paint()..color = Colors.white24..strokeWidth = 1.0..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroPaint);
    }
  }
  @override
  bool shouldRepaint(covariant PnLChartPainter oldDelegate) => true;
}