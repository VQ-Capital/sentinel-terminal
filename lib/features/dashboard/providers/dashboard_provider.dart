// ========== DOSYA: sentinel-terminal/lib/features/dashboard/providers/dashboard_provider.dart ==========
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

// Başlangıç bakiyesini ilk gelen veriden yakalamak için global değişken (veya ayrı bir provider)
double? _capturedInitialBalance;

class DashboardMetrics {
  final double displayBalance;
  final double displayEquity;
  final double displayRealizedPnL;
  final double displayUnrealizedPnL;
  final double winRate;
  final int avgLatency;
  final bool isDefensiveMode;
  final List<double> balanceHistory;
  final List<double> equityHistory;
  final List<int> recentLatencies;
  final Map<String, double> positions;
  final Map<String, double> avgPrices;
  final double maxDrawdownPct;
  final double sharpeRatio;

  DashboardMetrics({
    required this.displayBalance, required this.displayEquity, required this.displayRealizedPnL,
    required this.displayUnrealizedPnL, required this.winRate, required this.avgLatency,
    required this.isDefensiveMode, required this.balanceHistory, required this.equityHistory,
    required this.recentLatencies, required this.positions, required this.avgPrices,
    required this.maxDrawdownPct, required this.sharpeRatio,
  });
}

final dashboardMetricsProvider = Provider<DashboardMetrics>((ref) {
  final reports = ref.watch(reportListProvider);
  final marketPrices = ref.watch(marketDataNotifierProvider);
  final equityData = ref.watch(equityProvider);

  // 🚀 DÜZELTME: Sabit 100K değeri kaldırıldı!
  // Eğer henüz veri gelmediyse 0, geldiyse ilk gelen bakiyeyi baz alıyoruz.
  if (_capturedInitialBalance == null && equityData != null) {
    _capturedInitialBalance = equityData.availableMarginUsd;
  }
  
  final double initialBalance = _capturedInitialBalance ?? (equityData?.availableMarginUsd ?? 0.0);

  double localBalance = initialBalance;
  List<double> balanceHistory = [initialBalance];
  List<double> equityHistory = [initialBalance];
  Map<String, double> positions = {};
  Map<String, double> avgPrices = {};
  int closedTrades = 0; 
  int winningTrades = 0;

  List<int> recentLatencies = reports.take(100).map((r) => r.latencyMs.toInt()).toList().reversed.toList();
  int avgLatency = recentLatencies.isEmpty ? 0 : (recentLatencies.reduce((a, b) => a + b) / recentLatencies.length).round();

  for (var r in reports.reversed) {
    localBalance += r.realizedPnl;
    balanceHistory.add(localBalance);
    equityHistory.add(localBalance + (equityData?.totalUnrealizedPnl ?? 0.0));

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

  double winRate = closedTrades > 0 ? (winningTrades / closedTrades) * 100 : 0.0;
  
  // Realized PnL: Mevcut Bakiye - Başlangıç Bakiyesi
  double currentBalance = equityData?.availableMarginUsd ?? localBalance;

  return DashboardMetrics(
    displayBalance: currentBalance,
    displayEquity: equityData?.totalEquityUsd ?? currentBalance,
    displayRealizedPnL: currentBalance - initialBalance, // 🚀 ARTIK DİNAMİK: 1000 - 1000 = 0
    displayUnrealizedPnL: equityData?.totalUnrealizedPnl ?? 0.0,
    winRate: winRate,
    avgLatency: avgLatency,
    isDefensiveMode: (equityData?.maxDrawdownPct ?? 0.0) > 15.0,
    balanceHistory: balanceHistory,
    equityHistory: equityHistory,
    recentLatencies: recentLatencies,
    positions: positions,
    avgPrices: avgPrices,
    maxDrawdownPct: equityData?.maxDrawdownPct ?? 0.0,
    sharpeRatio: equityData?.sharpeRatio ?? 0.0,
  );
});