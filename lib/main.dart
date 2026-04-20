import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// Ürettiğin proto dosyalarını import et (İsimleri kontrol et, pb.dart ile biter)
import 'generated/sentinel/execution/v1/execution.pb.dart'; 

void main() {
  runApp(const VQTerminalApp());
}

class VQTerminalApp extends StatelessWidget {
  const VQTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // HFT Terminal her zaman Dark olur
      home: const TerminalScreen(),
    );
  }
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  // API Gateway URL (Docker-compose içinde 8080 demiştik)
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws/v1/pipeline'),
  );

  List<ExecutionReport> reports = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🦅 VQ-CAPITAL REAL-TIME TERMINAL')),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // KRİTİK: Gelen veriyi binary (Uint8List) olarak al ve Protobuf ile parse et
            final Uint8List binaryData = snapshot.data as Uint8List;
            try {
              final report = ExecutionReport.fromBuffer(binaryData);
              reports.insert(0, report); // En yeni raporu en üste ekle
            } catch (e) {
              // Eğer gelen veri ExecutionReport değilse (örneğin MarketTrade ise) buraya düşer
              // Şimdilik sadece execution raporlarını yakalıyoruz
            }
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final r = reports[index];
              return ListTile(
                leading: Icon(
                  r.side == "BUY" ? Icons.arrow_upward : Icons.arrow_downward,
                  color: r.side == "BUY" ? Colors.green : Colors.red,
                ),
                title: Text('${r.symbol} | ${r.side} | Price: ${r.executionPrice}'),
                subtitle: Text('PnL: ${r.realizedPnl} USD | Latency: ${r.latencyMs}ms'),
                trailing: Text('${r.quantity} Qty'),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}