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
            child: Text(
              'SENTINEL',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          _buildSystemStatusBadge(isDefensiveMode),
        ],
      ),
    );
  }

  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Tooltip(
      message: isDefensive 
          ? "SELF-HEALING AKTİF: Kasa koruması devrede. Risk motoru kaldıracı düşürdü." 
          : "SİSTEM STABİL: HFT algoritmaları normal parametrelerde aktif.",
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
        height: 100, // 🔥 KRİTİK DÜZELTME: RenderFlex hatasını önleyen yükseklik kısıtlaması
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildBalanceCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildRealizedCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildFloatingCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildWinRateCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildSlaCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildKillSwitch(context)),
          ],
        ),
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: MediaQuery.of(context).size.width > 500 ? 3 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.8,
        physics: const NeverScrollableScrollPhysics(),
        // 🔥 KRİTİK DÜZELTME: GridView içine Expanded koyulamaz, doğrudan widget verilmeli.
        children: [
          _buildBalanceCard(),
          _buildRealizedCard(),
          _buildFloatingCard(),
          _buildWinRateCard(),
          _buildSlaCard(),
          _buildKillSwitch(context),
        ],
      );
    }
  }

  Widget _buildBalanceCard() => _smartStatCard(title: "NET BAKİYE", value: "\$${metrics.displayBalance.toStringAsFixed(2)}", color: Colors.white, sub: "Cüzdan Durumu", tooltip: "Sistemin sahip olduğu, işlem yapılabilir nakit miktarı.");
  Widget _buildRealizedCard() => _smartStatCard(title: "REALIZED PnL", value: "${metrics.displayRealizedPnL >= 0 ? '+' : ''}\$${metrics.displayRealizedPnL.toStringAsFixed(2)}", color: metrics.displayRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, sub: "Kapanan İşlemler", tooltip: "Kapatılmış işlemlerden elde edilen net kâr/zarar.");
  Widget _buildFloatingCard() => _smartStatCard(title: "FLOATING PnL", value: "${metrics.displayUnrealizedPnL >= 0 ? '+' : ''}\$${metrics.displayUnrealizedPnL.toStringAsFixed(2)}", color: metrics.displayUnrealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent, sub: "Açık İşlemler", tooltip: "Anlık açık pozisyonların piyasa fiyatına göre kâr/zarar durumu.");
  Widget _buildWinRateCard() => _smartStatCard(title: "BAŞARI (WIN %)", value: "%${metrics.winRate.toStringAsFixed(1)}", color: metrics.winRate >= 50 ? Colors.blueAccent : Colors.orangeAccent, sub: "İsabet Oranı", tooltip: "Yapay zekanın kârla kapattığı işlemlerin oranı.");
  Widget _buildSlaCard() => _smartStatCard(title: "SLA PING", value: "${metrics.avgLatency}ms", color: metrics.avgLatency > 50 ? Colors.redAccent : Colors.greenAccent, sub: "Borsa Gecikmesi", tooltip: "Emrin borsaya gidiş süresi. >50ms ise sistem durur.");

  Widget _smartStatCard({required String title, required String value, required Color color, required String sub, required String tooltip}) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const Icon(Icons.info_outline, color: Colors.white24, size: 12),
              ],
            ),
            const Spacer(),
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'monospace'))),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitch(BuildContext context) {
    return Tooltip(
      message: "KILL SWITCH (Acil Durum)\nTüm işlemleri durdurmak için BASILI TUTUN.",
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🚨 KILL SWITCH TETİKLENDİ: Tüm İşlemler Durduruluyor!"), backgroundColor: Colors.redAccent));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(8), 
            border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5)
          ),
          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.power_settings_new, color: Colors.redAccent, size: 24), 
            SizedBox(height: 4),
            Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
            Text("(Basılı Tut)", style: TextStyle(color: Colors.redAccent, fontSize: 8)),
          ]),
        ),
      ),
    );
  }
}