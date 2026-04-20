#!/bin/bash
# VQ-Capital Master Proto Generator for Dart

# Çıktı klasörünü temizle ve hazırla
mkdir -p lib/generated

# PATH kontrolü (Daha önce kurduğumuz plugin'in yolu)
export PATH="$PATH":"$HOME/.pub-cache/bin"

echo "🛠️ Protobuf kodları üretiliyor..."

protoc --dart_out=lib/generated \
    -I sentinel-spec/proto \
    sentinel-spec/proto/sentinel/market/v1/market_data.proto \
    sentinel-spec/proto/sentinel/execution/v1/execution.proto \
    sentinel-spec/proto/sentinel/api/v1/bundle.proto

echo "✅ Kod üretimi tamamlandı: lib/generated"