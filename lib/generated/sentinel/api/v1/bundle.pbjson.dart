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
    {
      '1': 'command',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.sentinel.api.v1.ControlCommand',
      '9': 0,
      '10': 'command'
    },
    {
      '1': 'equity',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.sentinel.wallet.v1.EquitySnapshot',
      '9': 0,
      '10': 'equity'
    },
    {
      '1': 'vector',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.sentinel.market.v1.MarketStateVector',
      '9': 0,
      '10': 'vector'
    },
    {
      '1': 'rejection',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.sentinel.execution.v1.ExecutionRejection',
      '9': 0,
      '10': 'rejection'
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
    'V0aW9uLnYxLlRyYWRlU2lnbmFsSABSBnNpZ25hbBI7Cgdjb21tYW5kGAQgASgLMh8uc2VudGlu'
    'ZWwuYXBpLnYxLkNvbnRyb2xDb21tYW5kSABSB2NvbW1hbmQSPAoGZXF1aXR5GAUgASgLMiIuc2'
    'VudGluZWwud2FsbGV0LnYxLkVxdWl0eVNuYXBzaG90SABSBmVxdWl0eRI/CgZ2ZWN0b3IYBiAB'
    'KAsyJS5zZW50aW5lbC5tYXJrZXQudjEuTWFya2V0U3RhdGVWZWN0b3JIAFIGdmVjdG9yEkkKCX'
    'JlamVjdGlvbhgHIAEoCzIpLnNlbnRpbmVsLmV4ZWN1dGlvbi52MS5FeGVjdXRpb25SZWplY3Rp'
    'b25IAFIJcmVqZWN0aW9uQgkKB21lc3NhZ2U=');

@$core.Deprecated('Use controlCommandDescriptor instead')
const ControlCommand$json = {
  '1': 'ControlCommand',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.sentinel.api.v1.ControlCommand.CommandType',
      '10': 'type'
    },
  ],
  '4': [ControlCommand_CommandType$json],
};

@$core.Deprecated('Use controlCommandDescriptor instead')
const ControlCommand_CommandType$json = {
  '1': 'CommandType',
  '2': [
    {'1': 'COMMAND_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'COMMAND_TYPE_STOP_ALL', '2': 1},
    {'1': 'COMMAND_TYPE_START_ALL', '2': 2},
    {'1': 'COMMAND_TYPE_EXTINCTION_PROTOCOL', '2': 3},
  ],
};

/// Descriptor for `ControlCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List controlCommandDescriptor = $convert.base64Decode(
    'Cg5Db250cm9sQ29tbWFuZBI/CgR0eXBlGAEgASgOMisuc2VudGluZWwuYXBpLnYxLkNvbnRyb2'
    'xDb21tYW5kLkNvbW1hbmRUeXBlUgR0eXBlIogBCgtDb21tYW5kVHlwZRIcChhDT01NQU5EX1RZ'
    'UEVfVU5TUEVDSUZJRUQQABIZChVDT01NQU5EX1RZUEVfU1RPUF9BTEwQARIaChZDT01NQU5EX1'
    'RZUEVfU1RBUlRfQUxMEAISJAogQ09NTUFORF9UWVBFX0VYVElOQ1RJT05fUFJPVE9DT0wQAw==');
