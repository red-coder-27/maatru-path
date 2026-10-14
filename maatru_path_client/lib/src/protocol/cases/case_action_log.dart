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

abstract class CaseActionLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CaseActionLog._({
    this.id,
    required this.caseId,
    required this.actionType,
    this.previousStatus,
    this.newStatus,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CaseActionLog({
    int? id,
    required int caseId,
    required String actionType,
    String? previousStatus,
    String? newStatus,
    String? note,
    DateTime? createdAt,
  }) = _CaseActionLogImpl;

  factory CaseActionLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaseActionLog(
      id: jsonSerialization['id'] as int?,
      caseId: jsonSerialization['caseId'] as int,
      actionType: jsonSerialization['actionType'] as String,
      previousStatus: jsonSerialization['previousStatus'] as String?,
      newStatus: jsonSerialization['newStatus'] as String?,
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the associated case record.
  int caseId;

  /// Action type performed (e.g., 'created', 'status_change', 'note_added').
  String actionType;

  /// Previous status before the action, if applicable.
  String? previousStatus;

  /// New status after the action, if applicable.
  String? newStatus;

  /// Short action note describing remediation or update.
  String? note;

  /// Timestamp when the action was recorded.
  DateTime createdAt;

  /// Returns a shallow copy of this [CaseActionLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaseActionLog copyWith({
    int? id,
    int? caseId,
    String? actionType,
    String? previousStatus,
    String? newStatus,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseActionLog',
      if (id != null) 'id': id,
      'caseId': caseId,
      'actionType': actionType,
      if (previousStatus != null) 'previousStatus': previousStatus,
      if (newStatus != null) 'newStatus': newStatus,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseActionLog',
      if (id != null) 'id': id,
      'caseId': caseId,
      'actionType': actionType,
      if (previousStatus != null) 'previousStatus': previousStatus,
      if (newStatus != null) 'newStatus': newStatus,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseActionLogImpl extends CaseActionLog {
  _CaseActionLogImpl({
    int? id,
    required int caseId,
    required String actionType,
    String? previousStatus,
    String? newStatus,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         caseId: caseId,
         actionType: actionType,
         previousStatus: previousStatus,
         newStatus: newStatus,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CaseActionLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaseActionLog copyWith({
    Object? id = _Undefined,
    int? caseId,
    String? actionType,
    Object? previousStatus = _Undefined,
    Object? newStatus = _Undefined,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return CaseActionLog(
      id: id is int? ? id : this.id,
      caseId: caseId ?? this.caseId,
      actionType: actionType ?? this.actionType,
      previousStatus: previousStatus is String?
          ? previousStatus
          : this.previousStatus,
      newStatus: newStatus is String? ? newStatus : this.newStatus,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
