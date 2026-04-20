import 'package:riverpod/riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../generated/sentinel/api/v1/bundle.pb.dart';

// WebSocket kanalını sağlayan provider
final socketProvider = Provider((ref) {
  return WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws/v1/pipeline'),
  );
});

// Gelen binary akışı StreamBundle nesnelerine çeviren provider
final vqStreamProvider = StreamProvider<StreamBundle>((ref) {
  final channel = ref.watch(socketProvider);
  return channel.stream.map((bin) => StreamBundle.fromBuffer(bin));
});

// Sadece Execution Raporlarını filtreleyen state
final reportsProvider = StateProvider<List<ExecutionReport>>((ref) {
  final stream = ref.watch(vqStreamProvider);
  
  stream.whenData((bundle) {
    if (bundle.hasReport()) {
      // Yeni raporu listeye ekle (Burada logic gelişecek)
    }
  });
  return [];
});