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

abstract class CaseRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CaseRecordTable();

  static const db = CaseRecordRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CaseRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static CaseRecordInclude include() {
    return CaseRecordInclude._();
  }

  static CaseRecordIncludeList includeList({
    _is.WhereExpressionBuilder<CaseRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseRecordTable>? orderBy,
    _is.OrderByListBuilder<CaseRecordTable>? orderByList,
    CaseRecordInclude? include,
  }) {
    return CaseRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseRecord.t),
      orderByList: orderByList?.call(CaseRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class CaseRecordUpdateTable extends _is.UpdateTable<CaseRecordTable> {
  CaseRecordUpdateTable(super.table);

  _is.ColumnValue<String, String> applicantReference(String value) =>
      _is.ColumnValue(
        table.applicantReference,
        value,
      );

  _is.ColumnValue<String, String> schemeName(String value) => _is.ColumnValue(
    table.schemeName,
    value,
  );

  _is.ColumnValue<String, String> blockerCategory(String value) =>
      _is.ColumnValue(
        table.blockerCategory,
        value,
      );

  _is.ColumnValue<String, String> blockerDescription(String value) =>
      _is.ColumnValue(
        table.blockerDescription,
        value,
      );

  _is.ColumnValue<String, String> priority(String value) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class CaseRecordTable extends _is.Table<int?> {
  CaseRecordTable({super.tableRelation}) : super(tableName: 'case_record') {
    updateTable = CaseRecordUpdateTable(this);
    applicantReference = _is.ColumnString(
      'applicantReference',
      this,
    );
    schemeName = _is.ColumnString(
      'schemeName',
      this,
    );
    blockerCategory = _is.ColumnString(
      'blockerCategory',
      this,
    );
    blockerDescription = _is.ColumnString(
      'blockerDescription',
      this,
    );
    priority = _is.ColumnString(
      'priority',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final CaseRecordUpdateTable updateTable;

  /// Synthetic demo applicant reference (e.g., 'DEMO-PMMVY-2024-001'). Never real PII.
  late final _is.ColumnString applicantReference;

  /// Government scheme name (e.g., 'PMMVY', 'JSY').
  late final _is.ColumnString schemeName;

  /// Blocker category (e.g., 'Aadhaar Linkage', 'Bank Account / IFSC', 'Documentation').
  late final _is.ColumnString blockerCategory;

  /// Short blocker description detailing the issue.
  late final _is.ColumnString blockerDescription;

  /// Priority level (e.g., 'High', 'Medium', 'Low').
  late final _is.ColumnString priority;

  /// Current case status (e.g., 'Open', 'In Progress', 'Resolved').
  late final _is.ColumnString status;

  /// Timestamp when the case was recorded.
  late final _is.ColumnDateTime createdAt;

  /// Timestamp when the case was last updated.
  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    applicantReference,
    schemeName,
    blockerCategory,
    blockerDescription,
    priority,
    status,
    createdAt,
    updatedAt,
  ];
}

class CaseRecordInclude extends _is.IncludeObject {
  CaseRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CaseRecord.t;
}

class CaseRecordIncludeList extends _is.IncludeList {
  CaseRecordIncludeList._({
    _is.WhereExpressionBuilder<CaseRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CaseRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CaseRecord.t;
}

class CaseRecordRepository {
  const CaseRecordRepository._();

  /// Returns a list of [CaseRecord]s matching the given query parameters.
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
  Future<List<CaseRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseRecordTable>? orderBy,
    _is.OrderByListBuilder<CaseRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CaseRecord>(
      where: where?.call(CaseRecord.t),
      orderBy: orderBy?.call(CaseRecord.t),
      orderByList: orderByList?.call(CaseRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CaseRecord] matching the given query parameters.
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
  Future<CaseRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<CaseRecordTable>? orderBy,
    _is.OrderByListBuilder<CaseRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CaseRecord>(
      where: where?.call(CaseRecord.t),
      orderBy: orderBy?.call(CaseRecord.t),
      orderByList: orderByList?.call(CaseRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CaseRecord] by its [id] or null if no such row exists.
  Future<CaseRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CaseRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CaseRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [CaseRecord]s will have their `id` fields set.
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
  Future<List<CaseRecord>> insert(
    _is.DatabaseSession session,
    List<CaseRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CaseRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CaseRecord] and returns the inserted row.
  ///
  /// The returned [CaseRecord] will have its `id` field set.
  Future<CaseRecord> insertRow(
    _is.DatabaseSession session,
    CaseRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CaseRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CaseRecord]s in the list and returns the resulting rows.
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
  /// The returned [CaseRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseRecord>> upsert(
    _is.DatabaseSession session,
    List<CaseRecord> rows, {
    required _is.ColumnSelections<CaseRecordTable> conflictColumns,
    _is.ColumnSelections<CaseRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CaseRecord>(
      rows,
      conflictColumns: conflictColumns(CaseRecord.t),
      updateColumns: updateColumns?.call(CaseRecord.t),
      updateWhere: updateWhere?.call(CaseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CaseRecord] and returns the resulting row.
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
  /// The returned [CaseRecord] will have its `id` field set.
  Future<CaseRecord?> upsertRow(
    _is.DatabaseSession session,
    CaseRecord row, {
    required _is.ColumnSelections<CaseRecordTable> conflictColumns,
    _is.ColumnSelections<CaseRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CaseRecord>(
      row,
      conflictColumns: conflictColumns(CaseRecord.t),
      updateColumns: updateColumns?.call(CaseRecord.t),
      updateWhere: updateWhere?.call(CaseRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [CaseRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseRecord>> update(
    _is.DatabaseSession session,
    List<CaseRecord> rows, {
    _is.ColumnSelections<CaseRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CaseRecord>(
      rows,
      columns: columns?.call(CaseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CaseRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CaseRecord> updateRow(
    _is.DatabaseSession session,
    CaseRecord row, {
    _is.ColumnSelections<CaseRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CaseRecord>(
      row,
      columns: columns?.call(CaseRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CaseRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CaseRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CaseRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CaseRecord>(
      id,
      columnValues: columnValues(CaseRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CaseRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CaseRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CaseRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseRecordTable>? orderBy,
    _is.OrderByListBuilder<CaseRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CaseRecord>(
      columnValues: columnValues(CaseRecord.t.updateTable),
      where: where(CaseRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseRecord.t),
      orderByList: orderByList?.call(CaseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CaseRecord]s in the list and returns the deleted rows.
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
  Future<List<CaseRecord>> delete(
    _is.DatabaseSession session,
    List<CaseRecord> rows, {
    _is.OrderByBuilder<CaseRecordTable>? orderBy,
    _is.OrderByListBuilder<CaseRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CaseRecord>(
      rows,
      orderBy: orderBy?.call(CaseRecord.t),
      orderByList: orderByList?.call(CaseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CaseRecord].
  Future<CaseRecord> deleteRow(
    _is.DatabaseSession session,
    CaseRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CaseRecord>(
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
  Future<List<CaseRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseRecordTable> where,
    _is.OrderByBuilder<CaseRecordTable>? orderBy,
    _is.OrderByListBuilder<CaseRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CaseRecord>(
      where: where(CaseRecord.t),
      orderBy: orderBy?.call(CaseRecord.t),
      orderByList: orderByList?.call(CaseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CaseRecord>(
      where: where?.call(CaseRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CaseRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CaseRecord>(
      where: where(CaseRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
