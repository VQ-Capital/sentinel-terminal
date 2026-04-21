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

// AUTO-RECONNECT DESTEKLİ ANA VERİ AKIŞI
final vqPipelineProvider = StreamProvider<StreamBundle>((ref) async* {
  final wsUrl = getWebSocketUrl();
  int retryCount = 0;

  while (true) { // Sonsuz Döngü: Koparsa tekrar dene
    try {
      debugPrint("🔗 API Ağ Geçidine Bağlanılıyor: $wsUrl");
      final channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      await for (final bin in channel.stream) {
        retryCount = 0; // Başarılı veri aktığı sürece sayacı sıfırla
        yield StreamBundle.fromBuffer(bin as List<int>);
      }
    } catch (e) {
      debugPrint("⚠️ WebSocket Bağlantı Hatası: $e");
    }

    // Bağlantı koptuğunda sunucuyu yormamak için bekleyerek (Exponential) tekrar dene
    retryCount++;
    final delay = (retryCount * 2).clamp(2, 10);
    debugPrint("🔌 Bağlantı koptu. $delay saniye sonra yeniden denenecek...");
    await Future.delayed(Duration(seconds: delay));
  }
});

final liveTradesProvider = StreamProvider<AggTrade>((ref) async* {
  final pipeline = ref.watch(vqPipelineProvider.stream);
  await for (final bundle in pipeline) {
    if (bundle.hasTrade()) yield bundle.trade;
  }
});

// ÇİFT KAYIT (DUPLICATE) ENGELLEYİCİ STATE MANAGER
class ReportNotifier extends FamilyNotifier<List<ExecutionReport>, String> {
  final Set<String> _seenTradeIds = {};

  @override
  List<ExecutionReport> build(String arg) => [];

  void addReport(ExecutionReport report) {
    // İşleme özel benzersiz kimlik (Sembol + Yön + Tam Milisaniye)
    final uniqueId = "${report.symbol}_${report.side}_${report.timestamp}";
    
    // Eğer kopup tekrar bağlanma yüzünden aynı geçmiş veri gelirse, listeye bir daha ekleme
    if (!_seenTradeIds.contains(uniqueId)) {
      _seenTradeIds.add(uniqueId);
      state = [report, ...state]; // En yeni en üste
    }
  }
}

final reportListProvider = NotifierProviderFamily<ReportNotifier, List<ExecutionReport>, String>(
  () => ReportNotifier(),
);