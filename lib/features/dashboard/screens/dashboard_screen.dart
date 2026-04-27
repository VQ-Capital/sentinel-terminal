// ========== DOSYA: sentinel-terminal/lib/features/dashboard/screens/dashboard_screen.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/top_bar_widgets.dart';
import '../widgets/charts_widget.dart';
import '../widgets/tables_widget.dart';
import '../widgets/neural_map_widget.dart'; // 🚀 Yeni widget import edildi

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
    ref.read(vqPipelineProvider); // NATS Akışını başlat
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(dashboardMetricsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 1100;

    return Scaffold(
      appBar: TerminalAppBar(isDefensiveMode: metrics.isDefensiveMode),
      body: Column(
        children: [
          const MarketTickerTape(), 
          Expanded(
            child: isDesktop 
                ? _buildInstitutionalDesktopLayout(metrics) 
                : _buildMobileLayout(metrics),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(),
    );
  }

  // ==============================================================================
  // 🏛️ KURUMSAL DESKTOP YERLEŞİMİ (EKSİKSİZ VERİ PARAMETRELERİ)
  // ==============================================================================
  Widget _buildInstitutionalDesktopLayout(DashboardMetrics metrics) {
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
                // 1. SOL SÜTUN: Grafik & Pozisyonlar
                Expanded(
                  flex: 35,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 40, 
                        child: PnlChartWidget(
                          balanceHistory: metrics.balanceHistory,
                          equityHistory: metrics.equityHistory,
                          currentPnl: metrics.displayRealizedPnL,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        flex: 60, 
                        child: OpenPositionsPanel(
                          positions: metrics.positions, 
                          avgPrices: metrics.avgPrices,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 2. ORTA SÜTUN: LIVE NEURAL GALAXY 🌌
                const Expanded(
                  flex: 30,
                  child: NeuralGalaxyPanel(), 
                ),
                
                const SizedBox(width: 12),
                
                // 3. SAĞ SÜTUN: Radar & Loglar
                Expanded(
                  flex: 35,
                  child: Column(
                    children: [
                      // Radar (Z-Score Sliders)
                      const Expanded(flex: 35, child: ZScoreRadarPanel()),
                      const SizedBox(height: 12),
                      // Latency & Logs
                      Expanded(
                        flex: 65, 
                        child: Column(
                          children: [
                            Expanded(flex: 30, child: LatencyChartWidget(
                              latencies: metrics.recentLatencies, 
                              avgLatency: metrics.avgLatency,
                            )),
                            const SizedBox(height: 12),
                            const Expanded(flex: 70, child: TradeLogPanel(isDesktop: true)),
                          ],
                        ),
                      ),
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

  // ==============================================================================
  // 📱 MOBİL YERLEŞİM (YÖNETİCİ TAKİBİ)
  // ==============================================================================
  Widget _buildMobileLayout(DashboardMetrics metrics) {
    return IndexedStack(
      index: _mobileSelectedIndex,
      children: [
        // AI RADAR & GALAXY
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            StatsPanel(metrics: metrics, isDesktop: false),
            const SizedBox(height: 12),
            const SizedBox(height: 400, child: NeuralGalaxyPanel()),
            const SizedBox(height: 12),
            const SizedBox(height: 500, child: ZScoreRadarPanel()),
          ],
        ),
        // PORTFÖY
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            SizedBox(height: 250, child: PnlChartWidget(
              balanceHistory: metrics.balanceHistory,
              equityHistory: metrics.equityHistory,
              currentPnl: metrics.displayRealizedPnL
            )),
            const SizedBox(height: 12),
            SizedBox(height: 500, child: OpenPositionsPanel(
              positions: metrics.positions, 
              avgPrices: metrics.avgPrices
            )),
          ],
        ),
        // SİSTEM
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SlaHeatmapPanel(),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: LatencyChartWidget(
              latencies: metrics.recentLatencies, 
              avgLatency: metrics.avgLatency
            )),
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
      unselectedItemColor: Colors.white24,
      currentIndex: _mobileSelectedIndex,
      onTap: (index) => setState(() => _mobileSelectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Neural'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Cüzdan'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Loglar'),
      ],
    );
  }
}