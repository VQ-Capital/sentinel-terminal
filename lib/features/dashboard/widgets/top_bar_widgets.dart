// ========== DOSYA: sentinel-terminal/lib/features/dashboard/widgets/top_bar_widgets.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';
import '../providers/dashboard_provider.dart';

class TerminalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isDefensiveMode;
  const TerminalAppBar({super.key, required this.isDefensiveMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectionStateProvider);

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.lan : Icons.lan_outlined,
            color: isConnected ? Colors.greenAccent : Colors.redAccent,
            size: 18,
          ),
          const SizedBox(width: 12),
          const Flexible(
            child: Text('SENTINEL', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18)),
          ),
          const SizedBox(width: 16),
          _buildSystemStatusBadge(isDefensiveMode),
        ],
      ),
    );
  }

  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: isDefensive ? Colors.orange.withOpacity(0.15) : Colors.blueAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isDefensive ? Colors.orangeAccent : Colors.blueAccent)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isDefensive ? Icons.warning_amber_rounded : Icons.online_prediction, color: isDefensive ? Colors.orangeAccent : Colors.blueAccent, size: 14),
          const SizedBox(width: 6),
          Text(isDefensive ? "DEFANS M." : "AKTİF", style: TextStyle(color: isDefensive ? Colors.orangeAccent : Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MarketTickerTape extends ConsumerWidget {
  const MarketTickerTape({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketPrices = ref.watch(marketDataNotifierProvider);
    return Container(
      height: 38, width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0D0D0F), border: Border(bottom: BorderSide(color: Colors.white10, width: 1))),
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
                      text: TextSpan(children: [
                        TextSpan(text: "${symbol.replaceAll('USDT', '')} ", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
                        TextSpan(text: price.toStringAsFixed(2), style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 14)),
                      ]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class StatsPanel extends StatelessWidget {
  final DashboardMetrics metrics;
  final bool isDesktop;
  const StatsPanel({super.key, required this.metrics, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildBalanceCard()), const SizedBox(width: 12),
            Expanded(child: _buildEquityCard()), const SizedBox(width: 12),
            Expanded(child: _buildDrawdownCard()), const SizedBox(width: 12),
            Expanded(child: _buildSharpeCard()), const SizedBox(width: 12),
            Expanded(child: _buildSlaCard()), const SizedBox(width: 12),
            Expanded(child: _buildKillSwitch(context)),
          ],
        ),
      );
    } else {
      return GridView.count(
        shrinkWrap: true, crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.8,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildBalanceCard(), _buildEquityCard(), _buildDrawdownCard(), _buildSharpeCard(), _buildSlaCard(), _buildKillSwitch(context)],
      );
    }
  }

  Widget _buildBalanceCard() => _smartStatCard(title: "GERÇEKLEŞEN (BAL)", value: "\$${metrics.displayBalance.toStringAsFixed(0)}", color: Colors.white, sub: "Kapalı Pozisyonlar", tooltip: "Kapatılmış işlemler sonucu oluşan net nakit bakiye.");
  Widget _buildEquityCard() => _smartStatCard(title: "ÖZSERMAYE (EQT)", value: "\$${metrics.displayEquity.toStringAsFixed(0)}", color: Colors.yellowAccent, sub: "Yüzen Dahil", tooltip: "Açık pozisyonların kâr/zararı dahil kasanın anlık toplam değeri.");
  Widget _buildDrawdownCard() => _smartStatCard(title: "MAX DRAWDOWN", value: "%${metrics.maxDrawdownPct.toStringAsFixed(2)}", color: metrics.maxDrawdownPct > 10 ? Colors.redAccent : Colors.greenAccent, sub: "En Yüksek Kayıp", tooltip: "Zirve noktadan itibaren kasanın yaşadığı maksimum erime oranı.");
  Widget _buildSharpeCard() => _smartStatCard(title: "SHARPE RATIO", value: metrics.sharpeRatio.toStringAsFixed(2), color: metrics.sharpeRatio > 1.5 ? Colors.blueAccent : Colors.orangeAccent, sub: "Risk/Getiri Skoru", tooltip: "Getirinin risk başına verimliliği. 1.5 üzeri kurumsal standarttır.");
  Widget _buildSlaCard() => _smartStatCard(title: "SLA PING", value: "${metrics.avgLatency}ms", color: metrics.avgLatency > 50 ? Colors.redAccent : Colors.greenAccent, sub: "Borsa Gecikmesi", tooltip: "Sistemin borsa ile haberleşme hızı. <20ms idealdir.");

  // 🚀 DÜZELTİLDİ: tooltip parametresi eklendi
  Widget _smartStatCard({required String title, required String value, required Color color, required String sub, required String tooltip}) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            const Spacer(),
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'monospace'))),
            const SizedBox(height: 2), Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitch(BuildContext context) {
    return InkWell(
      onLongPress: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🚨 KILL SWITCH TETİKLENDİ!"), backgroundColor: Colors.redAccent)); },
      child: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.2)]), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5)),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.power_settings_new, color: Colors.redAccent, size: 24), SizedBox(height: 4),
          Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }
}