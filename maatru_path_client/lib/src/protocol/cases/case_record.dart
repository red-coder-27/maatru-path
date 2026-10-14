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

abstract class CaseRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CaseRecord._({
    this.id,
    required this.applicantReference,
    required this.schemeName,
    required this.blockerCategory,
    required this.blockerDescription,
    required this.priority,
    required this.status,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CaseRecord({
    int? id,
    required String applicantReference,
    required String schemeName,
    required String blockerCategory,
    required String blockerDescription,
    required String priority,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CaseRecordImpl;

  factory CaseRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaseRecord(
      id: jsonSerialization['id'] as int?,
      applicantReference: jsonSerialization['applicantReference'] as String,
      schemeName: jsonSerialization['schemeName'] as String,
      blockerCategory: jsonSerialization['blockerCategory'] as String,
      blockerDescription: jsonSerialization['blockerDescription'] as String,
      priority: jsonSerialization['priority'] as String,
      status: jsonSerialization['status'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Synthetic demo applicant reference (e.g., 'DEMO-PMMVY-2024-001'). Never real PII.
  String applicantReference;

  /// Government scheme name (e.g., 'PMMVY', 'JSY').
  String schemeName;

  /// Blocker category (e.g., 'Aadhaar Linkage', 'Bank Account / IFSC', 'Documentation').
  String blockerCategory;

  /// Short blocker description detailing the issue.
  String blockerDescription;

  /// Priority level (e.g., 'High', 'Medium', 'Low').
  String priority;

  /// Current case status (e.g., 'Open', 'In Progress', 'Resolved').
  String status;

  /// Timestamp when the case was recorded.
  DateTime createdAt;

  /// Timestamp when the case was last updated.
  DateTime? updatedAt;

  /// Returns a shallow copy of this [CaseRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaseRecord copyWith({
    int? id,
    String? applicantReference,
    String? schemeName,
    String? blockerCategory,
    String? blockerDescription,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseRecord',
      if (id != null) 'id': id,
      'applicantReference': applicantReference,
      'schemeName': schemeName,
      'blockerCategory': blockerCategory,
      'blockerDescription': blockerDescription,
      'priority': priority,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseRecord',
      if (id != null) 'id': id,
      'applicantReference': applicantReference,
      'schemeName': schemeName,
      'blockerCategory': blockerCategory,
      'blockerDescription': blockerDescription,
      'priority': priority,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseRecordImpl extends CaseRecord {
  _CaseRecordImpl({
    int? id,
    required String applicantReference,
    required String schemeName,
    required String blockerCategory,
    required String blockerDescription,
    required String priority,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         applicantReference: applicantReference,
         schemeName: schemeName,
         blockerCategory: blockerCategory,
         blockerDescription: blockerDescription,
         priority: priority,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CaseRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaseRecord copyWith({
    Object? id = _Undefined,
    String? applicantReference,
    String? schemeName,
    String? blockerCategory,
    String? blockerDescription,
    String? priority,
    String? status,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return CaseRecord(
      id: id is int? ? id : this.id,
      applicantReference: applicantReference ?? this.applicantReference,
      schemeName: schemeName ?? this.schemeName,
      blockerCategory: blockerCategory ?? this.blockerCategory,
      blockerDescription: blockerDescription ?? this.blockerDescription,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
