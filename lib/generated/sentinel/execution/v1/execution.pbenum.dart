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

import 'package:protobuf/protobuf.dart' as $pb;

class TradeSignal_SignalType extends $pb.ProtobufEnum {
  static const TradeSignal_SignalType SIGNAL_TYPE_UNSPECIFIED =
      TradeSignal_SignalType._(
          0, _omitEnumNames ? '' : 'SIGNAL_TYPE_UNSPECIFIED');
  static const TradeSignal_SignalType SIGNAL_TYPE_HOLD =
      TradeSignal_SignalType._(1, _omitEnumNames ? '' : 'SIGNAL_TYPE_HOLD');
  static const TradeSignal_SignalType SIGNAL_TYPE_STRONG_BUY =
      TradeSignal_SignalType._(
          2, _omitEnumNames ? '' : 'SIGNAL_TYPE_STRONG_BUY');
  static const TradeSignal_SignalType SIGNAL_TYPE_BUY =
      TradeSignal_SignalType._(3, _omitEnumNames ? '' : 'SIGNAL_TYPE_BUY');
  static const TradeSignal_SignalType SIGNAL_TYPE_SELL =
      TradeSignal_SignalType._(4, _omitEnumNames ? '' : 'SIGNAL_TYPE_SELL');
  static const TradeSignal_SignalType SIGNAL_TYPE_STRONG_SELL =
      TradeSignal_SignalType._(
          5, _omitEnumNames ? '' : 'SIGNAL_TYPE_STRONG_SELL');

  static const $core.List<TradeSignal_SignalType> values =
      <TradeSignal_SignalType>[
    SIGNAL_TYPE_UNSPECIFIED,
    SIGNAL_TYPE_HOLD,
    SIGNAL_TYPE_STRONG_BUY,
    SIGNAL_TYPE_BUY,
    SIGNAL_TYPE_SELL,
    SIGNAL_TYPE_STRONG_SELL,
  ];

  static final $core.List<TradeSignal_SignalType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TradeSignal_SignalType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TradeSignal_SignalType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
