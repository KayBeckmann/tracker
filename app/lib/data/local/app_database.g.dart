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

class $NoteEntriesTable extends NoteEntries
    with TableInfo<$NoteEntriesTable, NoteEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _drawingJsonMeta = const VerificationMeta(
    'drawingJson',
  );
  @override
  late final GeneratedColumn<String> drawingJson = GeneratedColumn<String>(
    'drawing_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<NoteKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(NoteKind.markdown.name),
      ).withConverter<NoteKind>($NoteEntriesTable.$converterkind);
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    drawingJson,
    tags,
    kind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('drawing_json')) {
      context.handle(
        _drawingJsonMeta,
        drawingJson.isAcceptableOrUnknown(
          data['drawing_json']!,
          _drawingJsonMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      drawingJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drawing_json'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      kind: $NoteEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NoteEntriesTable createAlias(String alias) {
    return $NoteEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NoteKind, String, String> $converterkind =
      const EnumNameConverter<NoteKind>(NoteKind.values);
}

class NoteEntry extends DataClass implements Insertable<NoteEntry> {
  final int id;
  final String title;
  final String? content;
  final String? drawingJson;
  final String tags;
  final NoteKind kind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoteEntry({
    required this.id,
    required this.title,
    this.content,
    this.drawingJson,
    required this.tags,
    required this.kind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || drawingJson != null) {
      map['drawing_json'] = Variable<String>(drawingJson);
    }
    map['tags'] = Variable<String>(tags);
    {
      map['kind'] = Variable<String>(
        $NoteEntriesTable.$converterkind.toSql(kind),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NoteEntriesCompanion toCompanion(bool nullToAbsent) {
    return NoteEntriesCompanion(
      id: Value(id),
      title: Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      drawingJson: drawingJson == null && nullToAbsent
          ? const Value.absent()
          : Value(drawingJson),
      tags: Value(tags),
      kind: Value(kind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      drawingJson: serializer.fromJson<String?>(json['drawingJson']),
      tags: serializer.fromJson<String>(json['tags']),
      kind: $NoteEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String?>(content),
      'drawingJson': serializer.toJson<String?>(drawingJson),
      'tags': serializer.toJson<String>(tags),
      'kind': serializer.toJson<String>(
        $NoteEntriesTable.$converterkind.toJson(kind),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoteEntry copyWith({
    int? id,
    String? title,
    Value<String?> content = const Value.absent(),
    Value<String?> drawingJson = const Value.absent(),
    String? tags,
    NoteKind? kind,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoteEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content.present ? content.value : this.content,
    drawingJson: drawingJson.present ? drawingJson.value : this.drawingJson,
    tags: tags ?? this.tags,
    kind: kind ?? this.kind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NoteEntry copyWithCompanion(NoteEntriesCompanion data) {
    return NoteEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      drawingJson: data.drawingJson.present
          ? data.drawingJson.value
          : this.drawingJson,
      tags: data.tags.present ? data.tags.value : this.tags,
      kind: data.kind.present ? data.kind.value : this.kind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('drawingJson: $drawingJson, ')
          ..write('tags: $tags, ')
          ..write('kind: $kind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    content,
    drawingJson,
    tags,
    kind,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.drawingJson == this.drawingJson &&
          other.tags == this.tags &&
          other.kind == this.kind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NoteEntriesCompanion extends UpdateCompanion<NoteEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> content;
  final Value<String?> drawingJson;
  final Value<String> tags;
  final Value<NoteKind> kind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NoteEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.drawingJson = const Value.absent(),
    this.tags = const Value.absent(),
    this.kind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NoteEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.drawingJson = const Value.absent(),
    this.tags = const Value.absent(),
    this.kind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<NoteEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? drawingJson,
    Expression<String>? tags,
    Expression<String>? kind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (drawingJson != null) 'drawing_json': drawingJson,
      if (tags != null) 'tags': tags,
      if (kind != null) 'kind': kind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NoteEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? content,
    Value<String?>? drawingJson,
    Value<String>? tags,
    Value<NoteKind>? kind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return NoteEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      drawingJson: drawingJson ?? this.drawingJson,
      tags: tags ?? this.tags,
      kind: kind ?? this.kind,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (drawingJson.present) {
      map['drawing_json'] = Variable<String>(drawingJson.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $NoteEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('drawingJson: $drawingJson, ')
          ..write('tags: $tags, ')
          ..write('kind: $kind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskEntriesTable extends TaskEntries
    with TableInfo<$TaskEntriesTable, TaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TaskStatus.todo.name),
      ).withConverter<TaskStatus>($TaskEntriesTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<TaskPriority, String> priority =
      GeneratedColumn<String>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TaskPriority.medium.name),
      ).withConverter<TaskPriority>($TaskEntriesTable.$converterpriority);
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<int> noteId = GeneratedColumn<int>(
    'note_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES note_entries (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    status,
    priority,
    dueDate,
    noteId,
    tags,
    createdAt,
    updatedAt,
    reminderAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: $TaskEntriesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      priority: $TaskEntriesTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}note_id'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
    );
  }

  @override
  $TaskEntriesTable createAlias(String alias) {
    return $TaskEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<TaskPriority, String, String> $converterpriority =
      const EnumNameConverter<TaskPriority>(TaskPriority.values);
}

class TaskEntry extends DataClass implements Insertable<TaskEntry> {
  final int id;
  final String title;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime dueDate;
  final int? noteId;
  final String tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminderAt;
  const TaskEntry({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.dueDate,
    this.noteId,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.reminderAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['status'] = Variable<String>(
        $TaskEntriesTable.$converterstatus.toSql(status),
      );
    }
    {
      map['priority'] = Variable<String>(
        $TaskEntriesTable.$converterpriority.toSql(priority),
      );
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || noteId != null) {
      map['note_id'] = Variable<int>(noteId);
    }
    map['tags'] = Variable<String>(tags);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    return map;
  }

  TaskEntriesCompanion toCompanion(bool nullToAbsent) {
    return TaskEntriesCompanion(
      id: Value(id),
      title: Value(title),
      status: Value(status),
      priority: Value(priority),
      dueDate: Value(dueDate),
      noteId: noteId == null && nullToAbsent
          ? const Value.absent()
          : Value(noteId),
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
    );
  }

  factory TaskEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      status: $TaskEntriesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      priority: $TaskEntriesTable.$converterpriority.fromJson(
        serializer.fromJson<String>(json['priority']),
      ),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      noteId: serializer.fromJson<int?>(json['noteId']),
      tags: serializer.fromJson<String>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(
        $TaskEntriesTable.$converterstatus.toJson(status),
      ),
      'priority': serializer.toJson<String>(
        $TaskEntriesTable.$converterpriority.toJson(priority),
      ),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'noteId': serializer.toJson<int?>(noteId),
      'tags': serializer.toJson<String>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
    };
  }

  TaskEntry copyWith({
    int? id,
    String? title,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    Value<int?> noteId = const Value.absent(),
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> reminderAt = const Value.absent(),
  }) => TaskEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    dueDate: dueDate ?? this.dueDate,
    noteId: noteId.present ? noteId.value : this.noteId,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
  );
  TaskEntry copyWithCompanion(TaskEntriesCompanion data) {
    return TaskEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('noteId: $noteId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminderAt: $reminderAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    status,
    priority,
    dueDate,
    noteId,
    tags,
    createdAt,
    updatedAt,
    reminderAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.noteId == this.noteId &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.reminderAt == this.reminderAt);
}

class TaskEntriesCompanion extends UpdateCompanion<TaskEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<TaskStatus> status;
  final Value<TaskPriority> priority;
  final Value<DateTime> dueDate;
  final Value<int?> noteId;
  final Value<String> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> reminderAt;
  const TaskEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.noteId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminderAt = const Value.absent(),
  });
  TaskEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    required DateTime dueDate,
    this.noteId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminderAt = const Value.absent(),
  }) : title = Value(title),
       dueDate = Value(dueDate);
  static Insertable<TaskEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<DateTime>? dueDate,
    Expression<int>? noteId,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? reminderAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (noteId != null) 'note_id': noteId,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (reminderAt != null) 'reminder_at': reminderAt,
    });
  }

  TaskEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<TaskStatus>? status,
    Value<TaskPriority>? priority,
    Value<DateTime>? dueDate,
    Value<int?>? noteId,
    Value<String>? tags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? reminderAt,
  }) {
    return TaskEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      noteId: noteId ?? this.noteId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderAt: reminderAt ?? this.reminderAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TaskEntriesTable.$converterstatus.toSql(status.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $TaskEntriesTable.$converterpriority.toSql(priority.value),
      );
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<int>(noteId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('noteId: $noteId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminderAt: $reminderAt')
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
  late final $NoteEntriesTable noteEntries = $NoteEntriesTable(this);
  late final $TaskEntriesTable taskEntries = $TaskEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    greetingEntries,
    noteEntries,
    taskEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'note_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_entries', kind: UpdateKind.update)],
    ),
  ]);
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
typedef $$NoteEntriesTableCreateCompanionBuilder =
    NoteEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> content,
      Value<String?> drawingJson,
      Value<String> tags,
      Value<NoteKind> kind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$NoteEntriesTableUpdateCompanionBuilder =
    NoteEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> content,
      Value<String?> drawingJson,
      Value<String> tags,
      Value<NoteKind> kind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$NoteEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $NoteEntriesTable, NoteEntry> {
  $$NoteEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskEntriesTable, List<TaskEntry>>
  _taskEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntries,
    aliasName: $_aliasNameGenerator(db.noteEntries.id, db.taskEntries.noteId),
  );

  $$TaskEntriesTableProcessedTableManager get taskEntriesRefs {
    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NoteEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NoteEntriesTable> {
  $$NoteEntriesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drawingJson => $composableBuilder(
    column: $table.drawingJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NoteKind, NoteKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskEntriesRefs(
    Expression<bool> Function($$TaskEntriesTableFilterComposer f) f,
  ) {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NoteEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteEntriesTable> {
  $$NoteEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drawingJson => $composableBuilder(
    column: $table.drawingJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteEntriesTable> {
  $$NoteEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get drawingJson => $composableBuilder(
    column: $table.drawingJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NoteKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> taskEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NoteEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteEntriesTable,
          NoteEntry,
          $$NoteEntriesTableFilterComposer,
          $$NoteEntriesTableOrderingComposer,
          $$NoteEntriesTableAnnotationComposer,
          $$NoteEntriesTableCreateCompanionBuilder,
          $$NoteEntriesTableUpdateCompanionBuilder,
          (NoteEntry, $$NoteEntriesTableReferences),
          NoteEntry,
          PrefetchHooks Function({bool taskEntriesRefs})
        > {
  $$NoteEntriesTableTableManager(_$AppDatabase db, $NoteEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> drawingJson = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<NoteKind> kind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NoteEntriesCompanion(
                id: id,
                title: title,
                content: content,
                drawingJson: drawingJson,
                tags: tags,
                kind: kind,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> drawingJson = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<NoteKind> kind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NoteEntriesCompanion.insert(
                id: id,
                title: title,
                content: content,
                drawingJson: drawingJson,
                tags: tags,
                kind: kind,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NoteEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskEntriesRefs) db.taskEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEntriesRefs)
                    await $_getPrefetchedData<
                      NoteEntry,
                      $NoteEntriesTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$NoteEntriesTableReferences
                          ._taskEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NoteEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).taskEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.noteId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NoteEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteEntriesTable,
      NoteEntry,
      $$NoteEntriesTableFilterComposer,
      $$NoteEntriesTableOrderingComposer,
      $$NoteEntriesTableAnnotationComposer,
      $$NoteEntriesTableCreateCompanionBuilder,
      $$NoteEntriesTableUpdateCompanionBuilder,
      (NoteEntry, $$NoteEntriesTableReferences),
      NoteEntry,
      PrefetchHooks Function({bool taskEntriesRefs})
    >;
typedef $$TaskEntriesTableCreateCompanionBuilder =
    TaskEntriesCompanion Function({
      Value<int> id,
      required String title,
      Value<TaskStatus> status,
      Value<TaskPriority> priority,
      required DateTime dueDate,
      Value<int?> noteId,
      Value<String> tags,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> reminderAt,
    });
typedef $$TaskEntriesTableUpdateCompanionBuilder =
    TaskEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<TaskStatus> status,
      Value<TaskPriority> priority,
      Value<DateTime> dueDate,
      Value<int?> noteId,
      Value<String> tags,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> reminderAt,
    });

final class $$TaskEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskEntriesTable, TaskEntry> {
  $$TaskEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NoteEntriesTable _noteIdTable(_$AppDatabase db) =>
      db.noteEntries.createAlias(
        $_aliasNameGenerator(db.taskEntries.noteId, db.noteEntries.id),
      );

  $$NoteEntriesTableProcessedTableManager? get noteId {
    final $_column = $_itemColumn<int>('note_id');
    if ($_column == null) return null;
    final manager = $$NoteEntriesTableTableManager(
      $_db,
      $_db.noteEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TaskPriority, TaskPriority, String>
  get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NoteEntriesTableFilterComposer get noteId {
    final $$NoteEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.noteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteEntriesTableFilterComposer(
            $db: $db,
            $table: $db.noteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NoteEntriesTableOrderingComposer get noteId {
    final $$NoteEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.noteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.noteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskPriority, String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  $$NoteEntriesTableAnnotationComposer get noteId {
    final $$NoteEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.noteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.noteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskEntriesTable,
          TaskEntry,
          $$TaskEntriesTableFilterComposer,
          $$TaskEntriesTableOrderingComposer,
          $$TaskEntriesTableAnnotationComposer,
          $$TaskEntriesTableCreateCompanionBuilder,
          $$TaskEntriesTableUpdateCompanionBuilder,
          (TaskEntry, $$TaskEntriesTableReferences),
          TaskEntry,
          PrefetchHooks Function({bool noteId})
        > {
  $$TaskEntriesTableTableManager(_$AppDatabase db, $TaskEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<TaskPriority> priority = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int?> noteId = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
              }) => TaskEntriesCompanion(
                id: id,
                title: title,
                status: status,
                priority: priority,
                dueDate: dueDate,
                noteId: noteId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                reminderAt: reminderAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<TaskStatus> status = const Value.absent(),
                Value<TaskPriority> priority = const Value.absent(),
                required DateTime dueDate,
                Value<int?> noteId = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
              }) => TaskEntriesCompanion.insert(
                id: id,
                title: title,
                status: status,
                priority: priority,
                dueDate: dueDate,
                noteId: noteId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                reminderAt: reminderAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$TaskEntriesTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$TaskEntriesTableReferences
                                    ._noteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskEntriesTable,
      TaskEntry,
      $$TaskEntriesTableFilterComposer,
      $$TaskEntriesTableOrderingComposer,
      $$TaskEntriesTableAnnotationComposer,
      $$TaskEntriesTableCreateCompanionBuilder,
      $$TaskEntriesTableUpdateCompanionBuilder,
      (TaskEntry, $$TaskEntriesTableReferences),
      TaskEntry,
      PrefetchHooks Function({bool noteId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GreetingEntriesTableTableManager get greetingEntries =>
      $$GreetingEntriesTableTableManager(_db, _db.greetingEntries);
  $$NoteEntriesTableTableManager get noteEntries =>
      $$NoteEntriesTableTableManager(_db, _db.noteEntries);
  $$TaskEntriesTableTableManager get taskEntries =>
      $$TaskEntriesTableTableManager(_db, _db.taskEntries);
}
