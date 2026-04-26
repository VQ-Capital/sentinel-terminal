// ========== DOSYA: sentinel-terminal/lib/features/dashboard/screens/dashboard_screen.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/top_bar_widgets.dart';
import '../widgets/charts_widget.dart';
import '../widgets/tables_widget.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _mobileSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(vqPipelineProvider); // NATS Veri akışını başlat
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(dashboardMetricsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: TerminalAppBar(isDefensiveMode: metrics.isDefensiveMode),
      body: Column(
        children: [
          const MarketTickerTape(), 
          Expanded(
            child: isDesktop ? _buildDesktopLayout(metrics) : _buildMobileLayout(metrics),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(),
    );
  }

  Widget _buildDesktopLayout(DashboardMetrics metrics) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          StatsPanel(metrics: metrics, isDesktop: true),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(flex: 4, child: PnlChartWidget(history: metrics.pnlHistory, currentPnl: metrics.displayRealizedPnL)),
                      const SizedBox(height: 12),
                      Expanded(flex: 6, child: OpenPositionsPanel(positions: metrics.positions, avgPrices: metrics.avgPrices)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  flex: 4,
                  child: ZScoreRadarPanel(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(flex: 3, child: LatencyChartWidget(latencies: metrics.recentLatencies, avgLatency: metrics.avgLatency)),
                      const SizedBox(height: 12),
                      const Expanded(flex: 7, child: TradeLogPanel(isDesktop: true)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(DashboardMetrics metrics) {
    return IndexedStack(
      index: _mobileSelectedIndex,
      children: [
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            StatsPanel(metrics: metrics, isDesktop: false),
            const SizedBox(height: 12),
            const SizedBox(height: 500, child: ZScoreRadarPanel()),
          ],
        ),
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            SizedBox(height: 250, child: PnlChartWidget(history: metrics.pnlHistory, currentPnl: metrics.displayRealizedPnL)),
            const SizedBox(height: 12),
            SizedBox(height: 500, child: OpenPositionsPanel(positions: metrics.positions, avgPrices: metrics.avgPrices)),
          ],
        ),
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SlaHeatmapPanel(),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: LatencyChartWidget(latencies: metrics.recentLatencies, avgLatency: metrics.avgLatency)),
            const SizedBox(height: 12),
            const SizedBox(height: 600, child: TradeLogPanel(isDesktop: false)),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF121214),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white38,
      currentIndex: _mobileSelectedIndex,
      onTap: (index) => setState(() => _mobileSelectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'AI Radar'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Portföy'),
        BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Sistem'),
      ],
    );
  }
}