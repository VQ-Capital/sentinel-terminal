// This is a generated file - do not edit.
//
// Generated from sentinel/api/v1/bundle.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../execution/v1/execution.pb.dart' as $1;
import '../../market/v1/market_data.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum StreamBundle_Message { trade, report, signal, notSet }

/// StreamBundle: WebSocket üzerinden gönderilen tüm mesajların ana zarfı.
class StreamBundle extends $pb.GeneratedMessage {
  factory StreamBundle({
    $0.AggTrade? trade,
    $1.ExecutionReport? report,
    $1.TradeSignal? signal,
  }) {
    final result = create();
    if (trade != null) result.trade = trade;
    if (report != null) result.report = report;
    if (signal != null) result.signal = signal;
    return result;
  }

  StreamBundle._();

  factory StreamBundle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamBundle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, StreamBundle_Message>
      _StreamBundle_MessageByTag = {
    1: StreamBundle_Message.trade,
    2: StreamBundle_Message.report,
    3: StreamBundle_Message.signal,
    0: StreamBundle_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamBundle',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.api.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<$0.AggTrade>(1, _omitFieldNames ? '' : 'trade',
        subBuilder: $0.AggTrade.create)
    ..aOM<$1.ExecutionReport>(2, _omitFieldNames ? '' : 'report',
        subBuilder: $1.ExecutionReport.create)
    ..aOM<$1.TradeSignal>(3, _omitFieldNames ? '' : 'signal',
        subBuilder: $1.TradeSignal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamBundle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamBundle copyWith(void Function(StreamBundle) updates) =>
      super.copyWith((message) => updates(message as StreamBundle))
          as StreamBundle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamBundle create() => StreamBundle._();
  @$core.override
  StreamBundle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamBundle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamBundle>(create);
  static StreamBundle? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  StreamBundle_Message whichMessage() =>
      _StreamBundle_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.AggTrade get trade => $_getN(0);
  @$pb.TagNumber(1)
  set trade($0.AggTrade value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrade() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrade() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.AggTrade ensureTrade() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.ExecutionReport get report => $_getN(1);
  @$pb.TagNumber(2)
  set report($1.ExecutionReport value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReport() => $_has(1);
  @$pb.TagNumber(2)
  void clearReport() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.ExecutionReport ensureReport() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.TradeSignal get signal => $_getN(2);
  @$pb.TagNumber(3)
  set signal($1.TradeSignal value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSignal() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignal() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.TradeSignal ensureSignal() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
