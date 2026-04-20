# sentinel-terminal
Sistemin görselleştirilmesi, PnL takibi 

#### Uzak Sunucuda (Remote) veya Mobilde Çalıştırma Komutları



**A) Android Telefondan Uzak Sunucuya Bağlanarak Çalıştırma:**
```bash
cd sentinel-terminal
flutter run -d <cihaz_id> --dart-define=WS_URL=ws://192.168.1.100:8080/ws/v1/pipeline
```

**B) Web Tarayıcısı Üzerinden Çalıştırma (Chrome):**
```bash
cd sentinel-terminal
flutter run -d chrome --web-port=5000
```
*(Web tarafında URL otomatik olarak sunucunun IP'sini alacaktır, ekstra komuta gerek yok).*

**C) Production İçin Web Build Alma (Docker'a koymak istersen):**
```bash
flutter build web --release --dart-define=WS_URL=ws://<SUNUCU_DIS_IP>:8080/ws/v1/pipeline
```
