import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

class OpenPositionsPanel extends ConsumerWidget {
  final Map<String, double> positions;
  final Map<String, double> avgPrices;

  const OpenPositionsPanel({super.key, required this.positions, required this.avgPrices});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketPrices = ref.watch(marketDataNotifierProvider);
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
              Expanded(flex: 2, child: Container(alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 3), decoration: BoxDecoration(color: qty > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(qty > 0 ? "LONG" : "SHORT", style: TextStyle(color: qty > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)))),
              Expanded(flex: 4, child: Text("\$${avgPrices[symbol]!.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 12))),
              Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(3)}", style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13)),
                Text("${pnlPct >= 0 ? '+' : ''}${pnlPct.toStringAsFixed(2)}%", style: TextStyle(color: pnlColor.withOpacity(0.8), fontSize: 10)),
              ])),
            ],
          ),
        ));
        rows.add(const Divider(height: 1, color: Colors.white10));
      }
    });

    return Container(
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(16.0), child: Text("AÇIK POZİSYONLAR", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1))),
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
          Expanded(child: rows.isEmpty ? const Center(child: Text("Aktif pozisyon bulunmuyor.", style: TextStyle(color: Colors.white38, fontSize: 12))) : ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: rows)),
        ],
      ),
    );
  }
}

class TradeLogPanel extends ConsumerWidget {
  final bool isDesktop;
  const TradeLogPanel({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);

    return Container(
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(16.0), child: Text("CANLI İŞLEM DEFTERİ (INSTITUTIONAL LOG)", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1))),
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(flex: 2, child: const Text("ZAMAN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                const Expanded(flex: 1, child: Center(child: Text("YÖN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 8),
                const Expanded(flex: 2, child: Text("COIN", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                if (isDesktop) const Expanded(flex: 2, child: Text("ORDER ID", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                const Expanded(flex: 2, child: Text("FİYAT", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                if (isDesktop) const Expanded(flex: 2, child: Text("SLIPPAGE", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                if (isDesktop) const Expanded(flex: 2, child: Text("FEE", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                const Expanded(flex: 2, child: Text("NET PnL", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Expanded(
            child: reports.isEmpty
                ? const Center(child: Text("Sistem Isınıyor...", style: TextStyle(color: Colors.white54)))
                : ListView.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                    itemBuilder: (context, index) {
                      final r = reports[index];
                      final isBuy = r.side == "BUY";
                      final pnlColor = r.realizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent;
                      final timeStr = DateTime.fromMillisecondsSinceEpoch(r.timestamp.toInt()).toString().substring(11, 19);
                      final symbolClean = r.symbol.replaceAll('USDT', '');
                      
                      // Slippage Hesaplama
                      final slippagePct = r.expectedPrice > 0 ? ((r.executionPrice - r.expectedPrice).abs() / r.expectedPrice) * 100 : 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(timeStr, style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace')))),
                            Expanded(flex: 1, child: Container(alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 3), decoration: BoxDecoration(color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(r.side, style: TextStyle(color: isBuy ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)))),
                            const SizedBox(width: 8),
                            Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(symbolClean, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)))),
                            if (isDesktop) Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(r.orderId.isNotEmpty ? r.orderId : "N/A", style: const TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'monospace')))),
                            Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown, child: Text("\$${r.executionPrice.toStringAsFixed(1)}", textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.white70)))),
                            if (isDesktop) Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown, child: Text("${slippagePct.toStringAsFixed(4)}%", textAlign: TextAlign.right, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontFamily: 'monospace')))),
                            if (isDesktop) Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown, child: Text("\$${r.commission.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontFamily: 'monospace')))),
                            Expanded(flex: 2, child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown, child: Text("${r.realizedPnl >= 0 ? '+' : ''}${r.realizedPnl.toStringAsFixed(2)}", textAlign: TextAlign.right, style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13)))),
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
        children: const [
          CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
          SizedBox(height: 24),
          Text("Sistem Isınıyor (Blindspot Bekleniyor)", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Piyasadan geçmiş vektörler toplanıyor...", style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}