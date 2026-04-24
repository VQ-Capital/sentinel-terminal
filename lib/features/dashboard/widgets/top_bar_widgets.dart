// lib/features/dashboard/widgets/top_bar_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';
import '../providers/dashboard_provider.dart';

class TerminalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isDefensiveMode;
  const TerminalAppBar({super.key, required this.isDefensiveMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bağlantı durumunu provider üzerinden anlık dinliyoruz
    final isConnected = ref.watch(connectionStateProvider);

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bağlantı İkonu
          Icon(
            isConnected ? Icons.lan : Icons.lan_outlined,
            color: isConnected ? Colors.greenAccent : Colors.redAccent,
            size: 18,
          ),
          const SizedBox(width: 12),
          const Flexible(
            child: Text(
              'SENTINEL',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          // BURADAKİ HATA DÜZELTİLDİ: Fonksiyon parametreyi artık kabul ediyor.
          _buildSystemStatusBadge(isDefensiveMode),
        ],
      ),
    );
  }

  // Hata veren kısım düzeltildi: bool isDefensive parametresi eklendi.
  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Tooltip(
      message: isDefensive 
          ? "SELF-HEALING AKTİF: Risk motoru defansif moda geçti." 
          : "SİSTEM STABİL: HFT algoritmaları aktif.",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: isDefensive ? Colors.orange.withOpacity(0.15) : Colors.blueAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isDefensive ? Colors.orangeAccent : Colors.blueAccent)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isDefensive ? Icons.warning_amber_rounded : Icons.online_prediction, 
                color: isDefensive ? Colors.orangeAccent : Colors.blueAccent, size: 14),
            const SizedBox(width: 6),
            Text(isDefensive ? "DEFANS M." : "AKTİF", 
                style: TextStyle(color: isDefensive ? Colors.orangeAccent : Colors.blueAccent, 
                fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
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
      height: 38,
      width: double.infinity,
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
                      text: TextSpan(
                        children: [
                          TextSpan(text: "${symbol.replaceAll('usdt', '').replaceAll('USDT', '').toUpperCase()} ", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
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
          children: _buildCards(),
        ),
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: MediaQuery.of(context).size.width > 500 ? 3 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.7,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildCards(),
      );
    }
  }

  List<Widget> _buildCards() {
    return [
      isDesktop ? Expanded(child: _statCard("CÜZDAN", "\$${metrics.displayBalance.toStringAsFixed(3)}", Colors.white, "Net Bakiye")) : _statCard("CÜZDAN", "\$${metrics.displayBalance.toStringAsFixed(3)}", Colors.white, "Net Bakiye"),
      if (isDesktop) const SizedBox(width: 12),
      isDesktop ? Expanded(child: _statCard("REALIZED", "\$${metrics.displayRealizedPnL.toStringAsFixed(3)}", metrics.displayRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, "Kapanan K/Z")) : _statCard("REALIZED", "\$${metrics.displayRealizedPnL.toStringAsFixed(3)}", metrics.displayRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, "Kapanan K/Z"),
      if (isDesktop) const SizedBox(width: 12),
      isDesktop ? Expanded(child: _statCard("FLOATING", "\$${metrics.displayUnrealizedPnL.toStringAsFixed(3)}", metrics.displayUnrealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, "Açık İşlemler")) : _statCard("FLOATING", "\$${metrics.displayUnrealizedPnL.toStringAsFixed(3)}", metrics.displayUnrealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, "Açık İşlemler"),
      if (isDesktop) const SizedBox(width: 12),
      isDesktop ? Expanded(child: _statCard("WIN RATE", "%${metrics.winRate.toStringAsFixed(1)}", metrics.winRate >= 50 ? Colors.blueAccent : Colors.orangeAccent, "Başarı Oranı")) : _statCard("WIN RATE", "%${metrics.winRate.toStringAsFixed(1)}", metrics.winRate >= 50 ? Colors.blueAccent : Colors.orangeAccent, "Başarı Oranı"),
      if (isDesktop) const SizedBox(width: 12),
      isDesktop ? Expanded(child: _statCard("AĞ PING", "${metrics.avgLatency}ms", metrics.avgLatency > 50 ? Colors.redAccent : Colors.greenAccent, "SLA Limit: 50ms")) : _statCard("AĞ PING", "${metrics.avgLatency}ms", metrics.avgLatency > 50 ? Colors.redAccent : Colors.greenAccent, "SLA Limit: 50ms"),
      if (isDesktop) const SizedBox(width: 12),
      isDesktop ? Expanded(child: _killSwitch()) : _killSwitch(),
    ];
  }

  Widget _statCard(String title, String value, Color color, String sub) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'monospace'))),
          const SizedBox(height: 4),
          Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white38, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _killSwitch() {
    return Builder(builder: (context) => InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kill Switch İletildi!"), backgroundColor: Colors.redAccent)),
      child: Container(
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5)),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.power_settings_new, color: Colors.redAccent, size: 26), SizedBox(height: 6),
          Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ]),
      ),
    ));
  }
}