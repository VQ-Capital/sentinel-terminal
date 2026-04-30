// This is a generated file - do not edit.
//
// Generated from sentinel/execution/v1/execution.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'execution.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'execution.pbenum.dart';

class TradeSignal extends $pb.GeneratedMessage {
  factory TradeSignal({
    $core.String? symbol,
    TradeSignal_SignalType? type,
    $core.double? confidenceScore,
    $core.double? recommendedLeverage,
    $fixnum.Int64? timestamp,
    $core.String? reason,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (type != null) result.type = type;
    if (confidenceScore != null) result.confidenceScore = confidenceScore;
    if (recommendedLeverage != null)
      result.recommendedLeverage = recommendedLeverage;
    if (timestamp != null) result.timestamp = timestamp;
    if (reason != null) result.reason = reason;
    return result;
  }

  TradeSignal._();

  factory TradeSignal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TradeSignal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TradeSignal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sentinel.execution.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aE<TradeSignal_SignalType>(2, _omitFieldNames ? '' : 'type',
        enumValues: TradeSignal_SignalType.values)
    ..aD(3, _omitFieldNames ? '' : 'confidenceScore')
    ..aD(4, _omitFieldNames ? '' : 'recommendedLeverage')
    ..aInt64(5, _omitFieldNames ? '' : 'timestamp')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeSignal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeSignal copyWith(void Function(TradeSignal) updates) =>
      super.copyWith((message) => updates(message as TradeSignal))
          as TradeSignal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TradeSignal create() => TradeSignal._();
  @$core.override
  TradeSignal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TradeSignal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TradeSignal>(create);
  static TradeSignal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  TradeSignal_SignalType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(TradeSignal_SignalType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get confidenceScore => $_getN(2);
  @$pb.TagNumber(3)
  set confidenceScore($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConfidenceScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfidenceScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get recommendedLeverage => $_getN(3);
  @$pb.TagNumber(4)
  set recommendedLeverage($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecommendedLeverage() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecommendedLeverage() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);
}

class ExecutionReport extends $pb.GeneratedMessage {
  factory ExecutionReport({
    $core.String? symbol,
    $core.String? side,
    $core.double? expectedPrice,
    $core.double? executionPrice,
    $core.double? quantity,
    $core.double? realizedPnl,
    $core.double? commission,
    $fixnum.Int64? latencyMs,
    $fixnum.Int64? timestamp,
    $core.bool? isSimulated,
    $core.String? orderId,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (side != null) result.side = side;
    if (expectedPrice != null) result.expectedPrice = expectedPrice;
    if (executionPrice != null) result.executionPrice = executionPrice;
    if (quantity != null) result.quantity = quantity;
    if (realizedPnl != null) result.realizedPnl = realizedPnl;
    if (commission != null) result.commission = commission;
    if (latencyMs != null) result.latencyMs = latencyMs;
    if (timestamp != null) result.timestamp = timestamp;
    if (isSimulated != null) result.isSimulated = isSimulated;
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  ExecutionReport._();

  factory ExecutionReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecutionReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecutionReport',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sentinel.execution.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'side')
    ..aD(3, _omitFieldNames ? '' : 'expectedPrice')
    ..aD(4, _omitFieldNames ? '' : 'executionPrice')
    ..aD(5, _omitFieldNames ? '' : 'quantity')
    ..aD(6, _omitFieldNames ? '' : 'realizedPnl')
    ..aD(7, _omitFieldNames ? '' : 'commission')
    ..aInt64(8, _omitFieldNames ? '' : 'latencyMs')
    ..aInt64(9, _omitFieldNames ? '' : 'timestamp')
    ..aOB(10, _omitFieldNames ? '' : 'isSimulated')
    ..aOS(11, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutionReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutionReport copyWith(void Function(ExecutionReport) updates) =>
      super.copyWith((message) => updates(message as ExecutionReport))
          as ExecutionReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecutionReport create() => ExecutionReport._();
  @$core.override
  ExecutionReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecutionReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecutionReport>(create);
  static ExecutionReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get side => $_getSZ(1);
  @$pb.TagNumber(2)
  set side($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSide() => $_has(1);
  @$pb.TagNumber(2)
  void clearSide() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get expectedPrice => $_getN(2);
  @$pb.TagNumber(3)
  set expectedPrice($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get executionPrice => $_getN(3);
  @$pb.TagNumber(4)
  set executionPrice($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExecutionPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearExecutionPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get quantity => $_getN(4);
  @$pb.TagNumber(5)
  set quantity($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get realizedPnl => $_getN(5);
  @$pb.TagNumber(6)
  set realizedPnl($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRealizedPnl() => $_has(5);
  @$pb.TagNumber(6)
  void clearRealizedPnl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get commission => $_getN(6);
  @$pb.TagNumber(7)
  set commission($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCommission() => $_has(6);
  @$pb.TagNumber(7)
  void clearCommission() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get latencyMs => $_getI64(7);
  @$pb.TagNumber(8)
  set latencyMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLatencyMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatencyMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get timestamp => $_getI64(8);
  @$pb.TagNumber(9)
  set timestamp($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTimestamp() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimestamp() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isSimulated => $_getBF(9);
  @$pb.TagNumber(10)
  set isSimulated($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsSimulated() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsSimulated() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get orderId => $_getSZ(10);
  @$pb.TagNumber(11)
  set orderId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOrderId() => $_has(10);
  @$pb.TagNumber(11)
  void clearOrderId() => $_clearField(11);
}

/// 🔥 YENİ EKLENEN PROTOKOL: Root Cause Analysis (RCA)
/// sentinel-execution bir sinyali işleme dökmediğinde (Risk limiti, Cooldown, SLA ihlali)
/// NATS üzerinden sebebini AI Optimizer'a ve Terminal'e bildirir.
class ExecutionRejection extends $pb.GeneratedMessage {
  factory ExecutionRejection({
    $core.String? symbol,
    $core.String? originalSide,
    $core.double? intendedQuantity,
    $core.String? reasonCode,
    $core.String? description,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (originalSide != null) result.originalSide = originalSide;
    if (intendedQuantity != null) result.intendedQuantity = intendedQuantity;
    if (reasonCode != null) result.reasonCode = reasonCode;
    if (description != null) result.description = description;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  ExecutionRejection._();

  factory ExecutionRejection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecutionRejection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecutionRejection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sentinel.execution.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'originalSide')
    ..aD(3, _omitFieldNames ? '' : 'intendedQuantity')
    ..aOS(4, _omitFieldNames ? '' : 'reasonCode')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aInt64(6, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutionRejection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecutionRejection copyWith(void Function(ExecutionRejection) updates) =>
      super.copyWith((message) => updates(message as ExecutionRejection))
          as ExecutionRejection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecutionRejection create() => ExecutionRejection._();
  @$core.override
  ExecutionRejection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecutionRejection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecutionRejection>(create);
  static ExecutionRejection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get originalSide => $_getSZ(1);
  @$pb.TagNumber(2)
  set originalSide($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOriginalSide() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginalSide() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get intendedQuantity => $_getN(2);
  @$pb.TagNumber(3)
  set intendedQuantity($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIntendedQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntendedQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reasonCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set reasonCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReasonCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearReasonCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
