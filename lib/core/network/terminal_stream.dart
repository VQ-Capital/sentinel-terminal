// ========== DOSYA: sentinel-terminal/lib/core/network/terminal_stream.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../generated/sentinel/api/v1/bundle.pb.dart';
import '../../generated/sentinel/market/v1/market_data.pb.dart';
import '../../generated/sentinel/execution/v1/execution.pb.dart';
import '../../generated/sentinel/wallet/v1/wallet.pb.dart';

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
        final bundle = StreamBundle.fromBuffer(bin as List<int>);
        
        if (bundle.hasReport()) {
          ref.read(reportListProvider.notifier).addReport(bundle.report);
        }
        if (bundle.hasTrade()) {
          ref.read(marketDataNotifierProvider.notifier).updatePrice(bundle.trade.symbol, bundle.trade.price);
        }
        if (bundle.hasEquity()) {
          ref.read(equityProvider.notifier).updateEquity(bundle.equity);
        }
        // ✅ YENİ: Z-Score Vektörlerini yakala
        if (bundle.hasVector()) {
          ref.read(zScoreProvider.notifier).updateVector(bundle.vector);
        }
        
        yield bundle;
      }
    } catch (e) {
      debugPrint("⚠️ WebSocket Hatası: $e");
    }
    retryCount++;
    await Future.delayed(Duration(seconds: (retryCount * 2).clamp(2, 10)));
  }
});

// ✅ YENİ STATE MANAGER: Z-Score Radar Data
class ZScoreNotifier extends Notifier<Map<String, MarketStateVector>> {
  @override
  Map<String, MarketStateVector> build() => {};
  void updateVector(MarketStateVector vector) {
    state = {...state, vector.symbol: vector};
  }
}
final zScoreProvider = NotifierProvider<ZScoreNotifier, Map<String, MarketStateVector>>(() => ZScoreNotifier());



// YENİ STATE MANAGER: EquityProvider
class EquityNotifier extends Notifier<EquitySnapshot?> {
  @override
  EquitySnapshot? build() => null;
  void updateEquity(EquitySnapshot equity) { state = equity; }
}
final equityProvider = NotifierProvider<EquityNotifier, EquitySnapshot?>(() => EquityNotifier());

// YENİ: MULTI-COIN FİYAT YÖNETİCİSİ
class MarketDataNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => {};

  void updatePrice(String symbol, double price) {
    // Performansı korumak için referansı kopyalayarak atama yapıyoruz
    final newState = Map<String, double>.from(state);
    newState[symbol] = price;
    state = newState;
  }
}
final marketDataNotifierProvider = NotifierProvider<MarketDataNotifier, Map<String, double>>(() => MarketDataNotifier());


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

final reportListProvider = NotifierProvider<ReportNotifier, List<ExecutionReport>>(
  () => ReportNotifier(),
);