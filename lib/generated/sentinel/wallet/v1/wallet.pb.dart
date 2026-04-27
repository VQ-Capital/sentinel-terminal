// This is a generated file - do not edit.
//
// Generated from sentinel/wallet/v1/wallet.proto.

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

/// EquitySnapshot (Varlık Durum Raporu)
/// sentinel-wallet servisi tarafından saniyede bir üretilir.
/// Execution servisi bu veriyi referans alarak emir büyüklüğünü hesaplar.
class EquitySnapshot extends $pb.GeneratedMessage {
  factory EquitySnapshot({
    $core.double? totalEquityUsd,
    $core.double? availableMarginUsd,
    $core.double? totalUnrealizedPnl,
    $fixnum.Int64? timestamp,
    $core.bool? isReconciled,
    $core.double? maxDrawdownPct,
    $core.double? sharpeRatio,
  }) {
    final result = create();
    if (totalEquityUsd != null) result.totalEquityUsd = totalEquityUsd;
    if (availableMarginUsd != null)
      result.availableMarginUsd = availableMarginUsd;
    if (totalUnrealizedPnl != null)
      result.totalUnrealizedPnl = totalUnrealizedPnl;
    if (timestamp != null) result.timestamp = timestamp;
    if (isReconciled != null) result.isReconciled = isReconciled;
    if (maxDrawdownPct != null) result.maxDrawdownPct = maxDrawdownPct;
    if (sharpeRatio != null) result.sharpeRatio = sharpeRatio;
    return result;
  }

  EquitySnapshot._();

  factory EquitySnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EquitySnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EquitySnapshot',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.wallet.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'totalEquityUsd')
    ..aD(2, _omitFieldNames ? '' : 'availableMarginUsd')
    ..aD(3, _omitFieldNames ? '' : 'totalUnrealizedPnl')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..aOB(5, _omitFieldNames ? '' : 'isReconciled')
    ..aD(6, _omitFieldNames ? '' : 'maxDrawdownPct')
    ..aD(7, _omitFieldNames ? '' : 'sharpeRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquitySnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquitySnapshot copyWith(void Function(EquitySnapshot) updates) =>
      super.copyWith((message) => updates(message as EquitySnapshot))
          as EquitySnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EquitySnapshot create() => EquitySnapshot._();
  @$core.override
  EquitySnapshot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EquitySnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EquitySnapshot>(create);
  static EquitySnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get totalEquityUsd => $_getN(0);
  @$pb.TagNumber(1)
  set totalEquityUsd($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalEquityUsd() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalEquityUsd() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get availableMarginUsd => $_getN(1);
  @$pb.TagNumber(2)
  set availableMarginUsd($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvailableMarginUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailableMarginUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalUnrealizedPnl => $_getN(2);
  @$pb.TagNumber(3)
  set totalUnrealizedPnl($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalUnrealizedPnl() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalUnrealizedPnl() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isReconciled => $_getBF(4);
  @$pb.TagNumber(5)
  set isReconciled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsReconciled() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsReconciled() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get maxDrawdownPct => $_getN(5);
  @$pb.TagNumber(6)
  set maxDrawdownPct($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxDrawdownPct() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxDrawdownPct() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get sharpeRatio => $_getN(6);
  @$pb.TagNumber(7)
  set sharpeRatio($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSharpeRatio() => $_has(6);
  @$pb.TagNumber(7)
  void clearSharpeRatio() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
