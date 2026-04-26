# 🖥️ sentinel-quant-dashboard (Legacy: sentinel-terminal)

**Domain:** HFT Data Visualization & Monitoring
**Rol:** Sistem Gözetleme Ekranı

Algoritmik sistemin arka planda neler yaptığını insan beyninin anlayabileceği görsellere (Z-Score radarları, PnL eğrileri, Latency Isı Haritaları) dönüştürür. Kesinlikle bir işlem platformu değildir, sadece "Read-Only" (Sadece Okunur) bir vizyoner panodur. İstisna olarak, acil durumlarda "Kill Switch" emri gönderebilir.

- **Teknoloji:** Flutter (Riverpod Mimarisinde Zero-Allocation Protobuf Decoding)
- **Bağlantı:** WebSocket (`sentinel-stream-gateway` üzerinden)