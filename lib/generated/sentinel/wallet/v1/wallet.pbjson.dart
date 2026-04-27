// This is a generated file - do not edit.
//
// Generated from sentinel/wallet/v1/wallet.proto.

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

@$core.Deprecated('Use equitySnapshotDescriptor instead')
const EquitySnapshot$json = {
  '1': 'EquitySnapshot',
  '2': [
    {'1': 'total_equity_usd', '3': 1, '4': 1, '5': 1, '10': 'totalEquityUsd'},
    {
      '1': 'available_margin_usd',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'availableMarginUsd'
    },
    {
      '1': 'total_unrealized_pnl',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'totalUnrealizedPnl'
    },
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'is_reconciled', '3': 5, '4': 1, '5': 8, '10': 'isReconciled'},
    {'1': 'max_drawdown_pct', '3': 6, '4': 1, '5': 1, '10': 'maxDrawdownPct'},
    {'1': 'sharpe_ratio', '3': 7, '4': 1, '5': 1, '10': 'sharpeRatio'},
  ],
};

/// Descriptor for `EquitySnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equitySnapshotDescriptor = $convert.base64Decode(
    'Cg5FcXVpdHlTbmFwc2hvdBIoChB0b3RhbF9lcXVpdHlfdXNkGAEgASgBUg50b3RhbEVxdWl0eV'
    'VzZBIwChRhdmFpbGFibGVfbWFyZ2luX3VzZBgCIAEoAVISYXZhaWxhYmxlTWFyZ2luVXNkEjAK'
    'FHRvdGFsX3VucmVhbGl6ZWRfcG5sGAMgASgBUhJ0b3RhbFVucmVhbGl6ZWRQbmwSHAoJdGltZX'
    'N0YW1wGAQgASgDUgl0aW1lc3RhbXASIwoNaXNfcmVjb25jaWxlZBgFIAEoCFIMaXNSZWNvbmNp'
    'bGVkEigKEG1heF9kcmF3ZG93bl9wY3QYBiABKAFSDm1heERyYXdkb3duUGN0EiEKDHNoYXJwZV'
    '9yYXRpbxgHIAEoAVILc2hhcnBlUmF0aW8=');
