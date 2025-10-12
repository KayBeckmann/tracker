// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GreetingEntriesTable extends GreetingEntries
    with TableInfo<$GreetingEntriesTable, GreetingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GreetingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unbekannt'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, message, source, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'greeting_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<GreetingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GreetingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GreetingEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GreetingEntriesTable createAlias(String alias) {
    return $GreetingEntriesTable(attachedDatabase, alias);
  }
}

class GreetingEntry extends DataClass implements Insertable<GreetingEntry> {
  final int id;
  final String name;
  final String message;
  final String source;
  final DateTime createdAt;
  const GreetingEntry({
    required this.id,
    required this.name,
    required this.message,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['message'] = Variable<String>(message);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GreetingEntriesCompanion toCompanion(bool nullToAbsent) {
    return GreetingEntriesCompanion(
      id: Value(id),
      name: Value(name),
      message: Value(message),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory GreetingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GreetingEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      message: serializer.fromJson<String>(json['message']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'message': serializer.toJson<String>(message),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GreetingEntry copyWith({
    int? id,
    String? name,
    String? message,
    String? source,
    DateTime? createdAt,
  }) => GreetingEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    message: message ?? this.message,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  GreetingEntry copyWithCompanion(GreetingEntriesCompanion data) {
    return GreetingEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      message: data.message.present ? data.message.value : this.message,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GreetingEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, message, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GreetingEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.message == this.message &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class GreetingEntriesCompanion extends UpdateCompanion<GreetingEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> message;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const GreetingEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.message = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GreetingEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String message,
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       message = Value(message);
  static Insertable<GreetingEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? message,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (message != null) 'message': message,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GreetingEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? message,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return GreetingEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      message: message ?? this.message,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GreetingEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GreetingEntriesTable greetingEntries = $GreetingEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [greetingEntries];
}

typedef $$GreetingEntriesTableCreateCompanionBuilder =
    GreetingEntriesCompanion Function({
      Value<int> id,
      required String name,
      required String message,
      Value<String> source,
      Value<DateTime> createdAt,
    });
typedef $$GreetingEntriesTableUpdateCompanionBuilder =
    GreetingEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> message,
      Value<String> source,
      Value<DateTime> createdAt,
    });

class $$GreetingEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $GreetingEntriesTable> {
  $$GreetingEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GreetingEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GreetingEntriesTable> {
  $$GreetingEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GreetingEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GreetingEntriesTable> {
  $$GreetingEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GreetingEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GreetingEntriesTable,
          GreetingEntry,
          $$GreetingEntriesTableFilterComposer,
          $$GreetingEntriesTableOrderingComposer,
          $$GreetingEntriesTableAnnotationComposer,
          $$GreetingEntriesTableCreateCompanionBuilder,
          $$GreetingEntriesTableUpdateCompanionBuilder,
          (
            GreetingEntry,
            BaseReferences<_$AppDatabase, $GreetingEntriesTable, GreetingEntry>,
          ),
          GreetingEntry,
          PrefetchHooks Function()
        > {
  $$GreetingEntriesTableTableManager(
    _$AppDatabase db,
    $GreetingEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GreetingEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GreetingEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GreetingEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GreetingEntriesCompanion(
                id: id,
                name: name,
                message: message,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String message,
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GreetingEntriesCompanion.insert(
                id: id,
                name: name,
                message: message,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GreetingEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GreetingEntriesTable,
      GreetingEntry,
      $$GreetingEntriesTableFilterComposer,
      $$GreetingEntriesTableOrderingComposer,
      $$GreetingEntriesTableAnnotationComposer,
      $$GreetingEntriesTableCreateCompanionBuilder,
      $$GreetingEntriesTableUpdateCompanionBuilder,
      (
        GreetingEntry,
        BaseReferences<_$AppDatabase, $GreetingEntriesTable, GreetingEntry>,
      ),
      GreetingEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GreetingEntriesTableTableManager get greetingEntries =>
      $$GreetingEntriesTableTableManager(_db, _db.greetingEntries);
}
