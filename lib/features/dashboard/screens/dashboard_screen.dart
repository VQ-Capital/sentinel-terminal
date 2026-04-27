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
    // VQ-Pipeline: NATS Protobuf akışını enjektör gibi başlat
    ref.read(vqPipelineProvider); 
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(dashboardMetricsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 1100; // Geniş ekran takibi

    return Scaffold(
      appBar: TerminalAppBar(isDefensiveMode: metrics.isDefensiveMode),
      body: Column(
        children: [
          const MarketTickerTape(), // Borsalardan gelen canlı tick verisi
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
  // 🏛️ KURUMSAL DESKTOP YERLEŞİMİ (INVESTOR READY)
  // ==============================================================================
  Widget _buildInstitutionalDesktopLayout(DashboardMetrics metrics) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // 1. ÜST PANEL: Cüzdan, Equity, Drawdown ve Sharpe Kartları
          StatsPanel(metrics: metrics, isDesktop: true),
          
          const SizedBox(height: 12),
          
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SOL SÜTUN: Finansal Sağlık (Grafik ve Pozisyonlar)
                Expanded(
                  flex: 35,
                  child: Column(
                    children: [
                      // Dual-Line Equity & Balance Chart (Yatırımcının en çok bakacağı yer)
                      Expanded(
                        flex: 45, 
                        child: PnlChartWidget(
                          balanceHistory: metrics.balanceHistory,
                          equityHistory: metrics.equityHistory,
                          currentPnl: metrics.displayRealizedPnL,
                        )
                      ),
                      const SizedBox(height: 12),
                      // Canlı Açık Pozisyonlar Tablosu (Giriş Fiyatı ve Floating PnL)
                      Expanded(
                        flex: 55, 
                        child: OpenPositionsPanel(
                          positions: metrics.positions, 
                          avgPrices: metrics.avgPrices
                        )
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // ORTA SÜTUN: AI & Vektörel Karar Merkezi
                const Expanded(
                  flex: 30,
                  child: ZScoreRadarPanel(), // 4-Boyutlu Z-Score füzyonu
                ),
                
                const SizedBox(width: 12),
                
                // SAĞ SÜTUN: Sistem Güvenilirliği & İşlem Kaydı
                Expanded(
                  flex: 35,
                  child: Column(
                    children: [
                      // SLA Watchdog: Borsa gecikme analizi
                      Expanded(
                        flex: 30, 
                        child: LatencyChartWidget(
                          latencies: metrics.recentLatencies, 
                          avgLatency: metrics.avgLatency
                        )
                      ),
                      const SizedBox(height: 12),
                      // Kurumsal İşlem Defteri (Order ID, Commission, Slippage Dahil)
                      const Expanded(
                        flex: 70, 
                        child: TradeLogPanel(isDesktop: true)
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
        // AI & PİYASA SEKİMESİ
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            StatsPanel(metrics: metrics, isDesktop: false),
            const SizedBox(height: 12),
            const SizedBox(height: 550, child: ZScoreRadarPanel()),
          ],
        ),
        // PORTFÖY & GRAFİK SEKİMESİ
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            SizedBox(
              height: 250, 
              child: PnlChartWidget(
                balanceHistory: metrics.balanceHistory,
                equityHistory: metrics.equityHistory,
                currentPnl: metrics.displayRealizedPnL
              )
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 500, 
              child: OpenPositionsPanel(
                positions: metrics.positions, 
                avgPrices: metrics.avgPrices
              )
            ),
          ],
        ),
        // SİSTEM & LOG SEKİMESİ
        ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SlaHeatmapPanel(),
            const SizedBox(height: 12),
            SizedBox(
              height: 200, 
              child: LatencyChartWidget(
                latencies: metrics.recentLatencies, 
                avgLatency: metrics.avgLatency
              )
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 650, child: TradeLogPanel(isDesktop: false)),
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
        BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'AI Radar'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Portföy'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Loglar'),
      ],
    );
  }
}