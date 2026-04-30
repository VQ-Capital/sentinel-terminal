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

class ControlCommand_CommandType extends $pb.ProtobufEnum {
  static const ControlCommand_CommandType COMMAND_TYPE_UNSPECIFIED =
      ControlCommand_CommandType._(
          0, _omitEnumNames ? '' : 'COMMAND_TYPE_UNSPECIFIED');
  static const ControlCommand_CommandType COMMAND_TYPE_STOP_ALL =
      ControlCommand_CommandType._(
          1, _omitEnumNames ? '' : 'COMMAND_TYPE_STOP_ALL');
  static const ControlCommand_CommandType COMMAND_TYPE_START_ALL =
      ControlCommand_CommandType._(
          2, _omitEnumNames ? '' : 'COMMAND_TYPE_START_ALL');
  static const ControlCommand_CommandType COMMAND_TYPE_EXTINCTION_PROTOCOL =
      ControlCommand_CommandType._(
          3, _omitEnumNames ? '' : 'COMMAND_TYPE_EXTINCTION_PROTOCOL');

  static const $core.List<ControlCommand_CommandType> values =
      <ControlCommand_CommandType>[
    COMMAND_TYPE_UNSPECIFIED,
    COMMAND_TYPE_STOP_ALL,
    COMMAND_TYPE_START_ALL,
    COMMAND_TYPE_EXTINCTION_PROTOCOL,
  ];

  static final $core.List<ControlCommand_CommandType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ControlCommand_CommandType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ControlCommand_CommandType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
