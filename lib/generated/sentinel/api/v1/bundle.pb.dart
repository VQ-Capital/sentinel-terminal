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
import '../../wallet/v1/wallet.pb.dart' as $2;
import 'bundle.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'bundle.pbenum.dart';

enum StreamBundle_Message {
  trade,
  report,
  signal,
  command,
  equity,
  vector,
  rejection,
  notSet
}

class StreamBundle extends $pb.GeneratedMessage {
  factory StreamBundle({
    $0.AggTrade? trade,
    $1.ExecutionReport? report,
    $1.TradeSignal? signal,
    ControlCommand? command,
    $2.EquitySnapshot? equity,
    $0.MarketStateVector? vector,
    $1.ExecutionRejection? rejection,
  }) {
    final result = create();
    if (trade != null) result.trade = trade;
    if (report != null) result.report = report;
    if (signal != null) result.signal = signal;
    if (command != null) result.command = command;
    if (equity != null) result.equity = equity;
    if (vector != null) result.vector = vector;
    if (rejection != null) result.rejection = rejection;
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
    4: StreamBundle_Message.command,
    5: StreamBundle_Message.equity,
    6: StreamBundle_Message.vector,
    7: StreamBundle_Message.rejection,
    0: StreamBundle_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamBundle',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.api.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<$0.AggTrade>(1, _omitFieldNames ? '' : 'trade',
        subBuilder: $0.AggTrade.create)
    ..aOM<$1.ExecutionReport>(2, _omitFieldNames ? '' : 'report',
        subBuilder: $1.ExecutionReport.create)
    ..aOM<$1.TradeSignal>(3, _omitFieldNames ? '' : 'signal',
        subBuilder: $1.TradeSignal.create)
    ..aOM<ControlCommand>(4, _omitFieldNames ? '' : 'command',
        subBuilder: ControlCommand.create)
    ..aOM<$2.EquitySnapshot>(5, _omitFieldNames ? '' : 'equity',
        subBuilder: $2.EquitySnapshot.create)
    ..aOM<$0.MarketStateVector>(6, _omitFieldNames ? '' : 'vector',
        subBuilder: $0.MarketStateVector.create)
    ..aOM<$1.ExecutionRejection>(7, _omitFieldNames ? '' : 'rejection',
        subBuilder: $1.ExecutionRejection.create)
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
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  StreamBundle_Message whichMessage() =>
      _StreamBundle_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
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

  @$pb.TagNumber(4)
  ControlCommand get command => $_getN(3);
  @$pb.TagNumber(4)
  set command(ControlCommand value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCommand() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommand() => $_clearField(4);
  @$pb.TagNumber(4)
  ControlCommand ensureCommand() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.EquitySnapshot get equity => $_getN(4);
  @$pb.TagNumber(5)
  set equity($2.EquitySnapshot value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEquity() => $_has(4);
  @$pb.TagNumber(5)
  void clearEquity() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.EquitySnapshot ensureEquity() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.MarketStateVector get vector => $_getN(5);
  @$pb.TagNumber(6)
  set vector($0.MarketStateVector value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVector() => $_has(5);
  @$pb.TagNumber(6)
  void clearVector() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.MarketStateVector ensureVector() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.ExecutionRejection get rejection => $_getN(6);
  @$pb.TagNumber(7)
  set rejection($1.ExecutionRejection value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRejection() => $_has(6);
  @$pb.TagNumber(7)
  void clearRejection() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.ExecutionRejection ensureRejection() => $_ensure(6);
}

class ControlCommand extends $pb.GeneratedMessage {
  factory ControlCommand({
    ControlCommand_CommandType? type,
  }) {
    final result = create();
    if (type != null) result.type = type;
    return result;
  }

  ControlCommand._();

  factory ControlCommand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ControlCommand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ControlCommand',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sentinel.api.v1'),
      createEmptyInstance: create)
    ..aE<ControlCommand_CommandType>(1, _omitFieldNames ? '' : 'type',
        enumValues: ControlCommand_CommandType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ControlCommand clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ControlCommand copyWith(void Function(ControlCommand) updates) =>
      super.copyWith((message) => updates(message as ControlCommand))
          as ControlCommand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ControlCommand create() => ControlCommand._();
  @$core.override
  ControlCommand createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ControlCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ControlCommand>(create);
  static ControlCommand? _defaultInstance;

  @$pb.TagNumber(1)
  ControlCommand_CommandType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ControlCommand_CommandType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
