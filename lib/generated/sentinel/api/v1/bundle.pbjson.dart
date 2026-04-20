// This is a generated file - do not edit.
//
// Generated from sentinel/api/v1/bundle.proto.

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

@$core.Deprecated('Use streamBundleDescriptor instead')
const StreamBundle$json = {
  '1': 'StreamBundle',
  '2': [
    {
      '1': 'trade',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.sentinel.market.v1.AggTrade',
      '9': 0,
      '10': 'trade'
    },
    {
      '1': 'report',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.sentinel.execution.v1.ExecutionReport',
      '9': 0,
      '10': 'report'
    },
    {
      '1': 'signal',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.sentinel.execution.v1.TradeSignal',
      '9': 0,
      '10': 'signal'
    },
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `StreamBundle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamBundleDescriptor = $convert.base64Decode(
    'CgxTdHJlYW1CdW5kbGUSNAoFdHJhZGUYASABKAsyHC5zZW50aW5lbC5tYXJrZXQudjEuQWdnVH'
    'JhZGVIAFIFdHJhZGUSQAoGcmVwb3J0GAIgASgLMiYuc2VudGluZWwuZXhlY3V0aW9uLnYxLkV4'
    'ZWN1dGlvblJlcG9ydEgAUgZyZXBvcnQSPAoGc2lnbmFsGAMgASgLMiIuc2VudGluZWwuZXhlY3'
    'V0aW9uLnYxLlRyYWRlU2lnbmFsSABSBnNpZ25hbEIJCgdtZXNzYWdl');
