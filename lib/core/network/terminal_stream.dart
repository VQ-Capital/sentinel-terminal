// ========== DOSYA: sentinel-terminal/lib/core/network/terminal_stream.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../generated/sentinel/api/v1/bundle.pb.dart';
import '../../generated/sentinel/market/v1/market_data.pb.dart';
import '../../generated/sentinel/execution/v1/execution.pb.dart';

String getWebSocketUrl() {
  const envUrl = String.fromEnvironment('WS_URL', defaultValue: '');
  if (envUrl.isNotEmpty) return envUrl;

  if (kIsWeb) {
    final host = Uri.base.host;
    return 'ws://$host:8080/ws/v1/pipeline';
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    return 'ws://10.0.2.2:8080/ws/v1/pipeline';
  } else {
    return 'ws://127.0.0.1:8080/ws/v1/pipeline';
  }
}

final vqPipelineProvider = StreamProvider<StreamBundle>((ref) async* {
  final wsUrl = getWebSocketUrl();
  int retryCount = 0;

  while (true) {
    try {
      debugPrint("🔗 API Ağ Geçidine Bağlanılıyor: $wsUrl");
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
        
        yield bundle;
      }
    } catch (e) {
      debugPrint("⚠️ WebSocket Bağlantı Hatası: $e");
    }

    retryCount++;
    final delay = (retryCount * 2).clamp(2, 10);
    debugPrint("🔌 Bağlantı koptu. $delay saniye sonra yeniden denenecek...");
    await Future.delayed(Duration(seconds: delay));
  }
});

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