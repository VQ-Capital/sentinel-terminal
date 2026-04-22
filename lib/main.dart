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
      title: 'VQ-Capital Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121214),
          elevation: 0,
          centerTitle: false,
        ),
        cardColor: const Color(0xFF18181B),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white24)),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          padding: const EdgeInsets.all(12),
          waitDuration: const Duration(milliseconds: 200),
        ),
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
    final marketPrices = ref.watch(marketDataNotifierProvider);

    const double initialBalance = 10.00;
    double totalRealizedPnL = 0.0;

    Map<String, double> positions = {};
    Map<String, double> avgPrices = {};
    List<double> pnlHistory = [0.0];
    
    int closedTrades = 0;
    int winningTrades = 0;

    for (var r in reports.reversed) {
      totalRealizedPnL += r.realizedPnl;
      pnlHistory.add(totalRealizedPnL);

      double posQty = positions[r.symbol] ?? 0.0;
      double avgPrice = avgPrices[r.symbol] ?? 0.0;

      bool isClosing = (r.side == "SELL" && posQty > 0.0) || (r.side == "BUY" && posQty < 0.0);
      if (isClosing) {
          closedTrades++;
          if (r.realizedPnl > 0) winningTrades++;
      }

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
      positions[r.symbol] = posQty;
      avgPrices[r.symbol] = avgPrice;
    }

    final currentBalance = initialBalance + totalRealizedPnL;
    double totalUnrealizedPnL = 0.0;
    int activePositionsCount = 0;

    positions.forEach((symbol, qty) {
      if (qty.abs() > 0.000001) {
        activePositionsCount++;
        double currentPrice = marketPrices[symbol] ?? avgPrices[symbol] ?? 0.0;
        if (currentPrice > 0) {
          totalUnrealizedPnL += qty > 0
              ? (currentPrice - avgPrices[symbol]!) * qty
              : (avgPrices[symbol]! - currentPrice) * qty.abs();
        }
      }
    });

    double winRate = closedTrades > 0 ? (winningTrades / closedTrades) * 100 : 0.0;
    final bool isDefensiveMode = ((initialBalance - currentBalance) / initialBalance) > 0.15;

    return Scaffold(
      appBar: _buildAppBar(isDefensiveMode),
      body: Column(
        children: [
          _buildMarketTickerTape(marketPrices),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;

                if (isDesktop) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120, 
                          child: _buildStatsRow(currentBalance, totalRealizedPnL, totalUnrealizedPnL, activePositionsCount, winRate)
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch, 
                            children: [
                              Expanded(flex: 3, child: _buildChartContainer("KÜMÜLATİF PnL", PnLChartPainter(pnlHistory), totalRealizedPnL)),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildOpenPositionsPanel(positions, avgPrices, marketPrices)),
                              const SizedBox(width: 16),
                              Expanded(flex: 4, child: _buildDenseTradeLog(reports, true)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView(
                    padding: const EdgeInsets.all(12.0),
                    children: [
                      _buildStatsGrid(constraints.maxWidth, currentBalance, totalRealizedPnL, totalUnrealizedPnL, activePositionsCount, winRate),
                      const SizedBox(height: 16),
                      SizedBox(height: 280, child: _buildChartContainer("KÜMÜLATİF PnL", PnLChartPainter(pnlHistory), totalRealizedPnL)),
                      const SizedBox(height: 16),
                      SizedBox(height: 300, child: _buildOpenPositionsPanel(positions, avgPrices, marketPrices)),
                      const SizedBox(height: 16),
                      SizedBox(height: 500, child: _buildDenseTradeLog(reports, false)),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(bool isDefensive) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.security, color: Colors.amberAccent, size: 24),
          const SizedBox(width: 10),
          const Flexible(
            child: Text('SENTINEL', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 16),
          _buildSystemStatusBadge(isDefensive),
        ],
      ),
    );
  }

  Widget _buildMarketTickerTape(Map<String, double> marketPrices) {
    return Container(
      height: 38,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0F),
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: marketPrices.isEmpty
          ? const Center(child: Text("Borsa Veri Akışı Bekleniyor...", style: TextStyle(color: Colors.white38, fontSize: 12)))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: marketPrices.length,
              itemBuilder: (context, index) {
                final symbol = marketPrices.keys.elementAt(index);
                final price = marketPrices.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "${symbol.replaceAll('usdt', '').toUpperCase()} ", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
                          TextSpan(text: price.toStringAsFixed(2), style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Tooltip(
      message: isDefensive 
        ? "SELF-HEALING AKTİF: Kasa %15'ten fazla eridi. Risk motoru defansif moda geçti."
        : "SİSTEM STABİL: HFT algoritmaları ve Sniper Modu maksimum performans ile çalışıyor.",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDefensive ? Colors.orange.withOpacity(0.15) : Colors.blueAccent.withOpacity(0.15), 
          borderRadius: BorderRadius.circular(4), 
          border: Border.all(color: isDefensive ? Colors.orangeAccent : Colors.blueAccent)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isDefensive ? Icons.warning_amber_rounded : Icons.online_prediction, color: isDefensive ? Colors.orangeAccent : Colors.blueAccent, size: 14),
            const SizedBox(width: 6),
            Text(isDefensive ? "DEFANS M." : "AKTİF", style: TextStyle(color: isDefensive ? Colors.orangeAccent : Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(double bal, double rpnl, double upnl, int posCount, double winRate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildStatCard("CÜZDAN (NET)", "\$${bal.toStringAsFixed(3)}", Colors.white, "Sermaye + Kâr")),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard("KAPANAN PnL", "\$${rpnl.toStringAsFixed(3)}", rpnl >= 0 ? Colors.greenAccent : Colors.redAccent, "Realize Edilen")),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard("AÇIK PnL", "\$${upnl.toStringAsFixed(3)}", upnl >= 0 ? Colors.greenAccent : Colors.redAccent, "Yüzen (Floating)")),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard("WIN RATE", "%${winRate.toStringAsFixed(1)}", winRate >= 50 ? Colors.blueAccent : Colors.orangeAccent, "Kazanma Oranı")),
        const SizedBox(width: 12),
        Expanded(child: _buildKillSwitch()),
      ],
    );
  }

  Widget _buildStatsGrid(double width, double bal, double rpnl, double upnl, int posCount, double winRate) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: width > 500 ? 3 : 2, 
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.7, 
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard("CÜZDAN", "\$${bal.toStringAsFixed(3)}", Colors.white, "Net Bakiye"),
        _buildStatCard("REALIZED", "\$${rpnl.toStringAsFixed(3)}", rpnl >= 0 ? Colors.greenAccent : Colors.redAccent, "Kapanan K/Z"),
        _buildStatCard("FLOATING", "\$${upnl.toStringAsFixed(3)}", upnl >= 0 ? Colors.greenAccent : Colors.redAccent, "Açık İşlemler"),
        _buildStatCard("WIN RATE", "%${winRate.toStringAsFixed(1)}", winRate >= 50 ? Colors.blueAccent : Colors.orangeAccent, "Başarı Oranı"),
        _buildKillSwitch(),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color valueColor, String subtitle) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'monospace'))),
            const SizedBox(height: 4),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white38, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitch() {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kill Switch İletildi!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent));
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new, color: Colors.redAccent, size: 26), SizedBox(height: 6),
            Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(String title, CustomPainter painter, double currentPnl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Text("${currentPnl >= 0 ? '+' : ''}\$${currentPnl.toStringAsFixed(2)}", style: TextStyle(color: currentPnl >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: ClipRect(child: CustomPaint(painter: painter, size: Size.infinite))),
        ],
      ),
    );
  }

  Widget _buildOpenPositionsPanel(Map<String, double> positions, Map<String, double> avgPrices, Map<String, double> marketPrices) {
    List<Widget> rows = [];
    
    positions.forEach((symbol, qty) {
      if (qty.abs() > 0.000001) {
        double currentPrice = marketPrices[symbol] ?? avgPrices[symbol] ?? 0.0;
        double pnl = qty > 0 ? (currentPrice - avgPrices[symbol]!) * qty : (avgPrices[symbol]! - currentPrice) * qty.abs();
        double pnlPct = (currentPrice - avgPrices[symbol]!) / avgPrices[symbol]! * 100 * (qty > 0 ? 1 : -1);
        Color pnlColor = pnl >= 0 ? Colors.greenAccent : Colors.redAccent;
        
        rows.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(symbol.replaceAll('USDT', ''), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(flex: 2, child: Container(
                alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(color: qty > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(qty > 0 ? "LONG" : "SHORT", style: TextStyle(color: qty > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)),
              )),
              Expanded(flex: 4, child: Text("\$${avgPrices[symbol]!.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 12))),
              Expanded(flex: 4, child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(3)}", style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13)),
                  Text("${pnlPct >= 0 ? '+' : ''}${pnlPct.toStringAsFixed(2)}%", style: TextStyle(color: pnlColor.withOpacity(0.8), fontSize: 10)),
                ],
              )),
            ],
          ),
        ));
        rows.add(const Divider(height: 1, color: Colors.white10));
      }
    });

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("AÇIK POZİSYONLAR", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text("COIN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Center(child: Text("YÖN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)))),
                Expanded(flex: 4, child: Text("GİRİŞ F.", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 4, child: Text("K/Z (PnL)", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Expanded(
            child: rows.isEmpty 
              ? const Center(child: Text("Aktif pozisyon bulunmuyor.", style: TextStyle(color: Colors.white38, fontSize: 12)))
              : ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: rows)
          ),
        ],
      ),
    );
  }

  Widget _buildDenseTradeLog(List<ExecutionReport> reports, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("CANLI İŞLEM DEFTERİ", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(flex: isDesktop ? 2 : 3, child: const Text("ZAMAN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                const Expanded(flex: 1, child: Center(child: Text("YÖN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 8),
                const Expanded(flex: 2, child: Text("COIN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                const Expanded(flex: 2, child: Text("FİYAT", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                const Expanded(flex: 2, child: Text("NET PnL", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Expanded(
            child: reports.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                    itemBuilder: (context, index) {
                      final r = reports[index];
                      final isBuy = r.side == "BUY";
                      final pnlColor = r.realizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent;
                      final timeStr = DateTime.fromMillisecondsSinceEpoch(r.timestamp.toInt()).toString().substring(11, isDesktop ? 19 : 16); 
                      final symbolClean = r.symbol.replaceAll('usdt', '').replaceAll('USDT', '').toUpperCase();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(flex: isDesktop ? 2 : 3, child: FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(timeStr, style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace')))),
                            Expanded(flex: 1, child: Container(
                              alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(r.side, style: TextStyle(color: isBuy ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                            )),
                            const SizedBox(width: 8),
                            Expanded(flex: 2, child: Row(
                              children: [
                                Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: symbolClean == "BTC" ? Colors.orange : (symbolClean == "ETH" ? Colors.blue : (symbolClean == "SOL" ? Colors.purpleAccent : Colors.yellow))),
                                ),
                                const SizedBox(width: 6),
                                Expanded(child: FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(symbolClean, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)))),
                              ],
                            )),
                            Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown, child: Text("\$${r.executionPrice.toStringAsFixed(1)}", textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.white70)))),
                            Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown, child: Text("${r.realizedPnl >= 0 ? '+' : ''}${r.realizedPnl.toStringAsFixed(3)}", textAlign: TextAlign.right, style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13)))),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
          const SizedBox(height: 24),
          const Text("Sistem Isınıyor (Blindspot Bekleniyor)", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Piyasadan geçmiş vektörler toplanıyor...", style: TextStyle(color: Colors.white54, fontSize: 12)),
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
    
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 1;
    for(int i=1; i<4; i++) {
      double y = size.height * (i/4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final isProfit = history.last >= 0;
    final paint = Paint()
      ..color = isProfit ? Colors.greenAccent : Colors.redAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
      
    final minPnl = history.reduce(min);
    final maxPnl = history.reduce(max);
    final range = (maxPnl - minPnl) == 0 ? 1.0 : (maxPnl - minPnl);
    final paddedRange = range * 1.3; 
    final paddedMin = minPnl - (range * 0.15);
    
    final path = Path();
    final dx = size.width / (history.length > 1 ? history.length - 1 : 1);
    
    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      final normalizedY = (history[i] - paddedMin) / paddedRange;
      final y = size.height - (normalizedY * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * dx;
        final prevY = size.height - (((history[i - 1] - paddedMin) / paddedRange) * size.height);
        path.cubicTo(prevX + (dx / 2), prevY, prevX + (dx / 2), y, x, y);
      }
    }
    
    if (minPnl < 0 && maxPnl > 0) {
      final zeroY = size.height - ((0 - paddedMin) / paddedRange) * size.height;
      final zeroPaint = Paint()..color = Colors.white38..strokeWidth = 1.0..style = PaintingStyle.stroke;
      for (double i = 0; i < size.width; i += 10) {
        canvas.drawLine(Offset(i, zeroY), Offset(i + 5, zeroY), zeroPaint);
      }
    }
    
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    final gradient = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter, 
      colors: [paint.color.withOpacity(0.3), paint.color.withOpacity(0.0)]
    );
    canvas.drawPath(fillPath, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    
    canvas.drawShadow(path, paint.color, 4.0, false); 
    canvas.drawPath(path, paint);

    final lastY = size.height - (((history.last - paddedMin) / paddedRange) * size.height);
    canvas.drawCircle(Offset(size.width, lastY), 5, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(size.width, lastY), 3, Paint()..color = paint.color);
  }
  
  @override
  bool shouldRepaint(covariant PnLChartPainter oldDelegate) => true;
}