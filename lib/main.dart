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
      title: 'VQ Sentinel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121214), elevation: 0),
        cardColor: const Color(0xFF18181B),
      ),
      home: const DashboardScreen(),
    );
  }
}

class PriceHistoryNotifier extends Notifier<List<double>> {
  @override
  List<double> build() => [];
  void addPrice(double price) {
    if (state.isEmpty || state.last != price) {
      state = [...state, price];
      if (state.length > 100) state.removeAt(0);
    }
  }
}
final priceHistoryProvider = NotifierProvider<PriceHistoryNotifier, List<double>>(() => PriceHistoryNotifier());

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
    
    ref.listen(liveTradesProvider, (prev, next) {
      if (next.valueOrNull != null) {
        ref.read(priceHistoryProvider.notifier).addPrice(next.value!.price);
      }
    });
    
    final priceHistory = ref.watch(priceHistoryProvider);
    final lastTradeAsync = ref.watch(liveTradesProvider);
    
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
      unrealizedPnL = posQty > 0 ? (currentPrice - avgPrice) * posQty : (avgPrice - currentPrice) * posQty.abs();
    }

    final bool isDefensiveMode = ((initialBalance - currentBalance) / initialBalance) > 0.15;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.security, color: Colors.amber, size: 22),
            const SizedBox(width: 10),
            const Text('SENTINEL', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18)),
          ],
        ),
        actions: [
          lastTradeAsync.when(
            data: (t) => _buildLiveTicker(t.symbol, t.price),
            loading: () => const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))),
            error: (_, __) => const Padding(padding: EdgeInsets.only(right:16), child: Icon(Icons.wifi_off, color: Colors.red)),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // OVERFLOW'U ÖNLEYEN ROZET ALANI
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      _buildSystemStatusBadge(isDefensiveMode),
                      const Spacer(),
                      if (isDesktop) const Text('MICRO-WALLET HFT TEST ENVIRONMENT', style: TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
                
                // RESPONSIVE KARTLAR (Taşma yapmaz)
                Wrap(
                  spacing: 10, runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: [
                    _buildSizedCard(_buildStatCard("WALLET", "\$${currentBalance.toStringAsFixed(4)}", Colors.amberAccent), constraints.maxWidth),
                    _buildSizedCard(_buildStatCard("REALIZED PnL", "\$${totalRealizedPnL.toStringAsFixed(4)}", totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent), constraints.maxWidth),
                    _buildSizedCard(_buildStatCard("FLOATING PnL", "\$${unrealizedPnL.toStringAsFixed(4)}", unrealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent), constraints.maxWidth),
                    _buildSizedCard(_buildPositionCard(posQty, avgPrice), constraints.maxWidth),
                    _buildSizedCard(_buildKillSwitch(), constraints.maxWidth),
                  ],
                ),
                
                const SizedBox(height: 12),

                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _buildChartContainer("PİYASA AKIŞI (LIVE)", PriceChartPainter(priceHistory), Colors.blueAccent),
                                  const SizedBox(height: 12),
                                  _buildChartContainer("KÜMÜLATİF KÂR/ZARAR", PnLChartPainter(pnlHistory), totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(flex: 6, child: _buildDenseTradeLog(reports)),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: 120, child: _buildChartContainer("PİYASA AKIŞI", PriceChartPainter(priceHistory), Colors.blueAccent)),
                            const SizedBox(height: 8),
                            SizedBox(height: 100, child: _buildChartContainer("PnL EĞRİSİ", PnLChartPainter(pnlHistory), totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent)),
                            const SizedBox(height: 8),
                            Expanded(child: _buildDenseTradeLog(reports)),
                          ],
                        ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildSizedCard(Widget child, double maxWidth) {
    double width = maxWidth > 1200 ? (maxWidth / 5) - 15 : (maxWidth > 800 ? (maxWidth / 3) - 15 : (maxWidth / 2) - 15);
    return SizedBox(width: width, height: 80, child: child);
  }

  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isDefensive ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: isDefensive ? Colors.orange.withOpacity(0.5) : Colors.green.withOpacity(0.5))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isDefensive ? Icons.shield : Icons.sports_kabaddi, color: isDefensive ? Colors.orangeAccent : Colors.greenAccent, size: 14),
          const SizedBox(width: 6),
          Text(isDefensive ? "DEFANS MODU" : "HÜCUM MODU", style: TextStyle(color: isDefensive ? Colors.orangeAccent : Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLiveTicker(String symbol, double price) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.05), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.green.withOpacity(0.2))),
      child: Center(child: Text('$symbol: ${price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 14))),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'monospace'))),
        ],
      ),
    );
  }

  Widget _buildPositionCard(double posQty, double avgPrice) {
    final isFlat = posQty.abs() < 0.000001;
    final isLong = posQty > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isFlat ? Theme.of(context).cardColor : (isLong ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(8), border: Border.all(color: isFlat ? Colors.white.withOpacity(0.05) : (isLong ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3)))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("NET POSITION", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(isFlat ? "FLAT" : "${posQty > 0 ? '+' : ''}${posQty.toStringAsFixed(5)}", style: TextStyle(color: isFlat ? Colors.white54 : (isLong ? Colors.greenAccent : Colors.redAccent), fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                if (!isFlat) Text(" @ ${avgPrice.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'monospace')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKillSwitch() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.3))),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new, color: Colors.redAccent, size: 20), SizedBox(height: 4),
            Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(String title, CustomPainter painter, Color titleColor) {
    return Expanded(
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: titleColor.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8),
            Expanded(child: ClipRect(child: CustomPaint(painter: painter, size: Size.infinite))),
          ],
        ),
      ),
    );
  }

  Widget _buildDenseTradeLog(List<ExecutionReport> reports) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("İŞLEM DEFTERİ (EXECUTION LOG)", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
          const Divider(height: 1, color: Colors.white10),
          Expanded(
            child: reports.isEmpty
                ? const Center(child: Text("Sistem Isınıyor (Cold-Start). Vektörler Toplanıyor...", style: TextStyle(color: Colors.white24, fontSize: 14)))
                : ListView.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                    itemBuilder: (context, index) {
                      final r = reports[index];
                      final isBuy = r.side == "BUY";
                      final pnlColor = r.realizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent;
                      final timeStr = DateTime.fromMillisecondsSinceEpoch(r.timestamp.toInt()).toString().substring(11, 19); 
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(timeStr, style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'monospace'))),
                            Expanded(flex: 1, child: Container(
                              alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(r.side, style: TextStyle(color: isBuy ? Colors.greenAccent : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                            )),
                            const SizedBox(width: 8),
                            Expanded(flex: 2, child: Text(r.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            Expanded(flex: 2, child: Text(r.quantity.toStringAsFixed(5), textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
                            Expanded(flex: 2, child: Text("\$${r.executionPrice.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
                            Expanded(flex: 2, child: Text("${r.realizedPnl >= 0 ? '+' : ''}${r.realizedPnl.toStringAsFixed(4)}", textAlign: TextAlign.right, style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13))),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PriceChartPainter extends CustomPainter {
  final List<double> history;
  PriceChartPainter(this.history);
  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;
    final paint = Paint()..color = Colors.blueAccent.withOpacity(0.8)..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final minPrice = history.reduce(min);
    final maxPrice = history.reduce(max);
    final range = (maxPrice - minPrice) == 0 ? 1.0 : (maxPrice - minPrice);
    final paddedRange = range * 1.2; 
    final paddedMin = minPrice - (range * 0.1);
    final path = Path();
    final dx = size.width / (history.length - 1);
    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      final normalizedY = (history[i] - paddedMin) / paddedRange;
      final y = size.height - (normalizedY * size.height);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
    final lastY = size.height - (((history.last - paddedMin) / paddedRange) * size.height);
    canvas.drawCircle(Offset(size.width, lastY), 3, Paint()..color = Colors.white);
  }
  @override
  bool shouldRepaint(covariant PriceChartPainter oldDelegate) => true;
}

class PnLChartPainter extends CustomPainter {
  final List<double> history;
  PnLChartPainter(this.history);
  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    final paint = Paint()..color = history.last >= 0 ? Colors.greenAccent : Colors.redAccent..strokeWidth = 2.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final minPnl = history.reduce(min);
    final maxPnl = history.reduce(max);
    final range = (maxPnl - minPnl) == 0 ? 1.0 : (maxPnl - minPnl);
    // Grafik çizgisi dibe yapışmasın diye padding
    final paddedRange = range * 1.2; 
    final paddedMin = minPnl - (range * 0.1);
    final path = Path();
    final dx = size.width / (history.length > 1 ? history.length - 1 : 1);
    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      final normalizedY = (history[i] - paddedMin) / paddedRange;
      final y = size.height - (normalizedY * size.height);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    if (minPnl < 0 && maxPnl > 0) {
      final zeroY = size.height - ((0 - paddedMin) / paddedRange) * size.height;
      final zeroPaint = Paint()..color = Colors.white24..strokeWidth = 1.0..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroPaint);
    }
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    final gradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [paint.color.withOpacity(0.2), paint.color.withOpacity(0.0)]);
    canvas.drawPath(fillPath, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant PnLChartPainter oldDelegate) => true;
}