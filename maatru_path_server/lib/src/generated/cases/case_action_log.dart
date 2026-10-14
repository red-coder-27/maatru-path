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
import 'package:serverpod/serverpod.dart' as _is;

abstract class CaseActionLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CaseActionLogTable();

  static const db = CaseActionLogRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CaseActionLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static CaseActionLogInclude include() {
    return CaseActionLogInclude._();
  }

  static CaseActionLogIncludeList includeList({
    _is.WhereExpressionBuilder<CaseActionLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseActionLogTable>? orderBy,
    _is.OrderByListBuilder<CaseActionLogTable>? orderByList,
    CaseActionLogInclude? include,
  }) {
    return CaseActionLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseActionLog.t),
      orderByList: orderByList?.call(CaseActionLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class CaseActionLogUpdateTable extends _is.UpdateTable<CaseActionLogTable> {
  CaseActionLogUpdateTable(super.table);

  _is.ColumnValue<int, int> caseId(int value) => _is.ColumnValue(
    table.caseId,
    value,
  );

  _is.ColumnValue<String, String> actionType(String value) => _is.ColumnValue(
    table.actionType,
    value,
  );

  _is.ColumnValue<String, String> previousStatus(String? value) =>
      _is.ColumnValue(
        table.previousStatus,
        value,
      );

  _is.ColumnValue<String, String> newStatus(String? value) => _is.ColumnValue(
    table.newStatus,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CaseActionLogTable extends _is.Table<int?> {
  CaseActionLogTable({super.tableRelation})
    : super(tableName: 'case_action_log') {
    updateTable = CaseActionLogUpdateTable(this);
    caseId = _is.ColumnInt(
      'caseId',
      this,
    );
    actionType = _is.ColumnString(
      'actionType',
      this,
    );
    previousStatus = _is.ColumnString(
      'previousStatus',
      this,
    );
    newStatus = _is.ColumnString(
      'newStatus',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CaseActionLogUpdateTable updateTable;

  /// Reference to the associated case record.
  late final _is.ColumnInt caseId;

  /// Action type performed (e.g., 'created', 'status_change', 'note_added').
  late final _is.ColumnString actionType;

  /// Previous status before the action, if applicable.
  late final _is.ColumnString previousStatus;

  /// New status after the action, if applicable.
  late final _is.ColumnString newStatus;

  /// Short action note describing remediation or update.
  late final _is.ColumnString note;

  /// Timestamp when the action was recorded.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    caseId,
    actionType,
    previousStatus,
    newStatus,
    note,
    createdAt,
  ];
}

class CaseActionLogInclude extends _is.IncludeObject {
  CaseActionLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CaseActionLog.t;
}

class CaseActionLogIncludeList extends _is.IncludeList {
  CaseActionLogIncludeList._({
    _is.WhereExpressionBuilder<CaseActionLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CaseActionLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CaseActionLog.t;
}

class CaseActionLogRepository {
  const CaseActionLogRepository._();

  /// Returns a list of [CaseActionLog]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<CaseActionLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseActionLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseActionLogTable>? orderBy,
    _is.OrderByListBuilder<CaseActionLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CaseActionLog>(
      where: where?.call(CaseActionLog.t),
      orderBy: orderBy?.call(CaseActionLog.t),
      orderByList: orderByList?.call(CaseActionLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CaseActionLog] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CaseActionLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseActionLogTable>? where,
    int? offset,
    _is.OrderByBuilder<CaseActionLogTable>? orderBy,
    _is.OrderByListBuilder<CaseActionLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CaseActionLog>(
      where: where?.call(CaseActionLog.t),
      orderBy: orderBy?.call(CaseActionLog.t),
      orderByList: orderByList?.call(CaseActionLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CaseActionLog] by its [id] or null if no such row exists.
  Future<CaseActionLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CaseActionLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CaseActionLog]s in the list and returns the inserted rows.
  ///
  /// The returned [CaseActionLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseActionLog>> insert(
    _is.DatabaseSession session,
    List<CaseActionLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CaseActionLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CaseActionLog] and returns the inserted row.
  ///
  /// The returned [CaseActionLog] will have its `id` field set.
  Future<CaseActionLog> insertRow(
    _is.DatabaseSession session,
    CaseActionLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CaseActionLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CaseActionLog]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [CaseActionLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseActionLog>> upsert(
    _is.DatabaseSession session,
    List<CaseActionLog> rows, {
    required _is.ColumnSelections<CaseActionLogTable> conflictColumns,
    _is.ColumnSelections<CaseActionLogTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseActionLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CaseActionLog>(
      rows,
      conflictColumns: conflictColumns(CaseActionLog.t),
      updateColumns: updateColumns?.call(CaseActionLog.t),
      updateWhere: updateWhere?.call(CaseActionLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CaseActionLog] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [CaseActionLog] will have its `id` field set.
  Future<CaseActionLog?> upsertRow(
    _is.DatabaseSession session,
    CaseActionLog row, {
    required _is.ColumnSelections<CaseActionLogTable> conflictColumns,
    _is.ColumnSelections<CaseActionLogTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseActionLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CaseActionLog>(
      row,
      conflictColumns: conflictColumns(CaseActionLog.t),
      updateColumns: updateColumns?.call(CaseActionLog.t),
      updateWhere: updateWhere?.call(CaseActionLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [CaseActionLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseActionLog>> update(
    _is.DatabaseSession session,
    List<CaseActionLog> rows, {
    _is.ColumnSelections<CaseActionLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CaseActionLog>(
      rows,
      columns: columns?.call(CaseActionLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CaseActionLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CaseActionLog> updateRow(
    _is.DatabaseSession session,
    CaseActionLog row, {
    _is.ColumnSelections<CaseActionLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CaseActionLog>(
      row,
      columns: columns?.call(CaseActionLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CaseActionLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CaseActionLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CaseActionLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CaseActionLog>(
      id,
      columnValues: columnValues(CaseActionLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CaseActionLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseActionLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CaseActionLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CaseActionLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseActionLogTable>? orderBy,
    _is.OrderByListBuilder<CaseActionLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CaseActionLog>(
      columnValues: columnValues(CaseActionLog.t.updateTable),
      where: where(CaseActionLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseActionLog.t),
      orderByList: orderByList?.call(CaseActionLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CaseActionLog]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseActionLog>> delete(
    _is.DatabaseSession session,
    List<CaseActionLog> rows, {
    _is.OrderByBuilder<CaseActionLogTable>? orderBy,
    _is.OrderByListBuilder<CaseActionLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CaseActionLog>(
      rows,
      orderBy: orderBy?.call(CaseActionLog.t),
      orderByList: orderByList?.call(CaseActionLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CaseActionLog].
  Future<CaseActionLog> deleteRow(
    _is.DatabaseSession session,
    CaseActionLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CaseActionLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseActionLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseActionLogTable> where,
    _is.OrderByBuilder<CaseActionLogTable>? orderBy,
    _is.OrderByListBuilder<CaseActionLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CaseActionLog>(
      where: where(CaseActionLog.t),
      orderBy: orderBy?.call(CaseActionLog.t),
      orderByList: orderByList?.call(CaseActionLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseActionLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CaseActionLog>(
      where: where?.call(CaseActionLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CaseActionLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseActionLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CaseActionLog>(
      where: where(CaseActionLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
