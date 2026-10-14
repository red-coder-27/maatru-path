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

abstract class RecommendedAction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RecommendedAction._({
    required this.category,
    required this.explanation,
    required this.prioritizedNextAction,
    required this.practicalFollowUp,
    required this.requiresOfficialVerification,
    this.officialReferenceUrl,
  });

  factory RecommendedAction({
    required String category,
    required String explanation,
    required String prioritizedNextAction,
    required String practicalFollowUp,
    required bool requiresOfficialVerification,
    String? officialReferenceUrl,
  }) = _RecommendedActionImpl;

  factory RecommendedAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecommendedAction(
      category: jsonSerialization['category'] as String,
      explanation: jsonSerialization['explanation'] as String,
      prioritizedNextAction:
          jsonSerialization['prioritizedNextAction'] as String,
      practicalFollowUp: jsonSerialization['practicalFollowUp'] as String,
      requiresOfficialVerification: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['requiresOfficialVerification'],
      ),
      officialReferenceUrl:
          jsonSerialization['officialReferenceUrl'] as String?,
    );
  }

  /// The blocker category this recommendation applies to.
  String category;

  /// Concise explanation of the obstacle.
  String explanation;

  /// Prioritized next step for the community worker.
  String prioritizedNextAction;

  /// Practical follow-up suggestion.
  String practicalFollowUp;

  /// Whether this guidance requires official department verification.
  bool requiresOfficialVerification;

  /// Official portal or verification URL, populated only when verified.
  String? officialReferenceUrl;

  /// Returns a shallow copy of this [RecommendedAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecommendedAction copyWith({
    String? category,
    String? explanation,
    String? prioritizedNextAction,
    String? practicalFollowUp,
    bool? requiresOfficialVerification,
    String? officialReferenceUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecommendedAction',
      'category': category,
      'explanation': explanation,
      'prioritizedNextAction': prioritizedNextAction,
      'practicalFollowUp': practicalFollowUp,
      'requiresOfficialVerification': requiresOfficialVerification,
      if (officialReferenceUrl != null)
        'officialReferenceUrl': officialReferenceUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecommendedAction',
      'category': category,
      'explanation': explanation,
      'prioritizedNextAction': prioritizedNextAction,
      'practicalFollowUp': practicalFollowUp,
      'requiresOfficialVerification': requiresOfficialVerification,
      if (officialReferenceUrl != null)
        'officialReferenceUrl': officialReferenceUrl,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecommendedActionImpl extends RecommendedAction {
  _RecommendedActionImpl({
    required String category,
    required String explanation,
    required String prioritizedNextAction,
    required String practicalFollowUp,
    required bool requiresOfficialVerification,
    String? officialReferenceUrl,
  }) : super._(
         category: category,
         explanation: explanation,
         prioritizedNextAction: prioritizedNextAction,
         practicalFollowUp: practicalFollowUp,
         requiresOfficialVerification: requiresOfficialVerification,
         officialReferenceUrl: officialReferenceUrl,
       );

  /// Returns a shallow copy of this [RecommendedAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecommendedAction copyWith({
    String? category,
    String? explanation,
    String? prioritizedNextAction,
    String? practicalFollowUp,
    bool? requiresOfficialVerification,
    Object? officialReferenceUrl = _Undefined,
  }) {
    return RecommendedAction(
      category: category ?? this.category,
      explanation: explanation ?? this.explanation,
      prioritizedNextAction:
          prioritizedNextAction ?? this.prioritizedNextAction,
      practicalFollowUp: practicalFollowUp ?? this.practicalFollowUp,
      requiresOfficialVerification:
          requiresOfficialVerification ?? this.requiresOfficialVerification,
      officialReferenceUrl: officialReferenceUrl is String?
          ? officialReferenceUrl
          : this.officialReferenceUrl,
    );
  }
}
