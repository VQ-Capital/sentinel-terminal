// ========== DOSYA: sentinel-terminal/lib/main.dart ==========
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/terminal_stream.dart';
import 'generated/sentinel/execution/v1/execution.pb.dart';

void main() { runApp(const ProviderScope(child: VQTerminalApp())); }

class VQTerminalApp extends StatelessWidget {
  const VQTerminalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VQ-Capital Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121214), elevation: 0, centerTitle: false),
        cardColor: const Color(0xFF18181B),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(vqPipelineProvider); 
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportListProvider);
    final marketPrices = ref.watch(marketDataNotifierProvider);
    
    const double initialBalance = 10.00;
    double totalRealizedPnL = 0.0;
    
    Map<String, double> positions = {};
    Map<String, double> avgPrices = {};
    List<double> pnlHistory = [0.0];

    for (var r in reports.reversed) {
      totalRealizedPnL += r.realizedPnl;
      pnlHistory.add(totalRealizedPnL);

      double posQty = positions[r.symbol] ?? 0.0;
      double avgPrice = avgPrices[r.symbol] ?? 0.0;

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

    final currentBalance = initialBalance + totalRealizedPnL;
    double totalUnrealizedPnL = 0.0;
    
    positions.forEach((symbol, qty) {
      if (qty.abs() > 0.000001) {
        double currentPrice = marketPrices[symbol] ?? avgPrices[symbol] ?? 0.0;
        if (currentPrice > 0) {
          totalUnrealizedPnL += qty > 0 
              ? (currentPrice - avgPrices[symbol]!) * qty 
              : (avgPrices[symbol]! - currentPrice) * qty.abs();
        }
      }
    });

    final bool isDefensiveMode = ((initialBalance - currentBalance) / initialBalance) > 0.15;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.security, color: Colors.amber, size: 22),
            const SizedBox(width: 8),
            // ÇÖZÜM: Yazının taşmasını Flexible ile engelliyoruz
            const Flexible(
              child: Text('SENTINEL', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 16), overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 12),
            _buildSystemStatusBadge(isDefensiveMode),
          ],
        ),
        // ÇÖZÜM: Wrap kullanarak Ticker'ların ekrana sığmadığında alt satıra geçmesini sağlıyoruz
        actions: [
          if (marketPrices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  alignment: WrapAlignment.end,
                  children: marketPrices.entries.take(4).map((e) => _buildLiveTicker(e.key.replaceAll('usdt', '').toUpperCase(), e.value)).toList(),
                ),
              ),
            )
          else
            const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResponsiveStats(constraints.maxWidth, currentBalance, totalRealizedPnL, totalUnrealizedPnL, positions.values.where((v) => v.abs() > 0.000001).length),
                const SizedBox(height: 12),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SizedBox(height: 400, child: _buildChartContainer("PORTFÖY KÜMÜLATİF PnL (USDT)", PnLChartPainter(pnlHistory), totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(flex: 5, child: SizedBox(height: 400, child: _buildDenseTradeLog(reports))),
                    ],
                  )
                else
                  Column(
                    children: [
                      SizedBox(height: 250, child: _buildChartContainer("KÜMÜLATİF PnL (USDT)", PnLChartPainter(pnlHistory), totalRealizedPnL >= 0 ? Colors.greenAccent : Colors.redAccent)),
                      const SizedBox(height: 12),
                      SizedBox(height: 500, child: _buildDenseTradeLog(reports)),
                    ],
                  ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildResponsiveStats(double maxWidth, double bal, double rpnl, double upnl, int activePosCount) {
    int crossAxisCount = maxWidth > 1200 ? 5 : (maxWidth > 800 ? 4 : (maxWidth > 500 ? 3 : 2));
    // ÇÖZÜM: aspect Ratio'yu düşürerek kartlara dikeyde daha fazla alan (height) veriyoruz
    double aspectRatio = maxWidth > 800 ? 2.2 : 1.7; 
    
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: aspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard("WALLET (CÜZDAN)", "\$${bal.toStringAsFixed(4)}", Colors.amberAccent, "Net varlığınız (Sermaye + Kâr).", "Sisteme yatırdığınız ana para ve bugüne kadar kapanmış tüm işlemlerden elde edilen net kârın toplamıdır."),
        _buildStatCard("REALIZED PnL", "\$${rpnl.toStringAsFixed(4)}", rpnl >= 0 ? Colors.greenAccent : Colors.redAccent, "Kapanmış işlemler net kâr/zararı.", "Gerçekleşen Kâr/Zarar: Sadece pozisyonlar kapatıldığında (Take Profit veya Stop Loss ile) kesinleşen miktardır. Bakiye bu rakamla güncellenir."),
        _buildStatCard("FLOATING PnL", "\$${upnl.toStringAsFixed(4)}", upnl >= 0 ? Colors.greenAccent : Colors.redAccent, "Açık pozisyon anlık durumu.", "Açık Kâr/Zarar: Şu an borsada açık olan (henüz kapatılmamış) pozisyonlarınızın anlık piyasa fiyatına göre hesaplanan farazi kâr veya zararıdır."),
        _buildStatCard("ACTIVE POSITIONS", "$activePosCount Adet", Colors.blueAccent, "Şu an aktif multi-coin sayısı.", "Risk motoru tarafından onaylanıp borsaya iletilen ve an itibarıyla açık olan eşzamanlı işlem sayısını gösterir."),
        _buildKillSwitch(),
      ],
    );
  }

  Widget _buildSystemStatusBadge(bool isDefensive) {
    return Tooltip(
      message: isDefensive 
        ? "SELF-HEALING AKTİF: Kasa %15'ten fazla eridiği için risk motoru kaldıraç ve lot miktarlarını yarıya indirerek defansif moda geçmiştir."
        : "NORMAL MOD: Sistem standart HFT risk ve kaldıraç parametreleriyle maksimum kazanç için çalışmaktadır.",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: isDefensive ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: isDefensive ? Colors.orange.withOpacity(0.5) : Colors.green.withOpacity(0.5))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isDefensive ? Icons.shield : Icons.sports_kabaddi, color: isDefensive ? Colors.orangeAccent : Colors.greenAccent, size: 12),
            const SizedBox(width: 4),
            Text(isDefensive ? "DEFANS" : "HÜCUM", style: TextStyle(color: isDefensive ? Colors.orangeAccent : Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTicker(String symbol, double price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Text('$symbol: ${price.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 10)),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, String subtitle, String tooltipMsg) {
    // ÇÖZÜM: Tooltip ile zenginleştirme ve taşmaları engelleyen Expanded/Flexible yapısı
    return Tooltip(
      message: tooltipMsg,
      waitDuration: const Duration(milliseconds: 300),
      textStyle: const TextStyle(fontSize: 12, color: Colors.white),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.5))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const Spacer(),
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'monospace'))),
            const Spacer(),
            Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 9), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitch() {
    return Tooltip(
      message: "ACİL DURUM BUTONU: Sistemde anormal bir piyasa hareketi veya hata tespit ederseniz tüm açık pozisyonları piyasa fiyatından kapatır ve botu durdurur.",
      child: InkWell(
        onTap: () {}, // Gelecekte API gRPC call bağlanacak
        child: Container(
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.3))),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.power_settings_new, color: Colors.redAccent, size: 24), SizedBox(height: 6),
              Text("KILL SWITCH", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Text("Sistemi Acil Durdur", style: TextStyle(color: Colors.white38, fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContainer(String title, CustomPainter painter, Color titleColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: titleColor.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Tooltip(
                message: "Yapay zekanın açıp kapattığı tüm işlemlerin sonucunda oluşan kümülatif bakiye eğrisidir.",
                child: Icon(Icons.info_outline, size: 14, color: Colors.white24),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: ClipRect(child: CustomPaint(painter: painter, size: Size.infinite))),
        ],
      ),
    );
  }

  Widget _buildDenseTradeLog(List<ExecutionReport> reports) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("İŞLEM DEFTERİ (MULTI-COIN LOG)", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Tooltip(
                  message: "Execution Report: Sentinel-Execution mikroservisi tarafından borsadan gelen dolum (fill) bildirimlerinin loglarıdır. Komisyon (Slippage/Fee) düşülmüş net rakamları gösterir.",
                  child: Icon(Icons.info_outline, size: 14, color: Colors.white24),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          // SÜTUN BAŞLIKLARI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text("ZAMAN", style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Center(child: Text("YÖN", style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)))),
                SizedBox(width: 8),
                Expanded(flex: 2, child: Text("VARLIK", style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("MİKTAR", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("FİYAT", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("NET PnL", textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Expanded(
            child: reports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(strokeWidth: 2, color: Colors.white10),
                        const SizedBox(height: 16),
                        const Text("Qdrant Vektörleri Toplanıyor...", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Yapay zeka (Sniper Mode) %98.5 benzerlik arıyor.", style: TextStyle(color: Colors.amber.withOpacity(0.7), fontSize: 10)),
                      ],
                    )
                  )
                : ListView.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                    itemBuilder: (context, index) {
                      final r = reports[index];
                      final isBuy = r.side == "BUY";
                      final pnlColor = r.realizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent;
                      final timeStr = DateTime.fromMillisecondsSinceEpoch(r.timestamp.toInt()).toString().substring(11, 19); 
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(timeStr, style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace'))),
                            Expanded(flex: 1, child: Container(
                              alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(r.side, style: TextStyle(color: isBuy ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                            )),
                            const SizedBox(width: 8),
                            Expanded(flex: 2, child: Row(
                              children: [
                                // COIN RENK KODLAMASI (Profesyonel Görünüm İçin)
                                Container(
                                  width: 6, height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: r.symbol.contains("BTC") ? Colors.orange : (r.symbol.contains("ETH") ? Colors.blue : (r.symbol.contains("SOL") ? Colors.purple : Colors.yellow)),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(r.symbol.replaceAll('usdt', '').replaceAll('USDT', '').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            )),
                            Expanded(flex: 2, child: Text(r.quantity.toStringAsFixed(4), textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70))),
                            Expanded(flex: 2, child: Text("\$${r.executionPrice.toStringAsFixed(1)}", textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70))),
                            Expanded(flex: 2, child: Text("${r.realizedPnl >= 0 ? '+' : ''}${r.realizedPnl.toStringAsFixed(4)}", textAlign: TextAlign.right, style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12))),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PnLChartPainter extends CustomPainter {
  final List<double> history;
  PnLChartPainter(this.history);

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    final paint = Paint()..color = history.last >= 0 ? Colors.greenAccent : Colors.redAccent..strokeWidth = 2.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final minPnl = history.reduce(min);
    final maxPnl = history.reduce(max);
    final range = (maxPnl - minPnl) == 0 ? 1.0 : (maxPnl - minPnl);
    final paddedRange = range * 1.2; 
    final paddedMin = minPnl - (range * 0.1);
    
    final path = Path();
    final dx = size.width / (history.length > 1 ? history.length - 1 : 1);
    
    for (int i = 0; i < history.length; i++) {
      final x = i * dx;
      final normalizedY = (history[i] - paddedMin) / paddedRange;
      final y = size.height - (normalizedY * size.height);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    
    if (minPnl < 0 && maxPnl > 0) {
      final zeroY = size.height - ((0 - paddedMin) / paddedRange) * size.height;
      final zeroPaint = Paint()..color = Colors.white24..strokeWidth = 1.0..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroPaint);
    }
    
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    final gradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [paint.color.withOpacity(0.2), paint.color.withOpacity(0.0)]);
    canvas.drawPath(fillPath, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant PnLChartPainter oldDelegate) => true;
}