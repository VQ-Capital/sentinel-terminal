#!/bin/bash
mkdir -p lib/generated
export PATH="$PATH":"$HOME/.pub-cache/bin"
echo "🛠️ Protobuf kodları üretiliyor..."
protoc --dart_out=lib/generated \
    -I sentinel-spec/proto \
    sentinel-spec/proto/sentinel/market/v1/market_data.proto \
    sentinel-spec/proto/sentinel/execution/v1/execution.proto \
    sentinel-spec/proto/sentinel/wallet/v1/wallet.proto \
    sentinel-spec/proto/sentinel/api/v1/bundle.proto
echo "✅ Kod üretimi tamamlandı"
