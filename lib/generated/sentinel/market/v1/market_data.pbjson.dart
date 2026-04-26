// This is a generated file - do not edit.
//
// Generated from sentinel/market/v1/market_data.proto.

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

@$core.Deprecated('Use aggTradeDescriptor instead')
const AggTrade$json = {
  '1': 'AggTrade',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'price', '3': 2, '4': 1, '5': 1, '10': 'price'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 1, '10': 'quantity'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'is_buyer_maker', '3': 5, '4': 1, '5': 8, '10': 'isBuyerMaker'},
  ],
};

/// Descriptor for `AggTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aggTradeDescriptor = $convert.base64Decode(
    'CghBZ2dUcmFkZRIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBIUCgVwcmljZRgCIAEoAVIFcHJpY2'
    'USGgoIcXVhbnRpdHkYAyABKAFSCHF1YW50aXR5EhwKCXRpbWVzdGFtcBgEIAEoA1IJdGltZXN0'
    'YW1wEiQKDmlzX2J1eWVyX21ha2VyGAUgASgIUgxpc0J1eWVyTWFrZXI=');

@$core.Deprecated('Use rawNewsEventDescriptor instead')
const RawNewsEvent$json = {
  '1': 'RawNewsEvent',
  '2': [
    {'1': 'source', '3': 1, '4': 1, '5': 9, '10': 'source'},
    {'1': 'headline', '3': 2, '4': 1, '5': 9, '10': 'headline'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `RawNewsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rawNewsEventDescriptor = $convert.base64Decode(
    'CgxSYXdOZXdzRXZlbnQSFgoGc291cmNlGAEgASgJUgZzb3VyY2USGgoIaGVhZGxpbmUYAiABKA'
    'lSCGhlYWRsaW5lEhgKB2NvbnRlbnQYAyABKAlSB2NvbnRlbnQSHAoJdGltZXN0YW1wGAQgASgD'
    'Ugl0aW1lc3RhbXA=');

@$core.Deprecated('Use orderbookDepthDescriptor instead')
const OrderbookDepth$json = {
  '1': 'OrderbookDepth',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {
      '1': 'bids',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.sentinel.market.v1.PriceLevel',
      '10': 'bids'
    },
    {
      '1': 'asks',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.sentinel.market.v1.PriceLevel',
      '10': 'asks'
    },
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `OrderbookDepth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderbookDepthDescriptor = $convert.base64Decode(
    'Cg5PcmRlcmJvb2tEZXB0aBIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBIyCgRiaWRzGAIgAygLMh'
    '4uc2VudGluZWwubWFya2V0LnYxLlByaWNlTGV2ZWxSBGJpZHMSMgoEYXNrcxgDIAMoCzIeLnNl'
    'bnRpbmVsLm1hcmtldC52MS5QcmljZUxldmVsUgRhc2tzEhwKCXRpbWVzdGFtcBgEIAEoA1IJdG'
    'ltZXN0YW1w');

@$core.Deprecated('Use priceLevelDescriptor instead')
const PriceLevel$json = {
  '1': 'PriceLevel',
  '2': [
    {'1': 'price', '3': 1, '4': 1, '5': 1, '10': 'price'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 1, '10': 'quantity'},
  ],
};

/// Descriptor for `PriceLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List priceLevelDescriptor = $convert.base64Decode(
    'CgpQcmljZUxldmVsEhQKBXByaWNlGAEgASgBUgVwcmljZRIaCghxdWFudGl0eRgCIAEoAVIIcX'
    'VhbnRpdHk=');

@$core.Deprecated('Use marketStateVectorDescriptor instead')
const MarketStateVector$json = {
  '1': 'MarketStateVector',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'window_start_time', '3': 2, '4': 1, '5': 3, '10': 'windowStartTime'},
    {'1': 'window_end_time', '3': 3, '4': 1, '5': 3, '10': 'windowEndTime'},
    {'1': 'price_velocity', '3': 4, '4': 1, '5': 1, '10': 'priceVelocity'},
    {'1': 'volume_imbalance', '3': 5, '4': 1, '5': 1, '10': 'volumeImbalance'},
    {'1': 'sentiment_score', '3': 6, '4': 1, '5': 1, '10': 'sentimentScore'},
    {'1': 'embeddings', '3': 7, '4': 3, '5': 1, '10': 'embeddings'},
    {'1': 'chain_urgency', '3': 8, '4': 1, '5': 1, '10': 'chainUrgency'},
  ],
};

/// Descriptor for `MarketStateVector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketStateVectorDescriptor = $convert.base64Decode(
    'ChFNYXJrZXRTdGF0ZVZlY3RvchIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBIqChF3aW5kb3dfc3'
    'RhcnRfdGltZRgCIAEoA1IPd2luZG93U3RhcnRUaW1lEiYKD3dpbmRvd19lbmRfdGltZRgDIAEo'
    'A1INd2luZG93RW5kVGltZRIlCg5wcmljZV92ZWxvY2l0eRgEIAEoAVINcHJpY2VWZWxvY2l0eR'
    'IpChB2b2x1bWVfaW1iYWxhbmNlGAUgASgBUg92b2x1bWVJbWJhbGFuY2USJwoPc2VudGltZW50'
    'X3Njb3JlGAYgASgBUg5zZW50aW1lbnRTY29yZRIeCgplbWJlZGRpbmdzGAcgAygBUgplbWJlZG'
    'RpbmdzEiMKDWNoYWluX3VyZ2VuY3kYCCABKAFSDGNoYWluVXJnZW5jeQ==');

@$core.Deprecated('Use chainUrgencyEventDescriptor instead')
const ChainUrgencyEvent$json = {
  '1': 'ChainUrgencyEvent',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'urgency_score', '3': 2, '4': 1, '5': 1, '10': 'urgencyScore'},
    {'1': 'network_fee', '3': 3, '4': 1, '5': 1, '10': 'networkFee'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `ChainUrgencyEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chainUrgencyEventDescriptor = $convert.base64Decode(
    'ChFDaGFpblVyZ2VuY3lFdmVudBIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBIjCg11cmdlbmN5X3'
    'Njb3JlGAIgASgBUgx1cmdlbmN5U2NvcmUSHwoLbmV0d29ya19mZWUYAyABKAFSCm5ldHdvcmtG'
    'ZWUSHAoJdGltZXN0YW1wGAQgASgDUgl0aW1lc3RhbXA=');
