import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart'; // Web/Platform tespiti için

import '../../generated/sentinel/api/v1/bundle.pb.dart';
import '../../generated/sentinel/market/v1/market_data.pb.dart';
import '../../generated/sentinel/execution/v1/execution.pb.dart';

// 1. DİNAMİK URL ÇÖZÜCÜ
// Derleme anında WS_URL verilmişse onu kullan, verilmemişse platforma göre varsayılanı seç.
String getWebSocketUrl() {
  const envUrl = String.fromEnvironment('WS_URL', defaultValue: '');
  if (envUrl.isNotEmpty) return envUrl;

  // Ortam değişkeni yoksa varsayılan fallback'ler:
  if (kIsWeb) {
    // Web uygulamasında, uygulamayı sunan host'un kendi IP'sine bağlan
    final host = Uri.base.host;
    return 'ws://$host:8080/ws/v1/pipeline';
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    // Android emülatör bilgisayarın localhost'una 10.0.2.2'den erişir
    return 'ws://10.0.2.2:8080/ws/v1/pipeline';
  } else {
    // Linux/macOS Native
    return 'ws://127.0.0.1:8080/ws/v1/pipeline';
  }
}

// Ana WebSocket Akışı
final vqPipelineProvider = StreamProvider<StreamBundle>((ref) {
  final wsUrl = getWebSocketUrl();
  print("🔗 Bağlanılan API Ağ Geçidi: $wsUrl");
  
  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  
  ref.onDispose(() => channel.sink.close());
  
  return channel.stream.map((bin) => StreamBundle.fromBuffer(bin as List<int>));
});

// Filtrelenmiş Execution Raporları
final executionReportsProvider = StreamProvider<ExecutionReport>((ref) async* {
  final pipeline = ref.watch(vqPipelineProvider.stream);
  await for (final bundle in pipeline) {
    if (bundle.hasReport()) yield bundle.report;
  }
});

// Filtrelenmiş Canlı Fiyatlar
final liveTradesProvider = StreamProvider<AggTrade>((ref) async* {
  final pipeline = ref.watch(vqPipelineProvider.stream);
  await for (final bundle in pipeline) {
    if (bundle.hasTrade()) yield bundle.trade;
  }
});

// Tüm raporları biriktiren Notifier
class ReportNotifier extends FamilyNotifier<List<ExecutionReport>, String> {
  @override
  List<ExecutionReport> build(String arg) => [];

  void addReport(ExecutionReport report) {
    state = [report, ...state];
  }
}

final reportListProvider = NotifierProviderFamily<ReportNotifier, List<ExecutionReport>, String>(
  () => ReportNotifier(),
);