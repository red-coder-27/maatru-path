/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:maatru_path_client/src/protocol/cases/case_action_log.dart'
    as _iscelriy;
import 'package:maatru_path_client/src/protocol/cases/case_record.dart'
    as _iv0e0teb;
import 'package:maatru_path_client/src/protocol/cases/recommended_action.dart'
    as _ijg6lfi3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'cases/case_action_log.dart' as _i88moqtp;
import 'cases/case_operation_exception.dart' as _i0g9emn8;
import 'cases/case_record.dart' as _i7x1vugv;
import 'cases/recommended_action.dart' as _it47fxpq;
import 'greetings/greeting.dart' as _izw8z7ou;
export 'cases/case_action_log.dart';
export 'cases/case_operation_exception.dart';
export 'cases/case_record.dart';
export 'cases/recommended_action.dart';
export 'greetings/greeting.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i88moqtp.CaseActionLog) {
      return _i88moqtp.CaseActionLog.fromJson(data) as T;
    }
    if (t == _i0g9emn8.CaseOperationException) {
      return _i0g9emn8.CaseOperationException.fromJson(data) as T;
    }
    if (t == _i7x1vugv.CaseRecord) {
      return _i7x1vugv.CaseRecord.fromJson(data) as T;
    }
    if (t == _it47fxpq.RecommendedAction) {
      return _it47fxpq.RecommendedAction.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _isc.getType<_i88moqtp.CaseActionLog?>()) {
      return (data != null ? _i88moqtp.CaseActionLog.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0g9emn8.CaseOperationException?>()) {
      return (data != null
              ? _i0g9emn8.CaseOperationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i7x1vugv.CaseRecord?>()) {
      return (data != null ? _i7x1vugv.CaseRecord.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_it47fxpq.RecommendedAction?>()) {
      return (data != null ? _it47fxpq.RecommendedAction.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_iv0e0teb.CaseRecord>) {
      return (data as List)
              .map((e) => deserialize<_iv0e0teb.CaseRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_iscelriy.CaseActionLog>) {
      return (data as List)
              .map((e) => deserialize<_iscelriy.CaseActionLog>(e))
              .toList()
          as T;
    }
    if (t == List<_ijg6lfi3.RecommendedAction>) {
      return (data as List)
              .map((e) => deserialize<_ijg6lfi3.RecommendedAction>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i88moqtp.CaseActionLog => 'CaseActionLog',
      _i0g9emn8.CaseOperationException => 'CaseOperationException',
      _i7x1vugv.CaseRecord => 'CaseRecord',
      _it47fxpq.RecommendedAction => 'RecommendedAction',
      _izw8z7ou.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('maatru_path.', '');
    }

    switch (data) {
      case _i88moqtp.CaseActionLog():
        return 'CaseActionLog';
      case _i0g9emn8.CaseOperationException():
        return 'CaseOperationException';
      case _i7x1vugv.CaseRecord():
        return 'CaseRecord';
      case _it47fxpq.RecommendedAction():
        return 'RecommendedAction';
      case _izw8z7ou.Greeting():
        return 'Greeting';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CaseActionLog') {
      return deserialize<_i88moqtp.CaseActionLog>(data['data']);
    }
    if (dataClassName == 'CaseOperationException') {
      return deserialize<_i0g9emn8.CaseOperationException>(data['data']);
    }
    if (dataClassName == 'CaseRecord') {
      return deserialize<_i7x1vugv.CaseRecord>(data['data']);
    }
    if (dataClassName == 'RecommendedAction') {
      return deserialize<_it47fxpq.RecommendedAction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('maatru_path', this);
    _iacc.Protocol().registerHostProtocol('maatru_path', this);
  }

  @override
  String getModuleName() => 'maatru_path';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
