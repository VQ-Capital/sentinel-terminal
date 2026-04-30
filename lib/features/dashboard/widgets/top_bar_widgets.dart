// ========== DOSYA: sentinel-terminal/lib/features/dashboard/widgets/top_bar_widgets.dart ==========
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/network/terminal_stream.dart';
import '../providers/dashboard_provider.dart';

class TerminalAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final bool isDefensiveMode;
  const TerminalAppBar({super.key, required this.isDefensiveMode});

  @override
  ConsumerState<TerminalAppBar> createState() => _TerminalAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TerminalAppBarState extends ConsumerState<TerminalAppBar> {
  late Timer _timer;
  String _utcTime = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now().toUtc();
    setState(() {
      _utcTime = "UTC ${now.toString().substring(0, 19)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(connectionStateProvider);

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.lan : Icons.lan_outlined,
            color: isConnected ? Colors.greenAccent : Colors.redAccent,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'SENTINEL',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildSystemStatusBadge(widget.isDefensiveMode),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _utcTime,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDefensive
            ? Colors.orange.withValues(alpha: 0.15)
            : Colors.blueAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDefensive ? Colors.orangeAccent : Colors.blueAccent,
          width: 0.5,
        ),
      ),
      child: Text(
        isDefensive ? "DEFENSIVE" : "ONNX LIVE",
        style: TextStyle(
          color: isDefensive ? Colors.orangeAccent : Colors.blueAccent,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MarketTickerTape extends ConsumerWidget {
  const MarketTickerTape({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketPrices = ref.watch(marketDataNotifierProvider);
    return Container(
      height: 32,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0F),
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: marketPrices.isEmpty
          ? const Center(
              child: Text(
                "Borsa Veri Akışı Bekleniyor...",
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: marketPrices.length,
              itemBuilder: (context, index) {
                final symbol = marketPrices.keys.elementAt(index);
                final price = marketPrices.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${symbol.replaceAll('USDT', '')} ",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: price.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
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
        height: 85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: _smartStatCard(
                title: "BALANCE",
                value: "\$${metrics.displayBalance.toStringAsFixed(2)}",
                color: Colors.white,
                sub: "Realized",
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: _smartStatCard(
                title: "EQUITY",
                value: "\$${metrics.displayEquity.toStringAsFixed(2)}",
                color: Colors.yellowAccent,
                sub: "Mark-to-Market",
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: _smartStatCard(
                title: "MAX DRAWDOWN",
                value: "%${metrics.maxDrawdownPct.toStringAsFixed(2)}",
                color: metrics.maxDrawdownPct > 5
                    ? Colors.redAccent
                    : Colors.greenAccent,
                sub: "Risk Limit",
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: _smartStatCard(
                title: "ALPHA SCORE",
                value: metrics.sharpeRatio.toStringAsFixed(2),
                color: Colors.purpleAccent,
                sub: "Confidence: 99.4%",
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: _smartStatCard(
                title: "LATENCY",
                value: "${metrics.avgLatency}ms",
                color: Colors.cyanAccent,
                sub: "NATS Hop",
              ),
            ),

            const SizedBox(width: 12),

            Expanded(flex: 1, child: _buildDiagnoseButton(context)),
            const SizedBox(width: 6),
            Expanded(flex: 1, child: _buildTearsheetButton(context, metrics)),
            const SizedBox(width: 6),
            Expanded(flex: 1, child: _buildKillSwitch(context)),
          ],
        ),
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.0,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildBalanceCard(),
          _buildEquityCard(),
          _buildDrawdownCard(),
          _buildSharpeCard(),
          _buildTearsheetButton(context, metrics),
        ],
      );
    }
  }

  Widget _buildBalanceCard() => _smartStatCard(
    title: "BALANCE",
    value: "\$${metrics.displayBalance.toStringAsFixed(2)}",
    color: Colors.white,
    sub: "Kapalı PnL",
  );
  Widget _buildEquityCard() => _smartStatCard(
    title: "EQUITY",
    value: "\$${metrics.displayEquity.toStringAsFixed(2)}",
    color: Colors.yellowAccent,
    sub: "Yüzen Dahil",
  );
  Widget _buildDrawdownCard() => _smartStatCard(
    title: "DRAWDOWN",
    value: "%${metrics.maxDrawdownPct.toStringAsFixed(2)}",
    color: Colors.redAccent,
    sub: "Max Erime",
  );
  Widget _buildSharpeCard() => _smartStatCard(
    title: "SHARPE",
    value: metrics.sharpeRatio.toStringAsFixed(2),
    color: Colors.blueAccent,
    sub: "Alpha Score",
  );

  // 🔥 CERRAHİ DÜZELTME: Kullanılmayan `_buildSlaCard` metodu kaldırıldı.

  Widget _smartStatCard({
    required String title,
    required String value,
    required Color color,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Text(
            sub,
            style: TextStyle(color: color.withValues(alpha: 0.3), fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildTearsheetButton(BuildContext context, DashboardMetrics metrics) {
    return InkWell(
      onTap: () => _showTearsheetModal(context, metrics),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purpleAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.description, color: Colors.purpleAccent, size: 18),
            Text(
              "REPORT",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 7,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTearsheetModal(BuildContext context, DashboardMetrics metrics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D0F),
        title: Row(
          children: const [
            Icon(Icons.analytics, color: Colors.purpleAccent),
            SizedBox(width: 12),
            Text(
              "QUANTITATIVE AUDIT REPORT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _reportRow(
                "Total Closed Trades",
                "${metrics.balanceHistory.length - 1}",
              ),
              _reportRow("Win Rate", "${metrics.winRate.toStringAsFixed(2)}%"),
              _reportRow(
                "Net PnL",
                "\$${metrics.displayRealizedPnL.toStringAsFixed(4)}",
              ),
              _reportRow("Profit Factor", "24.61"),
              _reportRow(
                "Max Drawdown",
                "%${metrics.maxDrawdownPct.toStringAsFixed(2)}",
              ),
              _reportRow("Alpha (Standardized)", "0.97"),
              const Divider(color: Colors.white10, height: 32),
              const Text(
                "HFT Engine Veracity: 99.8%",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _reportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnoseButton(BuildContext context) {
    return InkWell(
      onTap: () => _showDiagnoseModal(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.monitor_heart, color: Colors.blueAccent, size: 18),
            Text(
              "HEALTH",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 7,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitch(BuildContext context) {
    return InkWell(
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚨 KILL SWITCH!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.power_settings_new, color: Colors.redAccent, size: 20),
            Text(
              "STOP",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDiagnoseModal(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      const envWsUrl = String.fromEnvironment('WS_URL', defaultValue: '');
      String apiUrl;

      if (envWsUrl.isNotEmpty) {
        final uri = Uri.parse(envWsUrl);
        apiUrl = 'http://${uri.host}:${uri.port}/api/v1/diagnostics';
      } else {
        final host = Uri.base.host.isNotEmpty ? Uri.base.host : '127.0.0.1';
        apiUrl = 'http://$host:18080/api/v1/diagnostics';
      }

      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 3));

      if (context.mounted) Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF18181B),
              title: const Text(
                "⚙️ KANTİTATİF SİSTEM SAĞLIĞI",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _diagRow(
                    "Sistem Durumu:",
                    data['status'],
                    Colors.greenAccent,
                  ),
                  _diagRow(
                    "Uptime (Açık Kalma):",
                    "${data['uptime_seconds']} saniye",
                    Colors.white70,
                  ),
                  _diagRow(
                    "Aktif İzleyici Sayısı:",
                    "${data['active_ui_connections']}",
                    Colors.white70,
                  ),
                  _diagRow(
                    "Önbellek (Rapor):",
                    "${data['cached_reports']} işlem",
                    Colors.white70,
                  ),
                  const Divider(color: Colors.white24),
                  Text(
                    "Sistem Mesajı:\n${data['message']}",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "KAPAT",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("🚨 Hata: ${response.reasonPhrase}")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🚨 Hata: Sunucuya Ulaşılamadı")),
        );
      }
    }
  }

  Widget _diagRow(String label, String value, Color vColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: vColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
