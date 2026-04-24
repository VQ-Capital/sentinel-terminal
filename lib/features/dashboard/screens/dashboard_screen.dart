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
  @override
  void initState() {
    super.initState();
    ref.read(vqPipelineProvider); // Veri akışını başlat
  }

  @override
  Widget build(BuildContext context) {
    // İş mantığını provider'dan çekiyoruz. (Arayüzde hesaplama yok!)
    final metrics = ref.watch(dashboardMetricsProvider);

    return Scaffold(
      appBar: TerminalAppBar(isDefensiveMode: metrics.isDefensiveMode),
      body: Column(
        children: [
          const MarketTickerTape(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 1000;

                if (isDesktop) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        StatsPanel(metrics: metrics, isDesktop: true),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(flex: 3, child: PnlChartWidget(history: metrics.pnlHistory, currentPnl: metrics.displayRealizedPnL)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2, 
                                      child: Column(
                                        children: const [
                                          Expanded(flex: 6, child: ZScoreRadarPanel()),
                                          SizedBox(height: 16),
                                          Expanded(flex: 4, child: SlaHeatmapPanel()),
                                        ],
                                      )
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(flex: 2, child: LatencyChartWidget(latencies: metrics.recentLatencies, avgLatency: metrics.avgLatency)),
                                    const SizedBox(width: 16),
                                    Expanded(flex: 3, child: OpenPositionsPanel(positions: metrics.positions, avgPrices: metrics.avgPrices)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Expanded(
                                flex: 5,
                                child: TradeLogPanel(isDesktop: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // MOBİL GÖRÜNÜM
                  return ListView(
                    padding: const EdgeInsets.all(12.0),
                    children: [
                      StatsPanel(metrics: metrics, isDesktop: false),
                      const SizedBox(height: 16),
                      SizedBox(height: 250, child: PnlChartWidget(history: metrics.pnlHistory, currentPnl: metrics.displayRealizedPnL)),
                      const SizedBox(height: 16),
                      const SizedBox(height: 220, child: ZScoreRadarPanel()),
                      const SizedBox(height: 16),
                      const SlaHeatmapPanel(),
                      const SizedBox(height: 16),
                      SizedBox(height: 200, child: LatencyChartWidget(latencies: metrics.recentLatencies, avgLatency: metrics.avgLatency)),
                      const SizedBox(height: 16),
                      SizedBox(height: 300, child: OpenPositionsPanel(positions: metrics.positions, avgPrices: metrics.avgPrices)),
                      const SizedBox(height: 16),
                      const SizedBox(height: 500, child: TradeLogPanel(isDesktop: false)),
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
}