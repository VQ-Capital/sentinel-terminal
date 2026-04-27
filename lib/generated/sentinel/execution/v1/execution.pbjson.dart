// This is a generated file - do not edit.
//
// Generated from sentinel/execution/v1/execution.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use tradeSignalDescriptor instead')
const TradeSignal$json = {
  '1': 'TradeSignal',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.sentinel.execution.v1.TradeSignal.SignalType',
      '10': 'type'
    },
    {'1': 'confidence_score', '3': 3, '4': 1, '5': 1, '10': 'confidenceScore'},
    {
      '1': 'recommended_leverage',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'recommendedLeverage'
    },
    {'1': 'timestamp', '3': 5, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
  ],
  '4': [TradeSignal_SignalType$json],
};

@$core.Deprecated('Use tradeSignalDescriptor instead')
const TradeSignal_SignalType$json = {
  '1': 'SignalType',
  '2': [
    {'1': 'SIGNAL_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SIGNAL_TYPE_HOLD', '2': 1},
    {'1': 'SIGNAL_TYPE_STRONG_BUY', '2': 2},
    {'1': 'SIGNAL_TYPE_BUY', '2': 3},
    {'1': 'SIGNAL_TYPE_SELL', '2': 4},
    {'1': 'SIGNAL_TYPE_STRONG_SELL', '2': 5},
  ],
};

/// Descriptor for `TradeSignal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tradeSignalDescriptor = $convert.base64Decode(
    'CgtUcmFkZVNpZ25hbBIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBJBCgR0eXBlGAIgASgOMi0uc2'
    'VudGluZWwuZXhlY3V0aW9uLnYxLlRyYWRlU2lnbmFsLlNpZ25hbFR5cGVSBHR5cGUSKQoQY29u'
    'ZmlkZW5jZV9zY29yZRgDIAEoAVIPY29uZmlkZW5jZVNjb3JlEjEKFHJlY29tbWVuZGVkX2xldm'
    'VyYWdlGAQgASgBUhNyZWNvbW1lbmRlZExldmVyYWdlEhwKCXRpbWVzdGFtcBgFIAEoA1IJdGlt'
    'ZXN0YW1wEhYKBnJlYXNvbhgGIAEoCVIGcmVhc29uIqMBCgpTaWduYWxUeXBlEhsKF1NJR05BTF'
    '9UWVBFX1VOU1BFQ0lGSUVEEAASFAoQU0lHTkFMX1RZUEVfSE9MRBABEhoKFlNJR05BTF9UWVBF'
    'X1NUUk9OR19CVVkQAhITCg9TSUdOQUxfVFlQRV9CVVkQAxIUChBTSUdOQUxfVFlQRV9TRUxMEA'
    'QSGwoXU0lHTkFMX1RZUEVfU1RST05HX1NFTEwQBQ==');

@$core.Deprecated('Use executionReportDescriptor instead')
const ExecutionReport$json = {
  '1': 'ExecutionReport',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'side', '3': 2, '4': 1, '5': 9, '10': 'side'},
    {'1': 'expected_price', '3': 3, '4': 1, '5': 1, '10': 'expectedPrice'},
    {'1': 'execution_price', '3': 4, '4': 1, '5': 1, '10': 'executionPrice'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 1, '10': 'quantity'},
    {'1': 'realized_pnl', '3': 6, '4': 1, '5': 1, '10': 'realizedPnl'},
    {'1': 'commission', '3': 7, '4': 1, '5': 1, '10': 'commission'},
    {'1': 'latency_ms', '3': 8, '4': 1, '5': 3, '10': 'latencyMs'},
    {'1': 'timestamp', '3': 9, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'is_simulated', '3': 10, '4': 1, '5': 8, '10': 'isSimulated'},
    {'1': 'order_id', '3': 11, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `ExecutionReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executionReportDescriptor = $convert.base64Decode(
    'Cg9FeGVjdXRpb25SZXBvcnQSFgoGc3ltYm9sGAEgASgJUgZzeW1ib2wSEgoEc2lkZRgCIAEoCV'
    'IEc2lkZRIlCg5leHBlY3RlZF9wcmljZRgDIAEoAVINZXhwZWN0ZWRQcmljZRInCg9leGVjdXRp'
    'b25fcHJpY2UYBCABKAFSDmV4ZWN1dGlvblByaWNlEhoKCHF1YW50aXR5GAUgASgBUghxdWFudG'
    'l0eRIhCgxyZWFsaXplZF9wbmwYBiABKAFSC3JlYWxpemVkUG5sEh4KCmNvbW1pc3Npb24YByAB'
    'KAFSCmNvbW1pc3Npb24SHQoKbGF0ZW5jeV9tcxgIIAEoA1IJbGF0ZW5jeU1zEhwKCXRpbWVzdG'
    'FtcBgJIAEoA1IJdGltZXN0YW1wEiEKDGlzX3NpbXVsYXRlZBgKIAEoCFILaXNTaW11bGF0ZWQS'
    'GQoIb3JkZXJfaWQYCyABKAlSB29yZGVySWQ=');
