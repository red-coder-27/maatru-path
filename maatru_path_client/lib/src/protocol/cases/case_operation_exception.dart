/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class CaseOperationException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  CaseOperationException._({required this.message});

  factory CaseOperationException({required String message}) =
      _CaseOperationExceptionImpl;

  factory CaseOperationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CaseOperationException(
      message: jsonSerialization['message'] as String,
    );
  }

  /// Human-readable safe validation or business error message.
  String message;

  /// Returns a shallow copy of this [CaseOperationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaseOperationException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseOperationException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseOperationException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'CaseOperationException(message: $message)';
  }
}

class _CaseOperationExceptionImpl extends CaseOperationException {
  _CaseOperationExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [CaseOperationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaseOperationException copyWith({String? message}) {
    return CaseOperationException(message: message ?? this.message);
  }
}
