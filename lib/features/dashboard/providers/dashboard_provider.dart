import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/terminal_stream.dart';

class DashboardMetrics {
  final double displayBalance;
  final double displayRealizedPnL;
  final double displayUnrealizedPnL;
  final double winRate;
  final int avgLatency;
  final bool isDefensiveMode;
  final List<double> pnlHistory;
  final List<int> recentLatencies;
  final Map<String, double> positions;
  final Map<String, double> avgPrices;

  DashboardMetrics({
    required this.displayBalance,
    required this.displayRealizedPnL,
    required this.displayUnrealizedPnL,
    required this.winRate,
    required this.avgLatency,
    required this.isDefensiveMode,
    required this.pnlHistory,
    required this.recentLatencies,
    required this.positions,
    required this.avgPrices,
  });
}

final dashboardMetricsProvider = Provider<DashboardMetrics>((ref) {
  final reports = ref.watch(reportListProvider);
  final marketPrices = ref.watch(marketDataNotifierProvider);
  final equityData = ref.watch(equityProvider);

  const double initialBalance = 10.00;
  double localRealizedPnL = 0.0;
  List<double> pnlHistory = [0.0];
  Map<String, double> positions = {};
  Map<String, double> avgPrices = {};
  int closedTrades = 0;
  int winningTrades = 0;

  List<int> recentLatencies = reports.take(100).map((r) => r.latencyMs.toInt()).toList().reversed.toList();
  int avgLatency = recentLatencies.isEmpty ? 0 : (recentLatencies.reduce((a, b) => a + b) / recentLatencies.length).round();

  for (var r in reports.reversed) {
    localRealizedPnL += r.realizedPnl;
    pnlHistory.add(localRealizedPnL);

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

  double localUnrealizedPnL = 0.0;
  positions.forEach((symbol, qty) {
    if (qty.abs() > 0.000001) {
      double currentPrice = marketPrices[symbol] ?? avgPrices[symbol] ?? 0.0;
      if (currentPrice > 0) {
        localUnrealizedPnL += qty > 0
            ? (currentPrice - avgPrices[symbol]!) * qty
            : (avgPrices[symbol]! - currentPrice) * qty.abs();
      }
    }
  });

  double winRate = closedTrades > 0 ? (winningTrades / closedTrades) * 100 : 0.0;
  final displayBalance = equityData?.totalEquityUsd ?? (initialBalance + localRealizedPnL);

  return DashboardMetrics(
    displayBalance: displayBalance,
    displayRealizedPnL: displayBalance - initialBalance,
    displayUnrealizedPnL: equityData?.totalUnrealizedPnl ?? localUnrealizedPnL,
    winRate: winRate,
    avgLatency: avgLatency,
    isDefensiveMode: ((initialBalance - displayBalance) / initialBalance) > 0.15,
    pnlHistory: pnlHistory,
    recentLatencies: recentLatencies,
    positions: positions,
    avgPrices: avgPrices,
  );
});