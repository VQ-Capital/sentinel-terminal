import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../generated/sentinel/api/v1/bundle.pb.dart';
// KRİTİK: Bu tipler için bu importlar ŞART
import '../../generated/sentinel/market/v1/market_data.pb.dart';
import '../../generated/sentinel/execution/v1/execution.pb.dart';

// Ana WebSocket Akışı
final vqPipelineProvider = StreamProvider<StreamBundle>((ref) {
  // Docker-compose'da 8080 portunu açmıştık
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws/v1/pipeline'),
  );
  
  ref.onDispose(() => channel.sink.close());
  
  // Binary veriyi StreamBundle nesnesine çevir
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
    // Listeye en başa ekle (Stack mantığı)
    state = [report, ...state];
  }
}

// Kolay erişim için provider
final reportListProvider = NotifierProviderFamily<ReportNotifier, List<ExecutionReport>, String>(
  () => ReportNotifier(),
);