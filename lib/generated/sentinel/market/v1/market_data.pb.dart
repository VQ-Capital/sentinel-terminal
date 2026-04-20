// This is a generated file - do not edit.
//
// Generated from sentinel/market/v1/market_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// AggTrade (Aggregated Trade)
/// Bir borsadan gelen anlık, gerçekleşmiş işlem tikini (Tick) temsil eder.
/// sentinel-ingest servisi tarafından üretilir, NATS (market.trade.*) üzerinden yayınlanır.
class AggTrade extends $pb.GeneratedMessage {
  factory AggTrade({
    $core.String? symbol,
    $core.double? price,
    $core.double? quantity,
    $fixnum.Int64? timestamp,
    $core.bool? isBuyerMaker,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (price != null) result.price = price;
    if (quantity != null) result.quantity = quantity;
    if (timestamp != null) result.timestamp = timestamp;
    if (isBuyerMaker != null) result.isBuyerMaker = isBuyerMaker;
    return result;
  }

  AggTrade._();

  factory AggTrade.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AggTrade.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AggTrade',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.market.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aD(2, _omitFieldNames ? '' : 'price')
    ..aD(3, _omitFieldNames ? '' : 'quantity')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..aOB(5, _omitFieldNames ? '' : 'isBuyerMaker')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AggTrade clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AggTrade copyWith(void Function(AggTrade) updates) =>
      super.copyWith((message) => updates(message as AggTrade)) as AggTrade;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AggTrade create() => AggTrade._();
  @$core.override
  AggTrade createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AggTrade getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AggTrade>(create);
  static AggTrade? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get price => $_getN(1);
  @$pb.TagNumber(2)
  set price($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get quantity => $_getN(2);
  @$pb.TagNumber(3)
  set quantity($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isBuyerMaker => $_getBF(4);
  @$pb.TagNumber(5)
  set isBuyerMaker($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsBuyerMaker() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsBuyerMaker() => $_clearField(5);
}

/// OrderbookDepth (Emir Defteri Derinliği)
/// Gerçekçi PnL (Kâr/Zarar) ve Slippage (Kayma) hesaplamaları için
/// Level 2 (Derinlik) emir defteri simülasyonunda kullanılır.
class OrderbookDepth extends $pb.GeneratedMessage {
  factory OrderbookDepth({
    $core.String? symbol,
    $core.Iterable<PriceLevel>? bids,
    $core.Iterable<PriceLevel>? asks,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (bids != null) result.bids.addAll(bids);
    if (asks != null) result.asks.addAll(asks);
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  OrderbookDepth._();

  factory OrderbookDepth.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderbookDepth.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderbookDepth',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.market.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..pPM<PriceLevel>(2, _omitFieldNames ? '' : 'bids',
        subBuilder: PriceLevel.create)
    ..pPM<PriceLevel>(3, _omitFieldNames ? '' : 'asks',
        subBuilder: PriceLevel.create)
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderbookDepth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderbookDepth copyWith(void Function(OrderbookDepth) updates) =>
      super.copyWith((message) => updates(message as OrderbookDepth))
          as OrderbookDepth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderbookDepth create() => OrderbookDepth._();
  @$core.override
  OrderbookDepth createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrderbookDepth getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderbookDepth>(create);
  static OrderbookDepth? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PriceLevel> get bids => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PriceLevel> get asks => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);
}

/// PriceLevel (Fiyat Seviyesi)
/// Emir defterindeki tek bir satırı temsil eder.
class PriceLevel extends $pb.GeneratedMessage {
  factory PriceLevel({
    $core.double? price,
    $core.double? quantity,
  }) {
    final result = create();
    if (price != null) result.price = price;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  PriceLevel._();

  factory PriceLevel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PriceLevel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PriceLevel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.market.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'price')
    ..aD(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriceLevel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriceLevel copyWith(void Function(PriceLevel) updates) =>
      super.copyWith((message) => updates(message as PriceLevel)) as PriceLevel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PriceLevel create() => PriceLevel._();
  @$core.override
  PriceLevel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PriceLevel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PriceLevel>(create);
  static PriceLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get price => $_getN(0);
  @$pb.TagNumber(1)
  set price($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrice() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get quantity => $_getN(1);
  @$pb.TagNumber(2)
  set quantity($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

/// MarketStateVector (Piyasa Durum Vektörü)
/// sentinel-inference (Yapay Zeka) servisi tarafından 1 saniyelik ham veriler
/// sıkıştırılarak üretilir. Qdrant (Vektör DB) üzerinde "Geçmişe Benzerlik"
/// (Cosine Similarity) araması yapmak için kullanılır.
class MarketStateVector extends $pb.GeneratedMessage {
  factory MarketStateVector({
    $core.String? symbol,
    $fixnum.Int64? windowStartTime,
    $fixnum.Int64? windowEndTime,
    $core.double? priceVelocity,
    $core.double? volumeImbalance,
    $core.double? sentimentScore,
    $core.Iterable<$core.double>? embeddings,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (windowStartTime != null) result.windowStartTime = windowStartTime;
    if (windowEndTime != null) result.windowEndTime = windowEndTime;
    if (priceVelocity != null) result.priceVelocity = priceVelocity;
    if (volumeImbalance != null) result.volumeImbalance = volumeImbalance;
    if (sentimentScore != null) result.sentimentScore = sentimentScore;
    if (embeddings != null) result.embeddings.addAll(embeddings);
    return result;
  }

  MarketStateVector._();

  factory MarketStateVector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarketStateVector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarketStateVector',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.market.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aInt64(2, _omitFieldNames ? '' : 'windowStartTime')
    ..aInt64(3, _omitFieldNames ? '' : 'windowEndTime')
    ..aD(4, _omitFieldNames ? '' : 'priceVelocity')
    ..aD(5, _omitFieldNames ? '' : 'volumeImbalance')
    ..aD(6, _omitFieldNames ? '' : 'sentimentScore')
    ..p<$core.double>(
        7, _omitFieldNames ? '' : 'embeddings', $pb.PbFieldType.KD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketStateVector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketStateVector copyWith(void Function(MarketStateVector) updates) =>
      super.copyWith((message) => updates(message as MarketStateVector))
          as MarketStateVector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketStateVector create() => MarketStateVector._();
  @$core.override
  MarketStateVector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarketStateVector getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarketStateVector>(create);
  static MarketStateVector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get windowStartTime => $_getI64(1);
  @$pb.TagNumber(2)
  set windowStartTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWindowStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearWindowStartTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get windowEndTime => $_getI64(2);
  @$pb.TagNumber(3)
  set windowEndTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWindowEndTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindowEndTime() => $_clearField(3);

  /// Analitik Özellikler (Features)
  @$pb.TagNumber(4)
  $core.double get priceVelocity => $_getN(3);
  @$pb.TagNumber(4)
  set priceVelocity($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceVelocity() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceVelocity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get volumeImbalance => $_getN(4);
  @$pb.TagNumber(5)
  set volumeImbalance($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVolumeImbalance() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolumeImbalance() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get sentimentScore => $_getN(5);
  @$pb.TagNumber(6)
  set sentimentScore($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSentimentScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearSentimentScore() => $_clearField(6);

  /// Qdrant'a gömülecek ham vektör dizisi
  @$pb.TagNumber(7)
  $pb.PbList<$core.double> get embeddings => $_getList(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
