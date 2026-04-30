// ========== DOSYA: sentinel-terminal/lib/core/network/terminal_stream.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../generated/sentinel/api/v1/bundle.pb.dart';
import '../../generated/sentinel/market/v1/market_data.pb.dart';
import '../../generated/sentinel/execution/v1/execution.pb.dart';
import '../../generated/sentinel/wallet/v1/wallet.pb.dart';

final connectionStateProvider = StateProvider<bool>((ref) => false);

String getWebSocketUrl() {
  const envUrl = String.fromEnvironment('WS_URL', defaultValue: '');
  if (envUrl.isNotEmpty) return envUrl;
  if (kIsWeb) {
    final host = Uri.base.host;
    return 'ws://$host:18080/ws/v1/pipeline';
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    return 'ws://10.0.2.2:18080/ws/v1/pipeline';
  } else {
    return 'ws://127.0.0.1:18080/ws/v1/pipeline';
  }
}

final vqPipelineProvider = StreamProvider<StreamBundle>((ref) async* {
  final wsUrl = getWebSocketUrl();
  int retryCount = 0;

  while (true) {
    try {
      final channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      await for (final bin in channel.stream) {
        retryCount = 0;
        ref.read(connectionStateProvider.notifier).state = true;

        final bundle = StreamBundle.fromBuffer(bin as List<int>);

        if (bundle.hasReport()) {
          ref.read(reportListProvider.notifier).addReport(bundle.report);
        }
        if (bundle.hasTrade()) {
          ref
              .read(marketDataNotifierProvider.notifier)
              .updatePrice(bundle.trade.symbol, bundle.trade.price);
        }
        if (bundle.hasEquity()) {
          ref.read(equityProvider.notifier).updateEquity(bundle.equity);
        }
        if (bundle.hasVector()) {
          ref.read(zScoreProvider.notifier).updateVector(bundle.vector);
        }
        // 🔥 YENİ: RCA Loglarını Yakala
        if (bundle.hasRejection()) {
          ref
              .read(rejectionListProvider.notifier)
              .addRejection(bundle.rejection);
        }

        yield bundle;
      }
    } catch (e) {
      debugPrint("⚠️ WebSocket Hatası: $e");
      ref.read(connectionStateProvider.notifier).state = false;
    }

    ref.read(connectionStateProvider.notifier).state = false;
    retryCount++;
    await Future.delayed(Duration(seconds: (retryCount * 2).clamp(2, 10)));
  }
});

// --- State Notifiers ---
class ZScoreNotifier extends Notifier<Map<String, MarketStateVector>> {
  @override
  Map<String, MarketStateVector> build() => {};
  void updateVector(MarketStateVector vector) {
    state = {...state, vector.symbol: vector};
  }
}

final zScoreProvider =
    NotifierProvider<ZScoreNotifier, Map<String, MarketStateVector>>(
      () => ZScoreNotifier(),
    );

class EquityNotifier extends Notifier<EquitySnapshot?> {
  @override
  EquitySnapshot? build() => null;
  void updateEquity(EquitySnapshot equity) {
    state = equity;
  }
}

final equityProvider = NotifierProvider<EquityNotifier, EquitySnapshot?>(
  () => EquityNotifier(),
);

class MarketDataNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => {};
  void updatePrice(String symbol, double price) {
    final newState = Map<String, double>.from(state);
    newState[symbol] = price;
    state = newState;
  }
}

final marketDataNotifierProvider =
    NotifierProvider<MarketDataNotifier, Map<String, double>>(
      () => MarketDataNotifier(),
    );

class ReportNotifier extends Notifier<List<ExecutionReport>> {
  final Set<String> _seenTradeIds = {};
  @override
  List<ExecutionReport> build() => [];
  void addReport(ExecutionReport report) {
    final uniqueId = "${report.symbol}_${report.side}_${report.timestamp}";
    if (!_seenTradeIds.contains(uniqueId)) {
      _seenTradeIds.add(uniqueId);
      state = [report, ...state];
    }
  }
}

final reportListProvider =
    NotifierProvider<ReportNotifier, List<ExecutionReport>>(
      () => ReportNotifier(),
    );

// 🔥 YENİ: RCA Log Notifier
class RejectionNotifier extends Notifier<List<ExecutionRejection>> {
  @override
  List<ExecutionRejection> build() => [];
  void addRejection(ExecutionRejection rej) {
    state = [rej, ...state];
    // Belleği şişirmemek için sadece son 20 reddi tutalım.
    if (state.length > 20) {
      state.removeLast();
    }
  }
}

final rejectionListProvider =
    NotifierProvider<RejectionNotifier, List<ExecutionRejection>>(
      () => RejectionNotifier(),
    );
