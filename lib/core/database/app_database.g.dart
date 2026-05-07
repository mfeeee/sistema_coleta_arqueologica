// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ColetasTable extends Coletas with TableInfo<$ColetasTable, Coleta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColetasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataColetaMeta = const VerificationMeta(
    'dataColeta',
  );
  @override
  late final GeneratedColumn<DateTime> dataColeta = GeneratedColumn<DateTime>(
    'data_coleta',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StatusColeta, String>
  statusSincronizacao = GeneratedColumn<String>(
    'status_sincronizacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => StatusColeta.pendente.name,
  ).withConverter<StatusColeta>($ColetasTable.$converterstatusSincronizacao);
  static const VerificationMeta _nomeBemMeta = const VerificationMeta(
    'nomeBem',
  );
  @override
  late final GeneratedColumn<String> nomeBem = GeneratedColumn<String>(
    'nome_bem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => '',
  );
  static const VerificationMeta _naturezaMeta = const VerificationMeta(
    'natureza',
  );
  @override
  late final GeneratedColumn<String> natureza = GeneratedColumn<String>(
    'natureza',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ufMeta = const VerificationMeta('uf');
  @override
  late final GeneratedColumn<String> uf = GeneratedColumn<String>(
    'uf',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    clientDefault: () => 0.0,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    clientDefault: () => 0.0,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> artefatos =
      GeneratedColumn<String>(
        'artefatos',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => '[]',
      ).withConverter<List<String>>($ColetasTable.$converterartefatos);
  static const VerificationMeta _versaoMeta = const VerificationMeta('versao');
  @override
  late final GeneratedColumn<int> versao = GeneratedColumn<int>(
    'versao',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    clientDefault: () => 1,
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
    clientDefault: () => DateTime.now(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  dadosColetados = GeneratedColumn<String>(
    'dados_coletados',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($ColetasTable.$converterdadosColetados);
  static const VerificationMeta _deletadoEmMeta = const VerificationMeta(
    'deletadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> deletadoEm = GeneratedColumn<DateTime>(
    'deletado_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    usuarioId,
    dataColeta,
    statusSincronizacao,
    nomeBem,
    natureza,
    tipo,
    uf,
    latitude,
    longitude,
    artefatos,
    versao,
    updatedAt,
    dadosColetados,
    deletadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coletas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Coleta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('data_coleta')) {
      context.handle(
        _dataColetaMeta,
        dataColeta.isAcceptableOrUnknown(data['data_coleta']!, _dataColetaMeta),
      );
    }
    if (data.containsKey('nome_bem')) {
      context.handle(
        _nomeBemMeta,
        nomeBem.isAcceptableOrUnknown(data['nome_bem']!, _nomeBemMeta),
      );
    }
    if (data.containsKey('natureza')) {
      context.handle(
        _naturezaMeta,
        natureza.isAcceptableOrUnknown(data['natureza']!, _naturezaMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('uf')) {
      context.handle(_ufMeta, uf.isAcceptableOrUnknown(data['uf']!, _ufMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('versao')) {
      context.handle(
        _versaoMeta,
        versao.isAcceptableOrUnknown(data['versao']!, _versaoMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deletado_em')) {
      context.handle(
        _deletadoEmMeta,
        deletadoEm.isAcceptableOrUnknown(data['deletado_em']!, _deletadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  Coleta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Coleta(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      dataColeta: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_coleta'],
      )!,
      statusSincronizacao: $ColetasTable.$converterstatusSincronizacao.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status_sincronizacao'],
        )!,
      ),
      nomeBem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_bem'],
      )!,
      natureza: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}natureza'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      ),
      uf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uf'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      artefatos: $ColetasTable.$converterartefatos.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}artefatos'],
        )!,
      ),
      versao: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}versao'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dadosColetados: $ColetasTable.$converterdadosColetados.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dados_coletados'],
        )!,
      ),
      deletadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deletado_em'],
      ),
    );
  }

  @override
  $ColetasTable createAlias(String alias) {
    return $ColetasTable(attachedDatabase, alias);
  }

  static TypeConverter<StatusColeta, String> $converterstatusSincronizacao =
      const StatusColetaConverter();
  static TypeConverter<List<String>, String> $converterartefatos =
      const StringListConverter();
  static TypeConverter<Map<String, Object?>, String> $converterdadosColetados =
      const JsonMapConverter();
}

class Coleta extends DataClass implements Insertable<Coleta> {
  final String uuid;
  final String usuarioId;
  final DateTime dataColeta;
  final StatusColeta statusSincronizacao;
  final String nomeBem;
  final String? natureza;
  final String? tipo;
  final String? uf;
  final double latitude;
  final double longitude;
  final List<String> artefatos;
  final int versao;
  final DateTime updatedAt;
  final Map<String, Object?> dadosColetados;
  final DateTime? deletadoEm;
  const Coleta({
    required this.uuid,
    required this.usuarioId,
    required this.dataColeta,
    required this.statusSincronizacao,
    required this.nomeBem,
    this.natureza,
    this.tipo,
    this.uf,
    required this.latitude,
    required this.longitude,
    required this.artefatos,
    required this.versao,
    required this.updatedAt,
    required this.dadosColetados,
    this.deletadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['data_coleta'] = Variable<DateTime>(dataColeta);
    {
      map['status_sincronizacao'] = Variable<String>(
        $ColetasTable.$converterstatusSincronizacao.toSql(statusSincronizacao),
      );
    }
    map['nome_bem'] = Variable<String>(nomeBem);
    if (!nullToAbsent || natureza != null) {
      map['natureza'] = Variable<String>(natureza);
    }
    if (!nullToAbsent || tipo != null) {
      map['tipo'] = Variable<String>(tipo);
    }
    if (!nullToAbsent || uf != null) {
      map['uf'] = Variable<String>(uf);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    {
      map['artefatos'] = Variable<String>(
        $ColetasTable.$converterartefatos.toSql(artefatos),
      );
    }
    map['versao'] = Variable<int>(versao);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['dados_coletados'] = Variable<String>(
        $ColetasTable.$converterdadosColetados.toSql(dadosColetados),
      );
    }
    if (!nullToAbsent || deletadoEm != null) {
      map['deletado_em'] = Variable<DateTime>(deletadoEm);
    }
    return map;
  }

  ColetasCompanion toCompanion(bool nullToAbsent) {
    return ColetasCompanion(
      uuid: Value(uuid),
      usuarioId: Value(usuarioId),
      dataColeta: Value(dataColeta),
      statusSincronizacao: Value(statusSincronizacao),
      nomeBem: Value(nomeBem),
      natureza: natureza == null && nullToAbsent
          ? const Value.absent()
          : Value(natureza),
      tipo: tipo == null && nullToAbsent ? const Value.absent() : Value(tipo),
      uf: uf == null && nullToAbsent ? const Value.absent() : Value(uf),
      latitude: Value(latitude),
      longitude: Value(longitude),
      artefatos: Value(artefatos),
      versao: Value(versao),
      updatedAt: Value(updatedAt),
      dadosColetados: Value(dadosColetados),
      deletadoEm: deletadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(deletadoEm),
    );
  }

  factory Coleta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Coleta(
      uuid: serializer.fromJson<String>(json['uuid']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      dataColeta: serializer.fromJson<DateTime>(json['dataColeta']),
      statusSincronizacao: serializer.fromJson<StatusColeta>(
        json['statusSincronizacao'],
      ),
      nomeBem: serializer.fromJson<String>(json['nomeBem']),
      natureza: serializer.fromJson<String?>(json['natureza']),
      tipo: serializer.fromJson<String?>(json['tipo']),
      uf: serializer.fromJson<String?>(json['uf']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      artefatos: serializer.fromJson<List<String>>(json['artefatos']),
      versao: serializer.fromJson<int>(json['versao']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dadosColetados: serializer.fromJson<Map<String, Object?>>(
        json['dadosColetados'],
      ),
      deletadoEm: serializer.fromJson<DateTime?>(json['deletadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'dataColeta': serializer.toJson<DateTime>(dataColeta),
      'statusSincronizacao': serializer.toJson<StatusColeta>(
        statusSincronizacao,
      ),
      'nomeBem': serializer.toJson<String>(nomeBem),
      'natureza': serializer.toJson<String?>(natureza),
      'tipo': serializer.toJson<String?>(tipo),
      'uf': serializer.toJson<String?>(uf),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'artefatos': serializer.toJson<List<String>>(artefatos),
      'versao': serializer.toJson<int>(versao),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dadosColetados': serializer.toJson<Map<String, Object?>>(dadosColetados),
      'deletadoEm': serializer.toJson<DateTime?>(deletadoEm),
    };
  }

  Coleta copyWith({
    String? uuid,
    String? usuarioId,
    DateTime? dataColeta,
    StatusColeta? statusSincronizacao,
    String? nomeBem,
    Value<String?> natureza = const Value.absent(),
    Value<String?> tipo = const Value.absent(),
    Value<String?> uf = const Value.absent(),
    double? latitude,
    double? longitude,
    List<String>? artefatos,
    int? versao,
    DateTime? updatedAt,
    Map<String, Object?>? dadosColetados,
    Value<DateTime?> deletadoEm = const Value.absent(),
  }) => Coleta(
    uuid: uuid ?? this.uuid,
    usuarioId: usuarioId ?? this.usuarioId,
    dataColeta: dataColeta ?? this.dataColeta,
    statusSincronizacao: statusSincronizacao ?? this.statusSincronizacao,
    nomeBem: nomeBem ?? this.nomeBem,
    natureza: natureza.present ? natureza.value : this.natureza,
    tipo: tipo.present ? tipo.value : this.tipo,
    uf: uf.present ? uf.value : this.uf,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    artefatos: artefatos ?? this.artefatos,
    versao: versao ?? this.versao,
    updatedAt: updatedAt ?? this.updatedAt,
    dadosColetados: dadosColetados ?? this.dadosColetados,
    deletadoEm: deletadoEm.present ? deletadoEm.value : this.deletadoEm,
  );
  Coleta copyWithCompanion(ColetasCompanion data) {
    return Coleta(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      dataColeta: data.dataColeta.present
          ? data.dataColeta.value
          : this.dataColeta,
      statusSincronizacao: data.statusSincronizacao.present
          ? data.statusSincronizacao.value
          : this.statusSincronizacao,
      nomeBem: data.nomeBem.present ? data.nomeBem.value : this.nomeBem,
      natureza: data.natureza.present ? data.natureza.value : this.natureza,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      uf: data.uf.present ? data.uf.value : this.uf,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      artefatos: data.artefatos.present ? data.artefatos.value : this.artefatos,
      versao: data.versao.present ? data.versao.value : this.versao,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dadosColetados: data.dadosColetados.present
          ? data.dadosColetados.value
          : this.dadosColetados,
      deletadoEm: data.deletadoEm.present
          ? data.deletadoEm.value
          : this.deletadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Coleta(')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('dataColeta: $dataColeta, ')
          ..write('statusSincronizacao: $statusSincronizacao, ')
          ..write('nomeBem: $nomeBem, ')
          ..write('natureza: $natureza, ')
          ..write('tipo: $tipo, ')
          ..write('uf: $uf, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('artefatos: $artefatos, ')
          ..write('versao: $versao, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dadosColetados: $dadosColetados, ')
          ..write('deletadoEm: $deletadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    usuarioId,
    dataColeta,
    statusSincronizacao,
    nomeBem,
    natureza,
    tipo,
    uf,
    latitude,
    longitude,
    artefatos,
    versao,
    updatedAt,
    dadosColetados,
    deletadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coleta &&
          other.uuid == this.uuid &&
          other.usuarioId == this.usuarioId &&
          other.dataColeta == this.dataColeta &&
          other.statusSincronizacao == this.statusSincronizacao &&
          other.nomeBem == this.nomeBem &&
          other.natureza == this.natureza &&
          other.tipo == this.tipo &&
          other.uf == this.uf &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.artefatos == this.artefatos &&
          other.versao == this.versao &&
          other.updatedAt == this.updatedAt &&
          other.dadosColetados == this.dadosColetados &&
          other.deletadoEm == this.deletadoEm);
}

class ColetasCompanion extends UpdateCompanion<Coleta> {
  final Value<String> uuid;
  final Value<String> usuarioId;
  final Value<DateTime> dataColeta;
  final Value<StatusColeta> statusSincronizacao;
  final Value<String> nomeBem;
  final Value<String?> natureza;
  final Value<String?> tipo;
  final Value<String?> uf;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<List<String>> artefatos;
  final Value<int> versao;
  final Value<DateTime> updatedAt;
  final Value<Map<String, Object?>> dadosColetados;
  final Value<DateTime?> deletadoEm;
  final Value<int> rowid;
  const ColetasCompanion({
    this.uuid = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.dataColeta = const Value.absent(),
    this.statusSincronizacao = const Value.absent(),
    this.nomeBem = const Value.absent(),
    this.natureza = const Value.absent(),
    this.tipo = const Value.absent(),
    this.uf = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.artefatos = const Value.absent(),
    this.versao = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dadosColetados = const Value.absent(),
    this.deletadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ColetasCompanion.insert({
    required String uuid,
    required String usuarioId,
    this.dataColeta = const Value.absent(),
    this.statusSincronizacao = const Value.absent(),
    this.nomeBem = const Value.absent(),
    this.natureza = const Value.absent(),
    this.tipo = const Value.absent(),
    this.uf = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.artefatos = const Value.absent(),
    this.versao = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required Map<String, Object?> dadosColetados,
    this.deletadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       usuarioId = Value(usuarioId),
       dadosColetados = Value(dadosColetados);
  static Insertable<Coleta> custom({
    Expression<String>? uuid,
    Expression<String>? usuarioId,
    Expression<DateTime>? dataColeta,
    Expression<String>? statusSincronizacao,
    Expression<String>? nomeBem,
    Expression<String>? natureza,
    Expression<String>? tipo,
    Expression<String>? uf,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? artefatos,
    Expression<int>? versao,
    Expression<DateTime>? updatedAt,
    Expression<String>? dadosColetados,
    Expression<DateTime>? deletadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (dataColeta != null) 'data_coleta': dataColeta,
      if (statusSincronizacao != null)
        'status_sincronizacao': statusSincronizacao,
      if (nomeBem != null) 'nome_bem': nomeBem,
      if (natureza != null) 'natureza': natureza,
      if (tipo != null) 'tipo': tipo,
      if (uf != null) 'uf': uf,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (artefatos != null) 'artefatos': artefatos,
      if (versao != null) 'versao': versao,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dadosColetados != null) 'dados_coletados': dadosColetados,
      if (deletadoEm != null) 'deletado_em': deletadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ColetasCompanion copyWith({
    Value<String>? uuid,
    Value<String>? usuarioId,
    Value<DateTime>? dataColeta,
    Value<StatusColeta>? statusSincronizacao,
    Value<String>? nomeBem,
    Value<String?>? natureza,
    Value<String?>? tipo,
    Value<String?>? uf,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<List<String>>? artefatos,
    Value<int>? versao,
    Value<DateTime>? updatedAt,
    Value<Map<String, Object?>>? dadosColetados,
    Value<DateTime?>? deletadoEm,
    Value<int>? rowid,
  }) {
    return ColetasCompanion(
      uuid: uuid ?? this.uuid,
      usuarioId: usuarioId ?? this.usuarioId,
      dataColeta: dataColeta ?? this.dataColeta,
      statusSincronizacao: statusSincronizacao ?? this.statusSincronizacao,
      nomeBem: nomeBem ?? this.nomeBem,
      natureza: natureza ?? this.natureza,
      tipo: tipo ?? this.tipo,
      uf: uf ?? this.uf,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      artefatos: artefatos ?? this.artefatos,
      versao: versao ?? this.versao,
      updatedAt: updatedAt ?? this.updatedAt,
      dadosColetados: dadosColetados ?? this.dadosColetados,
      deletadoEm: deletadoEm ?? this.deletadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (dataColeta.present) {
      map['data_coleta'] = Variable<DateTime>(dataColeta.value);
    }
    if (statusSincronizacao.present) {
      map['status_sincronizacao'] = Variable<String>(
        $ColetasTable.$converterstatusSincronizacao.toSql(
          statusSincronizacao.value,
        ),
      );
    }
    if (nomeBem.present) {
      map['nome_bem'] = Variable<String>(nomeBem.value);
    }
    if (natureza.present) {
      map['natureza'] = Variable<String>(natureza.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (uf.present) {
      map['uf'] = Variable<String>(uf.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (artefatos.present) {
      map['artefatos'] = Variable<String>(
        $ColetasTable.$converterartefatos.toSql(artefatos.value),
      );
    }
    if (versao.present) {
      map['versao'] = Variable<int>(versao.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dadosColetados.present) {
      map['dados_coletados'] = Variable<String>(
        $ColetasTable.$converterdadosColetados.toSql(dadosColetados.value),
      );
    }
    if (deletadoEm.present) {
      map['deletado_em'] = Variable<DateTime>(deletadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColetasCompanion(')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('dataColeta: $dataColeta, ')
          ..write('statusSincronizacao: $statusSincronizacao, ')
          ..write('nomeBem: $nomeBem, ')
          ..write('natureza: $natureza, ')
          ..write('tipo: $tipo, ')
          ..write('uf: $uf, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('artefatos: $artefatos, ')
          ..write('versao: $versao, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dadosColetados: $dadosColetados, ')
          ..write('deletadoEm: $deletadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BensMateriaisTable extends BensMateriais
    with TableInfo<$BensMateriaisTable, BensMateriai> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BensMateriaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coletaIdMeta = const VerificationMeta(
    'coletaId',
  );
  @override
  late final GeneratedColumn<String> coletaId = GeneratedColumn<String>(
    'coleta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES coletas (uuid)',
    ),
  );
  static const VerificationMeta _codigoIphanMeta = const VerificationMeta(
    'codigoIphan',
  );
  @override
  late final GeneratedColumn<String> codigoIphan = GeneratedColumn<String>(
    'codigo_iphan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomeBemMeta = const VerificationMeta(
    'nomeBem',
  );
  @override
  late final GeneratedColumn<String> nomeBem = GeneratedColumn<String>(
    'nome_bem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomesPopularesMeta = const VerificationMeta(
    'nomesPopulares',
  );
  @override
  late final GeneratedColumn<String> nomesPopulares = GeneratedColumn<String>(
    'nomes_populares',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _naturezaMeta = const VerificationMeta(
    'natureza',
  );
  @override
  late final GeneratedColumn<String> natureza = GeneratedColumn<String>(
    'natureza',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meiosAcessoMeta = const VerificationMeta(
    'meiosAcesso',
  );
  @override
  late final GeneratedColumn<String> meiosAcesso = GeneratedColumn<String>(
    'meios_acesso',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> artefatos =
      GeneratedColumn<String>(
        'artefatos',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => '[]',
      ).withConverter<List<String>>($BensMateriaisTable.$converterartefatos);
  static const VerificationMeta _publicadoMeta = const VerificationMeta(
    'publicado',
  );
  @override
  late final GeneratedColumn<bool> publicado = GeneratedColumn<bool>(
    'publicado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("publicado" IN (0, 1))',
    ),
    clientDefault: () => false,
  );
  static const VerificationMeta _ufMeta = const VerificationMeta('uf');
  @override
  late final GeneratedColumn<String> uf = GeneratedColumn<String>(
    'uf',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _municipioMeta = const VerificationMeta(
    'municipio',
  );
  @override
  late final GeneratedColumn<String> municipio = GeneratedColumn<String>(
    'municipio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cepMeta = const VerificationMeta('cep');
  @override
  late final GeneratedColumn<String> cep = GeneratedColumn<String>(
    'cep',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enderecoMeta = const VerificationMeta(
    'endereco',
  );
  @override
  late final GeneratedColumn<String> endereco = GeneratedColumn<String>(
    'endereco',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geojsonMeta = const VerificationMeta(
    'geojson',
  );
  @override
  late final GeneratedColumn<String> geojson = GeneratedColumn<String>(
    'geojson',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anoRegistroMeta = const VerificationMeta(
    'anoRegistro',
  );
  @override
  late final GeneratedColumn<int> anoRegistro = GeneratedColumn<int>(
    'ano_registro',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descricaoAtualizacaoMeta =
      const VerificationMeta('descricaoAtualizacao');
  @override
  late final GeneratedColumn<String> descricaoAtualizacao =
      GeneratedColumn<String>(
        'descricao_atualizacao',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletadoEmMeta = const VerificationMeta(
    'deletadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> deletadoEm = GeneratedColumn<DateTime>(
    'deletado_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    coletaId,
    codigoIphan,
    nomeBem,
    nomesPopulares,
    natureza,
    tipo,
    meiosAcesso,
    artefatos,
    publicado,
    uf,
    municipio,
    cep,
    endereco,
    latitude,
    longitude,
    geojson,
    anoRegistro,
    descricaoAtualizacao,
    criadoEm,
    atualizadoEm,
    deletadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bens_materiais';
  @override
  VerificationContext validateIntegrity(
    Insertable<BensMateriai> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('coleta_id')) {
      context.handle(
        _coletaIdMeta,
        coletaId.isAcceptableOrUnknown(data['coleta_id']!, _coletaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coletaIdMeta);
    }
    if (data.containsKey('codigo_iphan')) {
      context.handle(
        _codigoIphanMeta,
        codigoIphan.isAcceptableOrUnknown(
          data['codigo_iphan']!,
          _codigoIphanMeta,
        ),
      );
    }
    if (data.containsKey('nome_bem')) {
      context.handle(
        _nomeBemMeta,
        nomeBem.isAcceptableOrUnknown(data['nome_bem']!, _nomeBemMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeBemMeta);
    }
    if (data.containsKey('nomes_populares')) {
      context.handle(
        _nomesPopularesMeta,
        nomesPopulares.isAcceptableOrUnknown(
          data['nomes_populares']!,
          _nomesPopularesMeta,
        ),
      );
    }
    if (data.containsKey('natureza')) {
      context.handle(
        _naturezaMeta,
        natureza.isAcceptableOrUnknown(data['natureza']!, _naturezaMeta),
      );
    } else if (isInserting) {
      context.missing(_naturezaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('meios_acesso')) {
      context.handle(
        _meiosAcessoMeta,
        meiosAcesso.isAcceptableOrUnknown(
          data['meios_acesso']!,
          _meiosAcessoMeta,
        ),
      );
    }
    if (data.containsKey('publicado')) {
      context.handle(
        _publicadoMeta,
        publicado.isAcceptableOrUnknown(data['publicado']!, _publicadoMeta),
      );
    }
    if (data.containsKey('uf')) {
      context.handle(_ufMeta, uf.isAcceptableOrUnknown(data['uf']!, _ufMeta));
    }
    if (data.containsKey('municipio')) {
      context.handle(
        _municipioMeta,
        municipio.isAcceptableOrUnknown(data['municipio']!, _municipioMeta),
      );
    }
    if (data.containsKey('cep')) {
      context.handle(
        _cepMeta,
        cep.isAcceptableOrUnknown(data['cep']!, _cepMeta),
      );
    }
    if (data.containsKey('endereco')) {
      context.handle(
        _enderecoMeta,
        endereco.isAcceptableOrUnknown(data['endereco']!, _enderecoMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('geojson')) {
      context.handle(
        _geojsonMeta,
        geojson.isAcceptableOrUnknown(data['geojson']!, _geojsonMeta),
      );
    }
    if (data.containsKey('ano_registro')) {
      context.handle(
        _anoRegistroMeta,
        anoRegistro.isAcceptableOrUnknown(
          data['ano_registro']!,
          _anoRegistroMeta,
        ),
      );
    }
    if (data.containsKey('descricao_atualizacao')) {
      context.handle(
        _descricaoAtualizacaoMeta,
        descricaoAtualizacao.isAcceptableOrUnknown(
          data['descricao_atualizacao']!,
          _descricaoAtualizacaoMeta,
        ),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('deletado_em')) {
      context.handle(
        _deletadoEmMeta,
        deletadoEm.isAcceptableOrUnknown(data['deletado_em']!, _deletadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  BensMateriai map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BensMateriai(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      coletaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coleta_id'],
      )!,
      codigoIphan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_iphan'],
      ),
      nomeBem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_bem'],
      )!,
      nomesPopulares: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nomes_populares'],
      ),
      natureza: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}natureza'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      meiosAcesso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meios_acesso'],
      ),
      artefatos: $BensMateriaisTable.$converterartefatos.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}artefatos'],
        )!,
      ),
      publicado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}publicado'],
      )!,
      uf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uf'],
      ),
      municipio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}municipio'],
      ),
      cep: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cep'],
      ),
      endereco: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endereco'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      geojson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geojson'],
      ),
      anoRegistro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ano_registro'],
      ),
      descricaoAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao_atualizacao'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      deletadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deletado_em'],
      ),
    );
  }

  @override
  $BensMateriaisTable createAlias(String alias) {
    return $BensMateriaisTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterartefatos =
      const StringListConverter();
}

class BensMateriai extends DataClass implements Insertable<BensMateriai> {
  final String uuid;
  final String coletaId;
  final String? codigoIphan;
  final String nomeBem;
  final String? nomesPopulares;
  final String natureza;
  final String tipo;
  final String? meiosAcesso;
  final List<String> artefatos;
  final bool publicado;
  final String? uf;
  final String? municipio;
  final String? cep;
  final String? endereco;
  final double? latitude;
  final double? longitude;
  final String? geojson;
  final int? anoRegistro;
  final String? descricaoAtualizacao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? deletadoEm;
  const BensMateriai({
    required this.uuid,
    required this.coletaId,
    this.codigoIphan,
    required this.nomeBem,
    this.nomesPopulares,
    required this.natureza,
    required this.tipo,
    this.meiosAcesso,
    required this.artefatos,
    required this.publicado,
    this.uf,
    this.municipio,
    this.cep,
    this.endereco,
    this.latitude,
    this.longitude,
    this.geojson,
    this.anoRegistro,
    this.descricaoAtualizacao,
    required this.criadoEm,
    required this.atualizadoEm,
    this.deletadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['coleta_id'] = Variable<String>(coletaId);
    if (!nullToAbsent || codigoIphan != null) {
      map['codigo_iphan'] = Variable<String>(codigoIphan);
    }
    map['nome_bem'] = Variable<String>(nomeBem);
    if (!nullToAbsent || nomesPopulares != null) {
      map['nomes_populares'] = Variable<String>(nomesPopulares);
    }
    map['natureza'] = Variable<String>(natureza);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || meiosAcesso != null) {
      map['meios_acesso'] = Variable<String>(meiosAcesso);
    }
    {
      map['artefatos'] = Variable<String>(
        $BensMateriaisTable.$converterartefatos.toSql(artefatos),
      );
    }
    map['publicado'] = Variable<bool>(publicado);
    if (!nullToAbsent || uf != null) {
      map['uf'] = Variable<String>(uf);
    }
    if (!nullToAbsent || municipio != null) {
      map['municipio'] = Variable<String>(municipio);
    }
    if (!nullToAbsent || cep != null) {
      map['cep'] = Variable<String>(cep);
    }
    if (!nullToAbsent || endereco != null) {
      map['endereco'] = Variable<String>(endereco);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || geojson != null) {
      map['geojson'] = Variable<String>(geojson);
    }
    if (!nullToAbsent || anoRegistro != null) {
      map['ano_registro'] = Variable<int>(anoRegistro);
    }
    if (!nullToAbsent || descricaoAtualizacao != null) {
      map['descricao_atualizacao'] = Variable<String>(descricaoAtualizacao);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || deletadoEm != null) {
      map['deletado_em'] = Variable<DateTime>(deletadoEm);
    }
    return map;
  }

  BensMateriaisCompanion toCompanion(bool nullToAbsent) {
    return BensMateriaisCompanion(
      uuid: Value(uuid),
      coletaId: Value(coletaId),
      codigoIphan: codigoIphan == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoIphan),
      nomeBem: Value(nomeBem),
      nomesPopulares: nomesPopulares == null && nullToAbsent
          ? const Value.absent()
          : Value(nomesPopulares),
      natureza: Value(natureza),
      tipo: Value(tipo),
      meiosAcesso: meiosAcesso == null && nullToAbsent
          ? const Value.absent()
          : Value(meiosAcesso),
      artefatos: Value(artefatos),
      publicado: Value(publicado),
      uf: uf == null && nullToAbsent ? const Value.absent() : Value(uf),
      municipio: municipio == null && nullToAbsent
          ? const Value.absent()
          : Value(municipio),
      cep: cep == null && nullToAbsent ? const Value.absent() : Value(cep),
      endereco: endereco == null && nullToAbsent
          ? const Value.absent()
          : Value(endereco),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      geojson: geojson == null && nullToAbsent
          ? const Value.absent()
          : Value(geojson),
      anoRegistro: anoRegistro == null && nullToAbsent
          ? const Value.absent()
          : Value(anoRegistro),
      descricaoAtualizacao: descricaoAtualizacao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricaoAtualizacao),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
      deletadoEm: deletadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(deletadoEm),
    );
  }

  factory BensMateriai.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BensMateriai(
      uuid: serializer.fromJson<String>(json['uuid']),
      coletaId: serializer.fromJson<String>(json['coletaId']),
      codigoIphan: serializer.fromJson<String?>(json['codigoIphan']),
      nomeBem: serializer.fromJson<String>(json['nomeBem']),
      nomesPopulares: serializer.fromJson<String?>(json['nomesPopulares']),
      natureza: serializer.fromJson<String>(json['natureza']),
      tipo: serializer.fromJson<String>(json['tipo']),
      meiosAcesso: serializer.fromJson<String?>(json['meiosAcesso']),
      artefatos: serializer.fromJson<List<String>>(json['artefatos']),
      publicado: serializer.fromJson<bool>(json['publicado']),
      uf: serializer.fromJson<String?>(json['uf']),
      municipio: serializer.fromJson<String?>(json['municipio']),
      cep: serializer.fromJson<String?>(json['cep']),
      endereco: serializer.fromJson<String?>(json['endereco']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      geojson: serializer.fromJson<String?>(json['geojson']),
      anoRegistro: serializer.fromJson<int?>(json['anoRegistro']),
      descricaoAtualizacao: serializer.fromJson<String?>(
        json['descricaoAtualizacao'],
      ),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      deletadoEm: serializer.fromJson<DateTime?>(json['deletadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'coletaId': serializer.toJson<String>(coletaId),
      'codigoIphan': serializer.toJson<String?>(codigoIphan),
      'nomeBem': serializer.toJson<String>(nomeBem),
      'nomesPopulares': serializer.toJson<String?>(nomesPopulares),
      'natureza': serializer.toJson<String>(natureza),
      'tipo': serializer.toJson<String>(tipo),
      'meiosAcesso': serializer.toJson<String?>(meiosAcesso),
      'artefatos': serializer.toJson<List<String>>(artefatos),
      'publicado': serializer.toJson<bool>(publicado),
      'uf': serializer.toJson<String?>(uf),
      'municipio': serializer.toJson<String?>(municipio),
      'cep': serializer.toJson<String?>(cep),
      'endereco': serializer.toJson<String?>(endereco),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'geojson': serializer.toJson<String?>(geojson),
      'anoRegistro': serializer.toJson<int?>(anoRegistro),
      'descricaoAtualizacao': serializer.toJson<String?>(descricaoAtualizacao),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'deletadoEm': serializer.toJson<DateTime?>(deletadoEm),
    };
  }

  BensMateriai copyWith({
    String? uuid,
    String? coletaId,
    Value<String?> codigoIphan = const Value.absent(),
    String? nomeBem,
    Value<String?> nomesPopulares = const Value.absent(),
    String? natureza,
    String? tipo,
    Value<String?> meiosAcesso = const Value.absent(),
    List<String>? artefatos,
    bool? publicado,
    Value<String?> uf = const Value.absent(),
    Value<String?> municipio = const Value.absent(),
    Value<String?> cep = const Value.absent(),
    Value<String?> endereco = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> geojson = const Value.absent(),
    Value<int?> anoRegistro = const Value.absent(),
    Value<String?> descricaoAtualizacao = const Value.absent(),
    DateTime? criadoEm,
    DateTime? atualizadoEm,
    Value<DateTime?> deletadoEm = const Value.absent(),
  }) => BensMateriai(
    uuid: uuid ?? this.uuid,
    coletaId: coletaId ?? this.coletaId,
    codigoIphan: codigoIphan.present ? codigoIphan.value : this.codigoIphan,
    nomeBem: nomeBem ?? this.nomeBem,
    nomesPopulares: nomesPopulares.present
        ? nomesPopulares.value
        : this.nomesPopulares,
    natureza: natureza ?? this.natureza,
    tipo: tipo ?? this.tipo,
    meiosAcesso: meiosAcesso.present ? meiosAcesso.value : this.meiosAcesso,
    artefatos: artefatos ?? this.artefatos,
    publicado: publicado ?? this.publicado,
    uf: uf.present ? uf.value : this.uf,
    municipio: municipio.present ? municipio.value : this.municipio,
    cep: cep.present ? cep.value : this.cep,
    endereco: endereco.present ? endereco.value : this.endereco,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    geojson: geojson.present ? geojson.value : this.geojson,
    anoRegistro: anoRegistro.present ? anoRegistro.value : this.anoRegistro,
    descricaoAtualizacao: descricaoAtualizacao.present
        ? descricaoAtualizacao.value
        : this.descricaoAtualizacao,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    deletadoEm: deletadoEm.present ? deletadoEm.value : this.deletadoEm,
  );
  BensMateriai copyWithCompanion(BensMateriaisCompanion data) {
    return BensMateriai(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      coletaId: data.coletaId.present ? data.coletaId.value : this.coletaId,
      codigoIphan: data.codigoIphan.present
          ? data.codigoIphan.value
          : this.codigoIphan,
      nomeBem: data.nomeBem.present ? data.nomeBem.value : this.nomeBem,
      nomesPopulares: data.nomesPopulares.present
          ? data.nomesPopulares.value
          : this.nomesPopulares,
      natureza: data.natureza.present ? data.natureza.value : this.natureza,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      meiosAcesso: data.meiosAcesso.present
          ? data.meiosAcesso.value
          : this.meiosAcesso,
      artefatos: data.artefatos.present ? data.artefatos.value : this.artefatos,
      publicado: data.publicado.present ? data.publicado.value : this.publicado,
      uf: data.uf.present ? data.uf.value : this.uf,
      municipio: data.municipio.present ? data.municipio.value : this.municipio,
      cep: data.cep.present ? data.cep.value : this.cep,
      endereco: data.endereco.present ? data.endereco.value : this.endereco,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      geojson: data.geojson.present ? data.geojson.value : this.geojson,
      anoRegistro: data.anoRegistro.present
          ? data.anoRegistro.value
          : this.anoRegistro,
      descricaoAtualizacao: data.descricaoAtualizacao.present
          ? data.descricaoAtualizacao.value
          : this.descricaoAtualizacao,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      deletadoEm: data.deletadoEm.present
          ? data.deletadoEm.value
          : this.deletadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BensMateriai(')
          ..write('uuid: $uuid, ')
          ..write('coletaId: $coletaId, ')
          ..write('codigoIphan: $codigoIphan, ')
          ..write('nomeBem: $nomeBem, ')
          ..write('nomesPopulares: $nomesPopulares, ')
          ..write('natureza: $natureza, ')
          ..write('tipo: $tipo, ')
          ..write('meiosAcesso: $meiosAcesso, ')
          ..write('artefatos: $artefatos, ')
          ..write('publicado: $publicado, ')
          ..write('uf: $uf, ')
          ..write('municipio: $municipio, ')
          ..write('cep: $cep, ')
          ..write('endereco: $endereco, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('geojson: $geojson, ')
          ..write('anoRegistro: $anoRegistro, ')
          ..write('descricaoAtualizacao: $descricaoAtualizacao, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('deletadoEm: $deletadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    uuid,
    coletaId,
    codigoIphan,
    nomeBem,
    nomesPopulares,
    natureza,
    tipo,
    meiosAcesso,
    artefatos,
    publicado,
    uf,
    municipio,
    cep,
    endereco,
    latitude,
    longitude,
    geojson,
    anoRegistro,
    descricaoAtualizacao,
    criadoEm,
    atualizadoEm,
    deletadoEm,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BensMateriai &&
          other.uuid == this.uuid &&
          other.coletaId == this.coletaId &&
          other.codigoIphan == this.codigoIphan &&
          other.nomeBem == this.nomeBem &&
          other.nomesPopulares == this.nomesPopulares &&
          other.natureza == this.natureza &&
          other.tipo == this.tipo &&
          other.meiosAcesso == this.meiosAcesso &&
          other.artefatos == this.artefatos &&
          other.publicado == this.publicado &&
          other.uf == this.uf &&
          other.municipio == this.municipio &&
          other.cep == this.cep &&
          other.endereco == this.endereco &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.geojson == this.geojson &&
          other.anoRegistro == this.anoRegistro &&
          other.descricaoAtualizacao == this.descricaoAtualizacao &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm &&
          other.deletadoEm == this.deletadoEm);
}

class BensMateriaisCompanion extends UpdateCompanion<BensMateriai> {
  final Value<String> uuid;
  final Value<String> coletaId;
  final Value<String?> codigoIphan;
  final Value<String> nomeBem;
  final Value<String?> nomesPopulares;
  final Value<String> natureza;
  final Value<String> tipo;
  final Value<String?> meiosAcesso;
  final Value<List<String>> artefatos;
  final Value<bool> publicado;
  final Value<String?> uf;
  final Value<String?> municipio;
  final Value<String?> cep;
  final Value<String?> endereco;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> geojson;
  final Value<int?> anoRegistro;
  final Value<String?> descricaoAtualizacao;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> deletadoEm;
  final Value<int> rowid;
  const BensMateriaisCompanion({
    this.uuid = const Value.absent(),
    this.coletaId = const Value.absent(),
    this.codigoIphan = const Value.absent(),
    this.nomeBem = const Value.absent(),
    this.nomesPopulares = const Value.absent(),
    this.natureza = const Value.absent(),
    this.tipo = const Value.absent(),
    this.meiosAcesso = const Value.absent(),
    this.artefatos = const Value.absent(),
    this.publicado = const Value.absent(),
    this.uf = const Value.absent(),
    this.municipio = const Value.absent(),
    this.cep = const Value.absent(),
    this.endereco = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.geojson = const Value.absent(),
    this.anoRegistro = const Value.absent(),
    this.descricaoAtualizacao = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.deletadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BensMateriaisCompanion.insert({
    required String uuid,
    required String coletaId,
    this.codigoIphan = const Value.absent(),
    required String nomeBem,
    this.nomesPopulares = const Value.absent(),
    required String natureza,
    required String tipo,
    this.meiosAcesso = const Value.absent(),
    this.artefatos = const Value.absent(),
    this.publicado = const Value.absent(),
    this.uf = const Value.absent(),
    this.municipio = const Value.absent(),
    this.cep = const Value.absent(),
    this.endereco = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.geojson = const Value.absent(),
    this.anoRegistro = const Value.absent(),
    this.descricaoAtualizacao = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.deletadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       coletaId = Value(coletaId),
       nomeBem = Value(nomeBem),
       natureza = Value(natureza),
       tipo = Value(tipo);
  static Insertable<BensMateriai> custom({
    Expression<String>? uuid,
    Expression<String>? coletaId,
    Expression<String>? codigoIphan,
    Expression<String>? nomeBem,
    Expression<String>? nomesPopulares,
    Expression<String>? natureza,
    Expression<String>? tipo,
    Expression<String>? meiosAcesso,
    Expression<String>? artefatos,
    Expression<bool>? publicado,
    Expression<String>? uf,
    Expression<String>? municipio,
    Expression<String>? cep,
    Expression<String>? endereco,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? geojson,
    Expression<int>? anoRegistro,
    Expression<String>? descricaoAtualizacao,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? deletadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (coletaId != null) 'coleta_id': coletaId,
      if (codigoIphan != null) 'codigo_iphan': codigoIphan,
      if (nomeBem != null) 'nome_bem': nomeBem,
      if (nomesPopulares != null) 'nomes_populares': nomesPopulares,
      if (natureza != null) 'natureza': natureza,
      if (tipo != null) 'tipo': tipo,
      if (meiosAcesso != null) 'meios_acesso': meiosAcesso,
      if (artefatos != null) 'artefatos': artefatos,
      if (publicado != null) 'publicado': publicado,
      if (uf != null) 'uf': uf,
      if (municipio != null) 'municipio': municipio,
      if (cep != null) 'cep': cep,
      if (endereco != null) 'endereco': endereco,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (geojson != null) 'geojson': geojson,
      if (anoRegistro != null) 'ano_registro': anoRegistro,
      if (descricaoAtualizacao != null)
        'descricao_atualizacao': descricaoAtualizacao,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (deletadoEm != null) 'deletado_em': deletadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BensMateriaisCompanion copyWith({
    Value<String>? uuid,
    Value<String>? coletaId,
    Value<String?>? codigoIphan,
    Value<String>? nomeBem,
    Value<String?>? nomesPopulares,
    Value<String>? natureza,
    Value<String>? tipo,
    Value<String?>? meiosAcesso,
    Value<List<String>>? artefatos,
    Value<bool>? publicado,
    Value<String?>? uf,
    Value<String?>? municipio,
    Value<String?>? cep,
    Value<String?>? endereco,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? geojson,
    Value<int?>? anoRegistro,
    Value<String?>? descricaoAtualizacao,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? deletadoEm,
    Value<int>? rowid,
  }) {
    return BensMateriaisCompanion(
      uuid: uuid ?? this.uuid,
      coletaId: coletaId ?? this.coletaId,
      codigoIphan: codigoIphan ?? this.codigoIphan,
      nomeBem: nomeBem ?? this.nomeBem,
      nomesPopulares: nomesPopulares ?? this.nomesPopulares,
      natureza: natureza ?? this.natureza,
      tipo: tipo ?? this.tipo,
      meiosAcesso: meiosAcesso ?? this.meiosAcesso,
      artefatos: artefatos ?? this.artefatos,
      publicado: publicado ?? this.publicado,
      uf: uf ?? this.uf,
      municipio: municipio ?? this.municipio,
      cep: cep ?? this.cep,
      endereco: endereco ?? this.endereco,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geojson: geojson ?? this.geojson,
      anoRegistro: anoRegistro ?? this.anoRegistro,
      descricaoAtualizacao: descricaoAtualizacao ?? this.descricaoAtualizacao,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      deletadoEm: deletadoEm ?? this.deletadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (coletaId.present) {
      map['coleta_id'] = Variable<String>(coletaId.value);
    }
    if (codigoIphan.present) {
      map['codigo_iphan'] = Variable<String>(codigoIphan.value);
    }
    if (nomeBem.present) {
      map['nome_bem'] = Variable<String>(nomeBem.value);
    }
    if (nomesPopulares.present) {
      map['nomes_populares'] = Variable<String>(nomesPopulares.value);
    }
    if (natureza.present) {
      map['natureza'] = Variable<String>(natureza.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (meiosAcesso.present) {
      map['meios_acesso'] = Variable<String>(meiosAcesso.value);
    }
    if (artefatos.present) {
      map['artefatos'] = Variable<String>(
        $BensMateriaisTable.$converterartefatos.toSql(artefatos.value),
      );
    }
    if (publicado.present) {
      map['publicado'] = Variable<bool>(publicado.value);
    }
    if (uf.present) {
      map['uf'] = Variable<String>(uf.value);
    }
    if (municipio.present) {
      map['municipio'] = Variable<String>(municipio.value);
    }
    if (cep.present) {
      map['cep'] = Variable<String>(cep.value);
    }
    if (endereco.present) {
      map['endereco'] = Variable<String>(endereco.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (geojson.present) {
      map['geojson'] = Variable<String>(geojson.value);
    }
    if (anoRegistro.present) {
      map['ano_registro'] = Variable<int>(anoRegistro.value);
    }
    if (descricaoAtualizacao.present) {
      map['descricao_atualizacao'] = Variable<String>(
        descricaoAtualizacao.value,
      );
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (deletadoEm.present) {
      map['deletado_em'] = Variable<DateTime>(deletadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BensMateriaisCompanion(')
          ..write('uuid: $uuid, ')
          ..write('coletaId: $coletaId, ')
          ..write('codigoIphan: $codigoIphan, ')
          ..write('nomeBem: $nomeBem, ')
          ..write('nomesPopulares: $nomesPopulares, ')
          ..write('natureza: $natureza, ')
          ..write('tipo: $tipo, ')
          ..write('meiosAcesso: $meiosAcesso, ')
          ..write('artefatos: $artefatos, ')
          ..write('publicado: $publicado, ')
          ..write('uf: $uf, ')
          ..write('municipio: $municipio, ')
          ..write('cep: $cep, ')
          ..write('endereco: $endereco, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('geojson: $geojson, ')
          ..write('anoRegistro: $anoRegistro, ')
          ..write('descricaoAtualizacao: $descricaoAtualizacao, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('deletadoEm: $deletadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _senhaHashMeta = const VerificationMeta(
    'senhaHash',
  );
  @override
  late final GeneratedColumn<String> senhaHash = GeneratedColumn<String>(
    'senha_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PerfilUsuario, String> perfil =
      GeneratedColumn<String>(
        'perfil_usuario',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => PerfilUsuario.coletor.name,
      ).withConverter<PerfilUsuario>($UsuariosTable.$converterperfil);
  @override
  late final GeneratedColumnWithTypeConverter<ClassificacaoUsuario, String>
  classificacao = GeneratedColumn<String>(
    'classificacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => ClassificacaoUsuario.arqueologo.name,
  ).withConverter<ClassificacaoUsuario>($UsuariosTable.$converterclassificacao);
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    clientDefault: () => true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    nome,
    email,
    senhaHash,
    perfil,
    classificacao,
    ativo,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('senha_hash')) {
      context.handle(
        _senhaHashMeta,
        senhaHash.isAcceptableOrUnknown(data['senha_hash']!, _senhaHashMeta),
      );
    } else if (isInserting) {
      context.missing(_senhaHashMeta);
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      senhaHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}senha_hash'],
      )!,
      perfil: $UsuariosTable.$converterperfil.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}perfil_usuario'],
        )!,
      ),
      classificacao: $UsuariosTable.$converterclassificacao.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}classificacao'],
        )!,
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PerfilUsuario, String, String> $converterperfil =
      const EnumNameConverter<PerfilUsuario>(PerfilUsuario.values);
  static JsonTypeConverter2<ClassificacaoUsuario, String, String>
  $converterclassificacao = const EnumNameConverter<ClassificacaoUsuario>(
    ClassificacaoUsuario.values,
  );
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final String uuid;
  final String nome;
  final String email;
  final String senhaHash;
  final PerfilUsuario perfil;
  final ClassificacaoUsuario classificacao;
  final bool ativo;
  final DateTime criadoEm;
  const Usuario({
    required this.uuid,
    required this.nome,
    required this.email,
    required this.senhaHash,
    required this.perfil,
    required this.classificacao,
    required this.ativo,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['nome'] = Variable<String>(nome);
    map['email'] = Variable<String>(email);
    map['senha_hash'] = Variable<String>(senhaHash);
    {
      map['perfil_usuario'] = Variable<String>(
        $UsuariosTable.$converterperfil.toSql(perfil),
      );
    }
    {
      map['classificacao'] = Variable<String>(
        $UsuariosTable.$converterclassificacao.toSql(classificacao),
      );
    }
    map['ativo'] = Variable<bool>(ativo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      uuid: Value(uuid),
      nome: Value(nome),
      email: Value(email),
      senhaHash: Value(senhaHash),
      perfil: Value(perfil),
      classificacao: Value(classificacao),
      ativo: Value(ativo),
      criadoEm: Value(criadoEm),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      uuid: serializer.fromJson<String>(json['uuid']),
      nome: serializer.fromJson<String>(json['nome']),
      email: serializer.fromJson<String>(json['email']),
      senhaHash: serializer.fromJson<String>(json['senhaHash']),
      perfil: $UsuariosTable.$converterperfil.fromJson(
        serializer.fromJson<String>(json['perfil']),
      ),
      classificacao: $UsuariosTable.$converterclassificacao.fromJson(
        serializer.fromJson<String>(json['classificacao']),
      ),
      ativo: serializer.fromJson<bool>(json['ativo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'nome': serializer.toJson<String>(nome),
      'email': serializer.toJson<String>(email),
      'senhaHash': serializer.toJson<String>(senhaHash),
      'perfil': serializer.toJson<String>(
        $UsuariosTable.$converterperfil.toJson(perfil),
      ),
      'classificacao': serializer.toJson<String>(
        $UsuariosTable.$converterclassificacao.toJson(classificacao),
      ),
      'ativo': serializer.toJson<bool>(ativo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Usuario copyWith({
    String? uuid,
    String? nome,
    String? email,
    String? senhaHash,
    PerfilUsuario? perfil,
    ClassificacaoUsuario? classificacao,
    bool? ativo,
    DateTime? criadoEm,
  }) => Usuario(
    uuid: uuid ?? this.uuid,
    nome: nome ?? this.nome,
    email: email ?? this.email,
    senhaHash: senhaHash ?? this.senhaHash,
    perfil: perfil ?? this.perfil,
    classificacao: classificacao ?? this.classificacao,
    ativo: ativo ?? this.ativo,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nome: data.nome.present ? data.nome.value : this.nome,
      email: data.email.present ? data.email.value : this.email,
      senhaHash: data.senhaHash.present ? data.senhaHash.value : this.senhaHash,
      perfil: data.perfil.present ? data.perfil.value : this.perfil,
      classificacao: data.classificacao.present
          ? data.classificacao.value
          : this.classificacao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('uuid: $uuid, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senhaHash: $senhaHash, ')
          ..write('perfil: $perfil, ')
          ..write('classificacao: $classificacao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    nome,
    email,
    senhaHash,
    perfil,
    classificacao,
    ativo,
    criadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.uuid == this.uuid &&
          other.nome == this.nome &&
          other.email == this.email &&
          other.senhaHash == this.senhaHash &&
          other.perfil == this.perfil &&
          other.classificacao == this.classificacao &&
          other.ativo == this.ativo &&
          other.criadoEm == this.criadoEm);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<String> uuid;
  final Value<String> nome;
  final Value<String> email;
  final Value<String> senhaHash;
  final Value<PerfilUsuario> perfil;
  final Value<ClassificacaoUsuario> classificacao;
  final Value<bool> ativo;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const UsuariosCompanion({
    this.uuid = const Value.absent(),
    this.nome = const Value.absent(),
    this.email = const Value.absent(),
    this.senhaHash = const Value.absent(),
    this.perfil = const Value.absent(),
    this.classificacao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsuariosCompanion.insert({
    required String uuid,
    required String nome,
    required String email,
    required String senhaHash,
    this.perfil = const Value.absent(),
    this.classificacao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       nome = Value(nome),
       email = Value(email),
       senhaHash = Value(senhaHash);
  static Insertable<Usuario> custom({
    Expression<String>? uuid,
    Expression<String>? nome,
    Expression<String>? email,
    Expression<String>? senhaHash,
    Expression<String>? perfil,
    Expression<String>? classificacao,
    Expression<bool>? ativo,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (senhaHash != null) 'senha_hash': senhaHash,
      if (perfil != null) 'perfil_usuario': perfil,
      if (classificacao != null) 'classificacao': classificacao,
      if (ativo != null) 'ativo': ativo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsuariosCompanion copyWith({
    Value<String>? uuid,
    Value<String>? nome,
    Value<String>? email,
    Value<String>? senhaHash,
    Value<PerfilUsuario>? perfil,
    Value<ClassificacaoUsuario>? classificacao,
    Value<bool>? ativo,
    Value<DateTime>? criadoEm,
    Value<int>? rowid,
  }) {
    return UsuariosCompanion(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senhaHash: senhaHash ?? this.senhaHash,
      perfil: perfil ?? this.perfil,
      classificacao: classificacao ?? this.classificacao,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (senhaHash.present) {
      map['senha_hash'] = Variable<String>(senhaHash.value);
    }
    if (perfil.present) {
      map['perfil_usuario'] = Variable<String>(
        $UsuariosTable.$converterperfil.toSql(perfil.value),
      );
    }
    if (classificacao.present) {
      map['classificacao'] = Variable<String>(
        $UsuariosTable.$converterclassificacao.toSql(classificacao.value),
      );
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('uuid: $uuid, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senhaHash: $senhaHash, ')
          ..write('perfil: $perfil, ')
          ..write('classificacao: $classificacao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CuradoriasTable extends Curadorias
    with TableInfo<$CuradoriasTable, Curadoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuradoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coletaIdMeta = const VerificationMeta(
    'coletaId',
  );
  @override
  late final GeneratedColumn<String> coletaId = GeneratedColumn<String>(
    'coleta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES coletas (uuid)',
    ),
  );
  static const VerificationMeta _bemMaterialIdMeta = const VerificationMeta(
    'bemMaterialId',
  );
  @override
  late final GeneratedColumn<String> bemMaterialId = GeneratedColumn<String>(
    'bem_material_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bens_materiais (uuid)',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (uuid)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StatusCuradoria, String> status =
      GeneratedColumn<String>(
        'status_curadoria',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => StatusCuradoria.pendente.name,
      ).withConverter<StatusCuradoria>($CuradoriasTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<AcaoResultanteCuradoria, String>
  acaoResultante =
      GeneratedColumn<String>(
        'acao_resultante',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => AcaoResultanteCuradoria.criarSitio.name,
      ).withConverter<AcaoResultanteCuradoria>(
        $CuradoriasTable.$converteracaoResultante,
      );
  static const VerificationMeta _dataAvaliacaoMeta = const VerificationMeta(
    'dataAvaliacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAvaliacao =
      GeneratedColumn<DateTime>(
        'data_avaliacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  static const VerificationMeta _observacaoMeta = const VerificationMeta(
    'observacao',
  );
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
    'observacao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    coletaId,
    bemMaterialId,
    usuarioId,
    status,
    acaoResultante,
    dataAvaliacao,
    observacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curadorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Curadoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('coleta_id')) {
      context.handle(
        _coletaIdMeta,
        coletaId.isAcceptableOrUnknown(data['coleta_id']!, _coletaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coletaIdMeta);
    }
    if (data.containsKey('bem_material_id')) {
      context.handle(
        _bemMaterialIdMeta,
        bemMaterialId.isAcceptableOrUnknown(
          data['bem_material_id']!,
          _bemMaterialIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('data_avaliacao')) {
      context.handle(
        _dataAvaliacaoMeta,
        dataAvaliacao.isAcceptableOrUnknown(
          data['data_avaliacao']!,
          _dataAvaliacaoMeta,
        ),
      );
    }
    if (data.containsKey('observacao')) {
      context.handle(
        _observacaoMeta,
        observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  Curadoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Curadoria(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      coletaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coleta_id'],
      )!,
      bemMaterialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bem_material_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      status: $CuradoriasTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status_curadoria'],
        )!,
      ),
      acaoResultante: $CuradoriasTable.$converteracaoResultante.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}acao_resultante'],
        )!,
      ),
      dataAvaliacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_avaliacao'],
      )!,
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
    );
  }

  @override
  $CuradoriasTable createAlias(String alias) {
    return $CuradoriasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StatusCuradoria, String, String> $converterstatus =
      const EnumNameConverter<StatusCuradoria>(StatusCuradoria.values);
  static JsonTypeConverter2<AcaoResultanteCuradoria, String, String>
  $converteracaoResultante = const EnumNameConverter<AcaoResultanteCuradoria>(
    AcaoResultanteCuradoria.values,
  );
}

class Curadoria extends DataClass implements Insertable<Curadoria> {
  final String uuid;
  final String coletaId;
  final String? bemMaterialId;
  final String usuarioId;
  final StatusCuradoria status;
  final AcaoResultanteCuradoria acaoResultante;
  final DateTime dataAvaliacao;
  final String? observacao;
  const Curadoria({
    required this.uuid,
    required this.coletaId,
    this.bemMaterialId,
    required this.usuarioId,
    required this.status,
    required this.acaoResultante,
    required this.dataAvaliacao,
    this.observacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['coleta_id'] = Variable<String>(coletaId);
    if (!nullToAbsent || bemMaterialId != null) {
      map['bem_material_id'] = Variable<String>(bemMaterialId);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    {
      map['status_curadoria'] = Variable<String>(
        $CuradoriasTable.$converterstatus.toSql(status),
      );
    }
    {
      map['acao_resultante'] = Variable<String>(
        $CuradoriasTable.$converteracaoResultante.toSql(acaoResultante),
      );
    }
    map['data_avaliacao'] = Variable<DateTime>(dataAvaliacao);
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    return map;
  }

  CuradoriasCompanion toCompanion(bool nullToAbsent) {
    return CuradoriasCompanion(
      uuid: Value(uuid),
      coletaId: Value(coletaId),
      bemMaterialId: bemMaterialId == null && nullToAbsent
          ? const Value.absent()
          : Value(bemMaterialId),
      usuarioId: Value(usuarioId),
      status: Value(status),
      acaoResultante: Value(acaoResultante),
      dataAvaliacao: Value(dataAvaliacao),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
    );
  }

  factory Curadoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Curadoria(
      uuid: serializer.fromJson<String>(json['uuid']),
      coletaId: serializer.fromJson<String>(json['coletaId']),
      bemMaterialId: serializer.fromJson<String?>(json['bemMaterialId']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      status: $CuradoriasTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      acaoResultante: $CuradoriasTable.$converteracaoResultante.fromJson(
        serializer.fromJson<String>(json['acaoResultante']),
      ),
      dataAvaliacao: serializer.fromJson<DateTime>(json['dataAvaliacao']),
      observacao: serializer.fromJson<String?>(json['observacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'coletaId': serializer.toJson<String>(coletaId),
      'bemMaterialId': serializer.toJson<String?>(bemMaterialId),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'status': serializer.toJson<String>(
        $CuradoriasTable.$converterstatus.toJson(status),
      ),
      'acaoResultante': serializer.toJson<String>(
        $CuradoriasTable.$converteracaoResultante.toJson(acaoResultante),
      ),
      'dataAvaliacao': serializer.toJson<DateTime>(dataAvaliacao),
      'observacao': serializer.toJson<String?>(observacao),
    };
  }

  Curadoria copyWith({
    String? uuid,
    String? coletaId,
    Value<String?> bemMaterialId = const Value.absent(),
    String? usuarioId,
    StatusCuradoria? status,
    AcaoResultanteCuradoria? acaoResultante,
    DateTime? dataAvaliacao,
    Value<String?> observacao = const Value.absent(),
  }) => Curadoria(
    uuid: uuid ?? this.uuid,
    coletaId: coletaId ?? this.coletaId,
    bemMaterialId: bemMaterialId.present
        ? bemMaterialId.value
        : this.bemMaterialId,
    usuarioId: usuarioId ?? this.usuarioId,
    status: status ?? this.status,
    acaoResultante: acaoResultante ?? this.acaoResultante,
    dataAvaliacao: dataAvaliacao ?? this.dataAvaliacao,
    observacao: observacao.present ? observacao.value : this.observacao,
  );
  Curadoria copyWithCompanion(CuradoriasCompanion data) {
    return Curadoria(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      coletaId: data.coletaId.present ? data.coletaId.value : this.coletaId,
      bemMaterialId: data.bemMaterialId.present
          ? data.bemMaterialId.value
          : this.bemMaterialId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      status: data.status.present ? data.status.value : this.status,
      acaoResultante: data.acaoResultante.present
          ? data.acaoResultante.value
          : this.acaoResultante,
      dataAvaliacao: data.dataAvaliacao.present
          ? data.dataAvaliacao.value
          : this.dataAvaliacao,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Curadoria(')
          ..write('uuid: $uuid, ')
          ..write('coletaId: $coletaId, ')
          ..write('bemMaterialId: $bemMaterialId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('status: $status, ')
          ..write('acaoResultante: $acaoResultante, ')
          ..write('dataAvaliacao: $dataAvaliacao, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    coletaId,
    bemMaterialId,
    usuarioId,
    status,
    acaoResultante,
    dataAvaliacao,
    observacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Curadoria &&
          other.uuid == this.uuid &&
          other.coletaId == this.coletaId &&
          other.bemMaterialId == this.bemMaterialId &&
          other.usuarioId == this.usuarioId &&
          other.status == this.status &&
          other.acaoResultante == this.acaoResultante &&
          other.dataAvaliacao == this.dataAvaliacao &&
          other.observacao == this.observacao);
}

class CuradoriasCompanion extends UpdateCompanion<Curadoria> {
  final Value<String> uuid;
  final Value<String> coletaId;
  final Value<String?> bemMaterialId;
  final Value<String> usuarioId;
  final Value<StatusCuradoria> status;
  final Value<AcaoResultanteCuradoria> acaoResultante;
  final Value<DateTime> dataAvaliacao;
  final Value<String?> observacao;
  final Value<int> rowid;
  const CuradoriasCompanion({
    this.uuid = const Value.absent(),
    this.coletaId = const Value.absent(),
    this.bemMaterialId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.status = const Value.absent(),
    this.acaoResultante = const Value.absent(),
    this.dataAvaliacao = const Value.absent(),
    this.observacao = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CuradoriasCompanion.insert({
    required String uuid,
    required String coletaId,
    this.bemMaterialId = const Value.absent(),
    required String usuarioId,
    this.status = const Value.absent(),
    this.acaoResultante = const Value.absent(),
    this.dataAvaliacao = const Value.absent(),
    this.observacao = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       coletaId = Value(coletaId),
       usuarioId = Value(usuarioId);
  static Insertable<Curadoria> custom({
    Expression<String>? uuid,
    Expression<String>? coletaId,
    Expression<String>? bemMaterialId,
    Expression<String>? usuarioId,
    Expression<String>? status,
    Expression<String>? acaoResultante,
    Expression<DateTime>? dataAvaliacao,
    Expression<String>? observacao,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (coletaId != null) 'coleta_id': coletaId,
      if (bemMaterialId != null) 'bem_material_id': bemMaterialId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (status != null) 'status_curadoria': status,
      if (acaoResultante != null) 'acao_resultante': acaoResultante,
      if (dataAvaliacao != null) 'data_avaliacao': dataAvaliacao,
      if (observacao != null) 'observacao': observacao,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CuradoriasCompanion copyWith({
    Value<String>? uuid,
    Value<String>? coletaId,
    Value<String?>? bemMaterialId,
    Value<String>? usuarioId,
    Value<StatusCuradoria>? status,
    Value<AcaoResultanteCuradoria>? acaoResultante,
    Value<DateTime>? dataAvaliacao,
    Value<String?>? observacao,
    Value<int>? rowid,
  }) {
    return CuradoriasCompanion(
      uuid: uuid ?? this.uuid,
      coletaId: coletaId ?? this.coletaId,
      bemMaterialId: bemMaterialId ?? this.bemMaterialId,
      usuarioId: usuarioId ?? this.usuarioId,
      status: status ?? this.status,
      acaoResultante: acaoResultante ?? this.acaoResultante,
      dataAvaliacao: dataAvaliacao ?? this.dataAvaliacao,
      observacao: observacao ?? this.observacao,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (coletaId.present) {
      map['coleta_id'] = Variable<String>(coletaId.value);
    }
    if (bemMaterialId.present) {
      map['bem_material_id'] = Variable<String>(bemMaterialId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (status.present) {
      map['status_curadoria'] = Variable<String>(
        $CuradoriasTable.$converterstatus.toSql(status.value),
      );
    }
    if (acaoResultante.present) {
      map['acao_resultante'] = Variable<String>(
        $CuradoriasTable.$converteracaoResultante.toSql(acaoResultante.value),
      );
    }
    if (dataAvaliacao.present) {
      map['data_avaliacao'] = Variable<DateTime>(dataAvaliacao.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuradoriasCompanion(')
          ..write('uuid: $uuid, ')
          ..write('coletaId: $coletaId, ')
          ..write('bemMaterialId: $bemMaterialId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('status: $status, ')
          ..write('acaoResultante: $acaoResultante, ')
          ..write('dataAvaliacao: $dataAvaliacao, ')
          ..write('observacao: $observacao, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MidiaLinksTable extends MidiaLinks
    with TableInfo<$MidiaLinksTable, MidiaLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MidiaLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bemMaterialIdMeta = const VerificationMeta(
    'bemMaterialId',
  );
  @override
  late final GeneratedColumn<String> bemMaterialId = GeneratedColumn<String>(
    'bem_material_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bens_materiais (uuid)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMidia, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => TipoMidia.imagem.name,
      ).withConverter<TipoMidia>($MidiaLinksTable.$convertertipo);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    bemMaterialId,
    tipo,
    url,
    descricao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'midia_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<MidiaLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('bem_material_id')) {
      context.handle(
        _bemMaterialIdMeta,
        bemMaterialId.isAcceptableOrUnknown(
          data['bem_material_id']!,
          _bemMaterialIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bemMaterialIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  MidiaLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MidiaLink(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      bemMaterialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bem_material_id'],
      )!,
      tipo: $MidiaLinksTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
    );
  }

  @override
  $MidiaLinksTable createAlias(String alias) {
    return $MidiaLinksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMidia, String, String> $convertertipo =
      const EnumNameConverter<TipoMidia>(TipoMidia.values);
}

class MidiaLink extends DataClass implements Insertable<MidiaLink> {
  final String uuid;
  final String bemMaterialId;
  final TipoMidia tipo;
  final String url;
  final String? descricao;
  const MidiaLink({
    required this.uuid,
    required this.bemMaterialId,
    required this.tipo,
    required this.url,
    this.descricao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['bem_material_id'] = Variable<String>(bemMaterialId);
    {
      map['tipo'] = Variable<String>(
        $MidiaLinksTable.$convertertipo.toSql(tipo),
      );
    }
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    return map;
  }

  MidiaLinksCompanion toCompanion(bool nullToAbsent) {
    return MidiaLinksCompanion(
      uuid: Value(uuid),
      bemMaterialId: Value(bemMaterialId),
      tipo: Value(tipo),
      url: Value(url),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
    );
  }

  factory MidiaLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MidiaLink(
      uuid: serializer.fromJson<String>(json['uuid']),
      bemMaterialId: serializer.fromJson<String>(json['bemMaterialId']),
      tipo: $MidiaLinksTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      url: serializer.fromJson<String>(json['url']),
      descricao: serializer.fromJson<String?>(json['descricao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'bemMaterialId': serializer.toJson<String>(bemMaterialId),
      'tipo': serializer.toJson<String>(
        $MidiaLinksTable.$convertertipo.toJson(tipo),
      ),
      'url': serializer.toJson<String>(url),
      'descricao': serializer.toJson<String?>(descricao),
    };
  }

  MidiaLink copyWith({
    String? uuid,
    String? bemMaterialId,
    TipoMidia? tipo,
    String? url,
    Value<String?> descricao = const Value.absent(),
  }) => MidiaLink(
    uuid: uuid ?? this.uuid,
    bemMaterialId: bemMaterialId ?? this.bemMaterialId,
    tipo: tipo ?? this.tipo,
    url: url ?? this.url,
    descricao: descricao.present ? descricao.value : this.descricao,
  );
  MidiaLink copyWithCompanion(MidiaLinksCompanion data) {
    return MidiaLink(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      bemMaterialId: data.bemMaterialId.present
          ? data.bemMaterialId.value
          : this.bemMaterialId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      url: data.url.present ? data.url.value : this.url,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MidiaLink(')
          ..write('uuid: $uuid, ')
          ..write('bemMaterialId: $bemMaterialId, ')
          ..write('tipo: $tipo, ')
          ..write('url: $url, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, bemMaterialId, tipo, url, descricao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MidiaLink &&
          other.uuid == this.uuid &&
          other.bemMaterialId == this.bemMaterialId &&
          other.tipo == this.tipo &&
          other.url == this.url &&
          other.descricao == this.descricao);
}

class MidiaLinksCompanion extends UpdateCompanion<MidiaLink> {
  final Value<String> uuid;
  final Value<String> bemMaterialId;
  final Value<TipoMidia> tipo;
  final Value<String> url;
  final Value<String?> descricao;
  final Value<int> rowid;
  const MidiaLinksCompanion({
    this.uuid = const Value.absent(),
    this.bemMaterialId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.url = const Value.absent(),
    this.descricao = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MidiaLinksCompanion.insert({
    required String uuid,
    required String bemMaterialId,
    this.tipo = const Value.absent(),
    required String url,
    this.descricao = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       bemMaterialId = Value(bemMaterialId),
       url = Value(url);
  static Insertable<MidiaLink> custom({
    Expression<String>? uuid,
    Expression<String>? bemMaterialId,
    Expression<String>? tipo,
    Expression<String>? url,
    Expression<String>? descricao,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (bemMaterialId != null) 'bem_material_id': bemMaterialId,
      if (tipo != null) 'tipo': tipo,
      if (url != null) 'url': url,
      if (descricao != null) 'descricao': descricao,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MidiaLinksCompanion copyWith({
    Value<String>? uuid,
    Value<String>? bemMaterialId,
    Value<TipoMidia>? tipo,
    Value<String>? url,
    Value<String?>? descricao,
    Value<int>? rowid,
  }) {
    return MidiaLinksCompanion(
      uuid: uuid ?? this.uuid,
      bemMaterialId: bemMaterialId ?? this.bemMaterialId,
      tipo: tipo ?? this.tipo,
      url: url ?? this.url,
      descricao: descricao ?? this.descricao,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (bemMaterialId.present) {
      map['bem_material_id'] = Variable<String>(bemMaterialId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $MidiaLinksTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MidiaLinksCompanion(')
          ..write('uuid: $uuid, ')
          ..write('bemMaterialId: $bemMaterialId, ')
          ..write('tipo: $tipo, ')
          ..write('url: $url, ')
          ..write('descricao: $descricao, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResponsaveisSitioTable extends ResponsaveisSitio
    with TableInfo<$ResponsaveisSitioTable, ResponsaveisSitioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResponsaveisSitioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bemMaterialIdMeta = const VerificationMeta(
    'bemMaterialId',
  );
  @override
  late final GeneratedColumn<String> bemMaterialId = GeneratedColumn<String>(
    'bem_material_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bens_materiais (uuid)',
    ),
  );
  static const VerificationMeta _contatoNomeMeta = const VerificationMeta(
    'contatoNome',
  );
  @override
  late final GeneratedColumn<String> contatoNome = GeneratedColumn<String>(
    'contato_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contatoEmailMeta = const VerificationMeta(
    'contatoEmail',
  );
  @override
  late final GeneratedColumn<String> contatoEmail = GeneratedColumn<String>(
    'contato_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contatoTelefoneMeta = const VerificationMeta(
    'contatoTelefone',
  );
  @override
  late final GeneratedColumn<String> contatoTelefone = GeneratedColumn<String>(
    'contato_telefone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    bemMaterialId,
    contatoNome,
    contatoEmail,
    contatoTelefone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'responsaveis_sitio';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResponsaveisSitioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('bem_material_id')) {
      context.handle(
        _bemMaterialIdMeta,
        bemMaterialId.isAcceptableOrUnknown(
          data['bem_material_id']!,
          _bemMaterialIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bemMaterialIdMeta);
    }
    if (data.containsKey('contato_nome')) {
      context.handle(
        _contatoNomeMeta,
        contatoNome.isAcceptableOrUnknown(
          data['contato_nome']!,
          _contatoNomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contatoNomeMeta);
    }
    if (data.containsKey('contato_email')) {
      context.handle(
        _contatoEmailMeta,
        contatoEmail.isAcceptableOrUnknown(
          data['contato_email']!,
          _contatoEmailMeta,
        ),
      );
    }
    if (data.containsKey('contato_telefone')) {
      context.handle(
        _contatoTelefoneMeta,
        contatoTelefone.isAcceptableOrUnknown(
          data['contato_telefone']!,
          _contatoTelefoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bemMaterialId},
  ];
  @override
  ResponsaveisSitioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResponsaveisSitioData(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      bemMaterialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bem_material_id'],
      )!,
      contatoNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contato_nome'],
      )!,
      contatoEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contato_email'],
      ),
      contatoTelefone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contato_telefone'],
      ),
    );
  }

  @override
  $ResponsaveisSitioTable createAlias(String alias) {
    return $ResponsaveisSitioTable(attachedDatabase, alias);
  }
}

class ResponsaveisSitioData extends DataClass
    implements Insertable<ResponsaveisSitioData> {
  final String uuid;
  final String bemMaterialId;
  final String contatoNome;
  final String? contatoEmail;
  final String? contatoTelefone;
  const ResponsaveisSitioData({
    required this.uuid,
    required this.bemMaterialId,
    required this.contatoNome,
    this.contatoEmail,
    this.contatoTelefone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['bem_material_id'] = Variable<String>(bemMaterialId);
    map['contato_nome'] = Variable<String>(contatoNome);
    if (!nullToAbsent || contatoEmail != null) {
      map['contato_email'] = Variable<String>(contatoEmail);
    }
    if (!nullToAbsent || contatoTelefone != null) {
      map['contato_telefone'] = Variable<String>(contatoTelefone);
    }
    return map;
  }

  ResponsaveisSitioCompanion toCompanion(bool nullToAbsent) {
    return ResponsaveisSitioCompanion(
      uuid: Value(uuid),
      bemMaterialId: Value(bemMaterialId),
      contatoNome: Value(contatoNome),
      contatoEmail: contatoEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(contatoEmail),
      contatoTelefone: contatoTelefone == null && nullToAbsent
          ? const Value.absent()
          : Value(contatoTelefone),
    );
  }

  factory ResponsaveisSitioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResponsaveisSitioData(
      uuid: serializer.fromJson<String>(json['uuid']),
      bemMaterialId: serializer.fromJson<String>(json['bemMaterialId']),
      contatoNome: serializer.fromJson<String>(json['contatoNome']),
      contatoEmail: serializer.fromJson<String?>(json['contatoEmail']),
      contatoTelefone: serializer.fromJson<String?>(json['contatoTelefone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'bemMaterialId': serializer.toJson<String>(bemMaterialId),
      'contatoNome': serializer.toJson<String>(contatoNome),
      'contatoEmail': serializer.toJson<String?>(contatoEmail),
      'contatoTelefone': serializer.toJson<String?>(contatoTelefone),
    };
  }

  ResponsaveisSitioData copyWith({
    String? uuid,
    String? bemMaterialId,
    String? contatoNome,
    Value<String?> contatoEmail = const Value.absent(),
    Value<String?> contatoTelefone = const Value.absent(),
  }) => ResponsaveisSitioData(
    uuid: uuid ?? this.uuid,
    bemMaterialId: bemMaterialId ?? this.bemMaterialId,
    contatoNome: contatoNome ?? this.contatoNome,
    contatoEmail: contatoEmail.present ? contatoEmail.value : this.contatoEmail,
    contatoTelefone: contatoTelefone.present
        ? contatoTelefone.value
        : this.contatoTelefone,
  );
  ResponsaveisSitioData copyWithCompanion(ResponsaveisSitioCompanion data) {
    return ResponsaveisSitioData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      bemMaterialId: data.bemMaterialId.present
          ? data.bemMaterialId.value
          : this.bemMaterialId,
      contatoNome: data.contatoNome.present
          ? data.contatoNome.value
          : this.contatoNome,
      contatoEmail: data.contatoEmail.present
          ? data.contatoEmail.value
          : this.contatoEmail,
      contatoTelefone: data.contatoTelefone.present
          ? data.contatoTelefone.value
          : this.contatoTelefone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResponsaveisSitioData(')
          ..write('uuid: $uuid, ')
          ..write('bemMaterialId: $bemMaterialId, ')
          ..write('contatoNome: $contatoNome, ')
          ..write('contatoEmail: $contatoEmail, ')
          ..write('contatoTelefone: $contatoTelefone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    bemMaterialId,
    contatoNome,
    contatoEmail,
    contatoTelefone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResponsaveisSitioData &&
          other.uuid == this.uuid &&
          other.bemMaterialId == this.bemMaterialId &&
          other.contatoNome == this.contatoNome &&
          other.contatoEmail == this.contatoEmail &&
          other.contatoTelefone == this.contatoTelefone);
}

class ResponsaveisSitioCompanion
    extends UpdateCompanion<ResponsaveisSitioData> {
  final Value<String> uuid;
  final Value<String> bemMaterialId;
  final Value<String> contatoNome;
  final Value<String?> contatoEmail;
  final Value<String?> contatoTelefone;
  final Value<int> rowid;
  const ResponsaveisSitioCompanion({
    this.uuid = const Value.absent(),
    this.bemMaterialId = const Value.absent(),
    this.contatoNome = const Value.absent(),
    this.contatoEmail = const Value.absent(),
    this.contatoTelefone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResponsaveisSitioCompanion.insert({
    required String uuid,
    required String bemMaterialId,
    required String contatoNome,
    this.contatoEmail = const Value.absent(),
    this.contatoTelefone = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       bemMaterialId = Value(bemMaterialId),
       contatoNome = Value(contatoNome);
  static Insertable<ResponsaveisSitioData> custom({
    Expression<String>? uuid,
    Expression<String>? bemMaterialId,
    Expression<String>? contatoNome,
    Expression<String>? contatoEmail,
    Expression<String>? contatoTelefone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (bemMaterialId != null) 'bem_material_id': bemMaterialId,
      if (contatoNome != null) 'contato_nome': contatoNome,
      if (contatoEmail != null) 'contato_email': contatoEmail,
      if (contatoTelefone != null) 'contato_telefone': contatoTelefone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResponsaveisSitioCompanion copyWith({
    Value<String>? uuid,
    Value<String>? bemMaterialId,
    Value<String>? contatoNome,
    Value<String?>? contatoEmail,
    Value<String?>? contatoTelefone,
    Value<int>? rowid,
  }) {
    return ResponsaveisSitioCompanion(
      uuid: uuid ?? this.uuid,
      bemMaterialId: bemMaterialId ?? this.bemMaterialId,
      contatoNome: contatoNome ?? this.contatoNome,
      contatoEmail: contatoEmail ?? this.contatoEmail,
      contatoTelefone: contatoTelefone ?? this.contatoTelefone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (bemMaterialId.present) {
      map['bem_material_id'] = Variable<String>(bemMaterialId.value);
    }
    if (contatoNome.present) {
      map['contato_nome'] = Variable<String>(contatoNome.value);
    }
    if (contatoEmail.present) {
      map['contato_email'] = Variable<String>(contatoEmail.value);
    }
    if (contatoTelefone.present) {
      map['contato_telefone'] = Variable<String>(contatoTelefone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResponsaveisSitioCompanion(')
          ..write('uuid: $uuid, ')
          ..write('bemMaterialId: $bemMaterialId, ')
          ..write('contatoNome: $contatoNome, ')
          ..write('contatoEmail: $contatoEmail, ')
          ..write('contatoTelefone: $contatoTelefone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditoriasTable extends Auditorias
    with TableInfo<$AuditoriasTable, Auditoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (uuid)',
    ),
  );
  static const VerificationMeta _entidadeTipoMeta = const VerificationMeta(
    'entidadeTipo',
  );
  @override
  late final GeneratedColumn<String> entidadeTipo = GeneratedColumn<String>(
    'entidade_tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entidadeIdMeta = const VerificationMeta(
    'entidadeId',
  );
  @override
  late final GeneratedColumn<String> entidadeId = GeneratedColumn<String>(
    'entidade_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _curadoriaIdMeta = const VerificationMeta(
    'curadoriaId',
  );
  @override
  late final GeneratedColumn<String> curadoriaId = GeneratedColumn<String>(
    'curadoria_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES curadorias (uuid)',
    ),
  );
  static const VerificationMeta _operacaoMeta = const VerificationMeta(
    'operacao',
  );
  @override
  late final GeneratedColumn<String> operacao = GeneratedColumn<String>(
    'operacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meioMeta = const VerificationMeta('meio');
  @override
  late final GeneratedColumn<String> meio = GeneratedColumn<String>(
    'meio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  valorAnterior =
      GeneratedColumn<String>(
        'valor_anterior',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, Object?>?>(
        $AuditoriasTable.$convertervalorAnteriorn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  valorNovo = GeneratedColumn<String>(
    'valor_novo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, Object?>?>($AuditoriasTable.$convertervalorNovon);
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    usuarioId,
    entidadeTipo,
    entidadeId,
    curadoriaId,
    operacao,
    meio,
    dataHora,
    valorAnterior,
    valorNovo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auditorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Auditoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('entidade_tipo')) {
      context.handle(
        _entidadeTipoMeta,
        entidadeTipo.isAcceptableOrUnknown(
          data['entidade_tipo']!,
          _entidadeTipoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entidadeTipoMeta);
    }
    if (data.containsKey('entidade_id')) {
      context.handle(
        _entidadeIdMeta,
        entidadeId.isAcceptableOrUnknown(data['entidade_id']!, _entidadeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entidadeIdMeta);
    }
    if (data.containsKey('curadoria_id')) {
      context.handle(
        _curadoriaIdMeta,
        curadoriaId.isAcceptableOrUnknown(
          data['curadoria_id']!,
          _curadoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('operacao')) {
      context.handle(
        _operacaoMeta,
        operacao.isAcceptableOrUnknown(data['operacao']!, _operacaoMeta),
      );
    } else if (isInserting) {
      context.missing(_operacaoMeta);
    }
    if (data.containsKey('meio')) {
      context.handle(
        _meioMeta,
        meio.isAcceptableOrUnknown(data['meio']!, _meioMeta),
      );
    } else if (isInserting) {
      context.missing(_meioMeta);
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  Auditoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Auditoria(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      entidadeTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entidade_tipo'],
      )!,
      entidadeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entidade_id'],
      )!,
      curadoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}curadoria_id'],
      ),
      operacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operacao'],
      )!,
      meio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meio'],
      )!,
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      valorAnterior: $AuditoriasTable.$convertervalorAnteriorn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}valor_anterior'],
        ),
      ),
      valorNovo: $AuditoriasTable.$convertervalorNovon.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}valor_novo'],
        ),
      ),
    );
  }

  @override
  $AuditoriasTable createAlias(String alias) {
    return $AuditoriasTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, Object?>, String> $convertervalorAnterior =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>?, String?>
  $convertervalorAnteriorn = NullAwareTypeConverter.wrap(
    $convertervalorAnterior,
  );
  static TypeConverter<Map<String, Object?>, String> $convertervalorNovo =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>?, String?> $convertervalorNovon =
      NullAwareTypeConverter.wrap($convertervalorNovo);
}

class Auditoria extends DataClass implements Insertable<Auditoria> {
  final String uuid;
  final String usuarioId;
  final String entidadeTipo;
  final String entidadeId;
  final String? curadoriaId;
  final String operacao;
  final String meio;
  final DateTime dataHora;
  final Map<String, Object?>? valorAnterior;
  final Map<String, Object?>? valorNovo;
  const Auditoria({
    required this.uuid,
    required this.usuarioId,
    required this.entidadeTipo,
    required this.entidadeId,
    this.curadoriaId,
    required this.operacao,
    required this.meio,
    required this.dataHora,
    this.valorAnterior,
    this.valorNovo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['entidade_tipo'] = Variable<String>(entidadeTipo);
    map['entidade_id'] = Variable<String>(entidadeId);
    if (!nullToAbsent || curadoriaId != null) {
      map['curadoria_id'] = Variable<String>(curadoriaId);
    }
    map['operacao'] = Variable<String>(operacao);
    map['meio'] = Variable<String>(meio);
    map['data_hora'] = Variable<DateTime>(dataHora);
    if (!nullToAbsent || valorAnterior != null) {
      map['valor_anterior'] = Variable<String>(
        $AuditoriasTable.$convertervalorAnteriorn.toSql(valorAnterior),
      );
    }
    if (!nullToAbsent || valorNovo != null) {
      map['valor_novo'] = Variable<String>(
        $AuditoriasTable.$convertervalorNovon.toSql(valorNovo),
      );
    }
    return map;
  }

  AuditoriasCompanion toCompanion(bool nullToAbsent) {
    return AuditoriasCompanion(
      uuid: Value(uuid),
      usuarioId: Value(usuarioId),
      entidadeTipo: Value(entidadeTipo),
      entidadeId: Value(entidadeId),
      curadoriaId: curadoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(curadoriaId),
      operacao: Value(operacao),
      meio: Value(meio),
      dataHora: Value(dataHora),
      valorAnterior: valorAnterior == null && nullToAbsent
          ? const Value.absent()
          : Value(valorAnterior),
      valorNovo: valorNovo == null && nullToAbsent
          ? const Value.absent()
          : Value(valorNovo),
    );
  }

  factory Auditoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Auditoria(
      uuid: serializer.fromJson<String>(json['uuid']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      entidadeTipo: serializer.fromJson<String>(json['entidadeTipo']),
      entidadeId: serializer.fromJson<String>(json['entidadeId']),
      curadoriaId: serializer.fromJson<String?>(json['curadoriaId']),
      operacao: serializer.fromJson<String>(json['operacao']),
      meio: serializer.fromJson<String>(json['meio']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      valorAnterior: serializer.fromJson<Map<String, Object?>?>(
        json['valorAnterior'],
      ),
      valorNovo: serializer.fromJson<Map<String, Object?>?>(json['valorNovo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'entidadeTipo': serializer.toJson<String>(entidadeTipo),
      'entidadeId': serializer.toJson<String>(entidadeId),
      'curadoriaId': serializer.toJson<String?>(curadoriaId),
      'operacao': serializer.toJson<String>(operacao),
      'meio': serializer.toJson<String>(meio),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'valorAnterior': serializer.toJson<Map<String, Object?>?>(valorAnterior),
      'valorNovo': serializer.toJson<Map<String, Object?>?>(valorNovo),
    };
  }

  Auditoria copyWith({
    String? uuid,
    String? usuarioId,
    String? entidadeTipo,
    String? entidadeId,
    Value<String?> curadoriaId = const Value.absent(),
    String? operacao,
    String? meio,
    DateTime? dataHora,
    Value<Map<String, Object?>?> valorAnterior = const Value.absent(),
    Value<Map<String, Object?>?> valorNovo = const Value.absent(),
  }) => Auditoria(
    uuid: uuid ?? this.uuid,
    usuarioId: usuarioId ?? this.usuarioId,
    entidadeTipo: entidadeTipo ?? this.entidadeTipo,
    entidadeId: entidadeId ?? this.entidadeId,
    curadoriaId: curadoriaId.present ? curadoriaId.value : this.curadoriaId,
    operacao: operacao ?? this.operacao,
    meio: meio ?? this.meio,
    dataHora: dataHora ?? this.dataHora,
    valorAnterior: valorAnterior.present
        ? valorAnterior.value
        : this.valorAnterior,
    valorNovo: valorNovo.present ? valorNovo.value : this.valorNovo,
  );
  Auditoria copyWithCompanion(AuditoriasCompanion data) {
    return Auditoria(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      entidadeTipo: data.entidadeTipo.present
          ? data.entidadeTipo.value
          : this.entidadeTipo,
      entidadeId: data.entidadeId.present
          ? data.entidadeId.value
          : this.entidadeId,
      curadoriaId: data.curadoriaId.present
          ? data.curadoriaId.value
          : this.curadoriaId,
      operacao: data.operacao.present ? data.operacao.value : this.operacao,
      meio: data.meio.present ? data.meio.value : this.meio,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      valorAnterior: data.valorAnterior.present
          ? data.valorAnterior.value
          : this.valorAnterior,
      valorNovo: data.valorNovo.present ? data.valorNovo.value : this.valorNovo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Auditoria(')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('entidadeTipo: $entidadeTipo, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('curadoriaId: $curadoriaId, ')
          ..write('operacao: $operacao, ')
          ..write('meio: $meio, ')
          ..write('dataHora: $dataHora, ')
          ..write('valorAnterior: $valorAnterior, ')
          ..write('valorNovo: $valorNovo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    usuarioId,
    entidadeTipo,
    entidadeId,
    curadoriaId,
    operacao,
    meio,
    dataHora,
    valorAnterior,
    valorNovo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Auditoria &&
          other.uuid == this.uuid &&
          other.usuarioId == this.usuarioId &&
          other.entidadeTipo == this.entidadeTipo &&
          other.entidadeId == this.entidadeId &&
          other.curadoriaId == this.curadoriaId &&
          other.operacao == this.operacao &&
          other.meio == this.meio &&
          other.dataHora == this.dataHora &&
          other.valorAnterior == this.valorAnterior &&
          other.valorNovo == this.valorNovo);
}

class AuditoriasCompanion extends UpdateCompanion<Auditoria> {
  final Value<String> uuid;
  final Value<String> usuarioId;
  final Value<String> entidadeTipo;
  final Value<String> entidadeId;
  final Value<String?> curadoriaId;
  final Value<String> operacao;
  final Value<String> meio;
  final Value<DateTime> dataHora;
  final Value<Map<String, Object?>?> valorAnterior;
  final Value<Map<String, Object?>?> valorNovo;
  final Value<int> rowid;
  const AuditoriasCompanion({
    this.uuid = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.entidadeTipo = const Value.absent(),
    this.entidadeId = const Value.absent(),
    this.curadoriaId = const Value.absent(),
    this.operacao = const Value.absent(),
    this.meio = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.valorAnterior = const Value.absent(),
    this.valorNovo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditoriasCompanion.insert({
    required String uuid,
    required String usuarioId,
    required String entidadeTipo,
    required String entidadeId,
    this.curadoriaId = const Value.absent(),
    required String operacao,
    required String meio,
    this.dataHora = const Value.absent(),
    this.valorAnterior = const Value.absent(),
    this.valorNovo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       usuarioId = Value(usuarioId),
       entidadeTipo = Value(entidadeTipo),
       entidadeId = Value(entidadeId),
       operacao = Value(operacao),
       meio = Value(meio);
  static Insertable<Auditoria> custom({
    Expression<String>? uuid,
    Expression<String>? usuarioId,
    Expression<String>? entidadeTipo,
    Expression<String>? entidadeId,
    Expression<String>? curadoriaId,
    Expression<String>? operacao,
    Expression<String>? meio,
    Expression<DateTime>? dataHora,
    Expression<String>? valorAnterior,
    Expression<String>? valorNovo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (entidadeTipo != null) 'entidade_tipo': entidadeTipo,
      if (entidadeId != null) 'entidade_id': entidadeId,
      if (curadoriaId != null) 'curadoria_id': curadoriaId,
      if (operacao != null) 'operacao': operacao,
      if (meio != null) 'meio': meio,
      if (dataHora != null) 'data_hora': dataHora,
      if (valorAnterior != null) 'valor_anterior': valorAnterior,
      if (valorNovo != null) 'valor_novo': valorNovo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditoriasCompanion copyWith({
    Value<String>? uuid,
    Value<String>? usuarioId,
    Value<String>? entidadeTipo,
    Value<String>? entidadeId,
    Value<String?>? curadoriaId,
    Value<String>? operacao,
    Value<String>? meio,
    Value<DateTime>? dataHora,
    Value<Map<String, Object?>?>? valorAnterior,
    Value<Map<String, Object?>?>? valorNovo,
    Value<int>? rowid,
  }) {
    return AuditoriasCompanion(
      uuid: uuid ?? this.uuid,
      usuarioId: usuarioId ?? this.usuarioId,
      entidadeTipo: entidadeTipo ?? this.entidadeTipo,
      entidadeId: entidadeId ?? this.entidadeId,
      curadoriaId: curadoriaId ?? this.curadoriaId,
      operacao: operacao ?? this.operacao,
      meio: meio ?? this.meio,
      dataHora: dataHora ?? this.dataHora,
      valorAnterior: valorAnterior ?? this.valorAnterior,
      valorNovo: valorNovo ?? this.valorNovo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (entidadeTipo.present) {
      map['entidade_tipo'] = Variable<String>(entidadeTipo.value);
    }
    if (entidadeId.present) {
      map['entidade_id'] = Variable<String>(entidadeId.value);
    }
    if (curadoriaId.present) {
      map['curadoria_id'] = Variable<String>(curadoriaId.value);
    }
    if (operacao.present) {
      map['operacao'] = Variable<String>(operacao.value);
    }
    if (meio.present) {
      map['meio'] = Variable<String>(meio.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (valorAnterior.present) {
      map['valor_anterior'] = Variable<String>(
        $AuditoriasTable.$convertervalorAnteriorn.toSql(valorAnterior.value),
      );
    }
    if (valorNovo.present) {
      map['valor_novo'] = Variable<String>(
        $AuditoriasTable.$convertervalorNovon.toSql(valorNovo.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriasCompanion(')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('entidadeTipo: $entidadeTipo, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('curadoriaId: $curadoriaId, ')
          ..write('operacao: $operacao, ')
          ..write('meio: $meio, ')
          ..write('dataHora: $dataHora, ')
          ..write('valorAnterior: $valorAnterior, ')
          ..write('valorNovo: $valorNovo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ColetasTable coletas = $ColetasTable(this);
  late final $BensMateriaisTable bensMateriais = $BensMateriaisTable(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $CuradoriasTable curadorias = $CuradoriasTable(this);
  late final $MidiaLinksTable midiaLinks = $MidiaLinksTable(this);
  late final $ResponsaveisSitioTable responsaveisSitio =
      $ResponsaveisSitioTable(this);
  late final $AuditoriasTable auditorias = $AuditoriasTable(this);
  late final Index coletasUsuarioIdx = Index(
    'coletas_usuario_idx',
    'CREATE INDEX coletas_usuario_idx ON coletas (usuario_id)',
  );
  late final Index coletasSincronizadaIdx = Index(
    'coletas_sincronizada_idx',
    'CREATE INDEX coletas_sincronizada_idx ON coletas (status_sincronizacao)',
  );
  late final Index coletasNaturezaIdx = Index(
    'coletas_natureza_idx',
    'CREATE INDEX coletas_natureza_idx ON coletas (natureza)',
  );
  late final Index coletasUfIdx = Index(
    'coletas_uf_idx',
    'CREATE INDEX coletas_uf_idx ON coletas (uf)',
  );
  late final Index bensColetaIdx = Index(
    'bens_coleta_idx',
    'CREATE INDEX bens_coleta_idx ON bens_materiais (coleta_id)',
  );
  late final Index municipio = Index(
    'municipio',
    'CREATE INDEX municipio ON bens_materiais (municipio)',
  );
  late final Index bensNaturezaIdx = Index(
    'bens_natureza_idx',
    'CREATE INDEX bens_natureza_idx ON bens_materiais (natureza)',
  );
  late final Index bensTipoIdx = Index(
    'bens_tipo_idx',
    'CREATE INDEX bens_tipo_idx ON bens_materiais (tipo)',
  );
  late final Index bensUfIdx = Index(
    'bens_uf_idx',
    'CREATE INDEX bens_uf_idx ON bens_materiais (uf)',
  );
  late final Index status = Index(
    'status',
    'CREATE INDEX status ON curadorias (status_curadoria)',
  );
  late final Index curadoriasColetaIdx = Index(
    'curadorias_coleta_idx',
    'CREATE INDEX curadorias_coleta_idx ON curadorias (coleta_id)',
  );
  late final Index auditoriasUsuarioIdx = Index(
    'auditorias_usuario_idx',
    'CREATE INDEX auditorias_usuario_idx ON auditorias (usuario_id)',
  );
  late final Index entidadeTipo = Index(
    'entidade_tipo',
    'CREATE INDEX entidade_tipo ON auditorias (entidade_tipo)',
  );
  late final Index entidadeId = Index(
    'entidade_id',
    'CREATE INDEX entidade_id ON auditorias (entidade_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    coletas,
    bensMateriais,
    usuarios,
    curadorias,
    midiaLinks,
    responsaveisSitio,
    auditorias,
    coletasUsuarioIdx,
    coletasSincronizadaIdx,
    coletasNaturezaIdx,
    coletasUfIdx,
    bensColetaIdx,
    municipio,
    bensNaturezaIdx,
    bensTipoIdx,
    bensUfIdx,
    status,
    curadoriasColetaIdx,
    auditoriasUsuarioIdx,
    entidadeTipo,
    entidadeId,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ColetasTableCreateCompanionBuilder =
    ColetasCompanion Function({
      required String uuid,
      required String usuarioId,
      Value<DateTime> dataColeta,
      Value<StatusColeta> statusSincronizacao,
      Value<String> nomeBem,
      Value<String?> natureza,
      Value<String?> tipo,
      Value<String?> uf,
      Value<double> latitude,
      Value<double> longitude,
      Value<List<String>> artefatos,
      Value<int> versao,
      Value<DateTime> updatedAt,
      required Map<String, Object?> dadosColetados,
      Value<DateTime?> deletadoEm,
      Value<int> rowid,
    });
typedef $$ColetasTableUpdateCompanionBuilder =
    ColetasCompanion Function({
      Value<String> uuid,
      Value<String> usuarioId,
      Value<DateTime> dataColeta,
      Value<StatusColeta> statusSincronizacao,
      Value<String> nomeBem,
      Value<String?> natureza,
      Value<String?> tipo,
      Value<String?> uf,
      Value<double> latitude,
      Value<double> longitude,
      Value<List<String>> artefatos,
      Value<int> versao,
      Value<DateTime> updatedAt,
      Value<Map<String, Object?>> dadosColetados,
      Value<DateTime?> deletadoEm,
      Value<int> rowid,
    });

final class $$ColetasTableReferences
    extends BaseReferences<_$AppDatabase, $ColetasTable, Coleta> {
  $$ColetasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BensMateriaisTable, List<BensMateriai>>
  _bensMateriaisRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bensMateriais,
    aliasName: $_aliasNameGenerator(db.coletas.uuid, db.bensMateriais.coletaId),
  );

  $$BensMateriaisTableProcessedTableManager get bensMateriaisRefs {
    final manager = $$BensMateriaisTableTableManager(
      $_db,
      $_db.bensMateriais,
    ).filter((f) => f.coletaId.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache = $_typedResult.readTableOrNull(_bensMateriaisRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CuradoriasTable, List<Curadoria>>
  _curadoriasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.curadorias,
    aliasName: $_aliasNameGenerator(db.coletas.uuid, db.curadorias.coletaId),
  );

  $$CuradoriasTableProcessedTableManager get curadoriasRefs {
    final manager = $$CuradoriasTableTableManager(
      $_db,
      $_db.curadorias,
    ).filter((f) => f.coletaId.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache = $_typedResult.readTableOrNull(_curadoriasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ColetasTableFilterComposer
    extends Composer<_$AppDatabase, $ColetasTable> {
  $$ColetasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataColeta => $composableBuilder(
    column: $table.dataColeta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StatusColeta, StatusColeta, String>
  get statusSincronizacao => $composableBuilder(
    column: $table.statusSincronizacao,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get nomeBem => $composableBuilder(
    column: $table.nomeBem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get natureza => $composableBuilder(
    column: $table.natureza,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uf => $composableBuilder(
    column: $table.uf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get artefatos => $composableBuilder(
    column: $table.artefatos,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get versao => $composableBuilder(
    column: $table.versao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get dadosColetados => $composableBuilder(
    column: $table.dadosColetados,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get deletadoEm => $composableBuilder(
    column: $table.deletadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bensMateriaisRefs(
    Expression<bool> Function($$BensMateriaisTableFilterComposer f) f,
  ) {
    final $$BensMateriaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.coletaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableFilterComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> curadoriasRefs(
    Expression<bool> Function($$CuradoriasTableFilterComposer f) f,
  ) {
    final $$CuradoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.coletaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableFilterComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ColetasTableOrderingComposer
    extends Composer<_$AppDatabase, $ColetasTable> {
  $$ColetasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataColeta => $composableBuilder(
    column: $table.dataColeta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusSincronizacao => $composableBuilder(
    column: $table.statusSincronizacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeBem => $composableBuilder(
    column: $table.nomeBem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get natureza => $composableBuilder(
    column: $table.natureza,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uf => $composableBuilder(
    column: $table.uf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artefatos => $composableBuilder(
    column: $table.artefatos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versao => $composableBuilder(
    column: $table.versao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dadosColetados => $composableBuilder(
    column: $table.dadosColetados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletadoEm => $composableBuilder(
    column: $table.deletadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ColetasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ColetasTable> {
  $$ColetasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get dataColeta => $composableBuilder(
    column: $table.dataColeta,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StatusColeta, String>
  get statusSincronizacao => $composableBuilder(
    column: $table.statusSincronizacao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nomeBem =>
      $composableBuilder(column: $table.nomeBem, builder: (column) => column);

  GeneratedColumn<String> get natureza =>
      $composableBuilder(column: $table.natureza, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get uf =>
      $composableBuilder(column: $table.uf, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get artefatos =>
      $composableBuilder(column: $table.artefatos, builder: (column) => column);

  GeneratedColumn<int> get versao =>
      $composableBuilder(column: $table.versao, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  get dadosColetados => $composableBuilder(
    column: $table.dadosColetados,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletadoEm => $composableBuilder(
    column: $table.deletadoEm,
    builder: (column) => column,
  );

  Expression<T> bensMateriaisRefs<T extends Object>(
    Expression<T> Function($$BensMateriaisTableAnnotationComposer a) f,
  ) {
    final $$BensMateriaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.coletaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableAnnotationComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> curadoriasRefs<T extends Object>(
    Expression<T> Function($$CuradoriasTableAnnotationComposer a) f,
  ) {
    final $$CuradoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.coletaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ColetasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ColetasTable,
          Coleta,
          $$ColetasTableFilterComposer,
          $$ColetasTableOrderingComposer,
          $$ColetasTableAnnotationComposer,
          $$ColetasTableCreateCompanionBuilder,
          $$ColetasTableUpdateCompanionBuilder,
          (Coleta, $$ColetasTableReferences),
          Coleta,
          PrefetchHooks Function({bool bensMateriaisRefs, bool curadoriasRefs})
        > {
  $$ColetasTableTableManager(_$AppDatabase db, $ColetasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ColetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ColetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ColetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> dataColeta = const Value.absent(),
                Value<StatusColeta> statusSincronizacao = const Value.absent(),
                Value<String> nomeBem = const Value.absent(),
                Value<String?> natureza = const Value.absent(),
                Value<String?> tipo = const Value.absent(),
                Value<String?> uf = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<List<String>> artefatos = const Value.absent(),
                Value<int> versao = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<Map<String, Object?>> dadosColetados =
                    const Value.absent(),
                Value<DateTime?> deletadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ColetasCompanion(
                uuid: uuid,
                usuarioId: usuarioId,
                dataColeta: dataColeta,
                statusSincronizacao: statusSincronizacao,
                nomeBem: nomeBem,
                natureza: natureza,
                tipo: tipo,
                uf: uf,
                latitude: latitude,
                longitude: longitude,
                artefatos: artefatos,
                versao: versao,
                updatedAt: updatedAt,
                dadosColetados: dadosColetados,
                deletadoEm: deletadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String usuarioId,
                Value<DateTime> dataColeta = const Value.absent(),
                Value<StatusColeta> statusSincronizacao = const Value.absent(),
                Value<String> nomeBem = const Value.absent(),
                Value<String?> natureza = const Value.absent(),
                Value<String?> tipo = const Value.absent(),
                Value<String?> uf = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<List<String>> artefatos = const Value.absent(),
                Value<int> versao = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required Map<String, Object?> dadosColetados,
                Value<DateTime?> deletadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ColetasCompanion.insert(
                uuid: uuid,
                usuarioId: usuarioId,
                dataColeta: dataColeta,
                statusSincronizacao: statusSincronizacao,
                nomeBem: nomeBem,
                natureza: natureza,
                tipo: tipo,
                uf: uf,
                latitude: latitude,
                longitude: longitude,
                artefatos: artefatos,
                versao: versao,
                updatedAt: updatedAt,
                dadosColetados: dadosColetados,
                deletadoEm: deletadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ColetasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bensMateriaisRefs = false, curadoriasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bensMateriaisRefs) db.bensMateriais,
                    if (curadoriasRefs) db.curadorias,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bensMateriaisRefs)
                        await $_getPrefetchedData<
                          Coleta,
                          $ColetasTable,
                          BensMateriai
                        >(
                          currentTable: table,
                          referencedTable: $$ColetasTableReferences
                              ._bensMateriaisRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ColetasTableReferences(
                                db,
                                table,
                                p0,
                              ).bensMateriaisRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.coletaId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                      if (curadoriasRefs)
                        await $_getPrefetchedData<
                          Coleta,
                          $ColetasTable,
                          Curadoria
                        >(
                          currentTable: table,
                          referencedTable: $$ColetasTableReferences
                              ._curadoriasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ColetasTableReferences(
                                db,
                                table,
                                p0,
                              ).curadoriasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.coletaId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ColetasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ColetasTable,
      Coleta,
      $$ColetasTableFilterComposer,
      $$ColetasTableOrderingComposer,
      $$ColetasTableAnnotationComposer,
      $$ColetasTableCreateCompanionBuilder,
      $$ColetasTableUpdateCompanionBuilder,
      (Coleta, $$ColetasTableReferences),
      Coleta,
      PrefetchHooks Function({bool bensMateriaisRefs, bool curadoriasRefs})
    >;
typedef $$BensMateriaisTableCreateCompanionBuilder =
    BensMateriaisCompanion Function({
      required String uuid,
      required String coletaId,
      Value<String?> codigoIphan,
      required String nomeBem,
      Value<String?> nomesPopulares,
      required String natureza,
      required String tipo,
      Value<String?> meiosAcesso,
      Value<List<String>> artefatos,
      Value<bool> publicado,
      Value<String?> uf,
      Value<String?> municipio,
      Value<String?> cep,
      Value<String?> endereco,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> geojson,
      Value<int?> anoRegistro,
      Value<String?> descricaoAtualizacao,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
      Value<DateTime?> deletadoEm,
      Value<int> rowid,
    });
typedef $$BensMateriaisTableUpdateCompanionBuilder =
    BensMateriaisCompanion Function({
      Value<String> uuid,
      Value<String> coletaId,
      Value<String?> codigoIphan,
      Value<String> nomeBem,
      Value<String?> nomesPopulares,
      Value<String> natureza,
      Value<String> tipo,
      Value<String?> meiosAcesso,
      Value<List<String>> artefatos,
      Value<bool> publicado,
      Value<String?> uf,
      Value<String?> municipio,
      Value<String?> cep,
      Value<String?> endereco,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> geojson,
      Value<int?> anoRegistro,
      Value<String?> descricaoAtualizacao,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
      Value<DateTime?> deletadoEm,
      Value<int> rowid,
    });

final class $$BensMateriaisTableReferences
    extends BaseReferences<_$AppDatabase, $BensMateriaisTable, BensMateriai> {
  $$BensMateriaisTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ColetasTable _coletaIdTable(_$AppDatabase db) =>
      db.coletas.createAlias(
        $_aliasNameGenerator(db.bensMateriais.coletaId, db.coletas.uuid),
      );

  $$ColetasTableProcessedTableManager get coletaId {
    final $_column = $_itemColumn<String>('coleta_id')!;

    final manager = $$ColetasTableTableManager(
      $_db,
      $_db.coletas,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coletaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CuradoriasTable, List<Curadoria>>
  _curadoriasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.curadorias,
    aliasName: $_aliasNameGenerator(
      db.bensMateriais.uuid,
      db.curadorias.bemMaterialId,
    ),
  );

  $$CuradoriasTableProcessedTableManager get curadoriasRefs {
    final manager = $$CuradoriasTableTableManager($_db, $_db.curadorias).filter(
      (f) => f.bemMaterialId.uuid.sqlEquals($_itemColumn<String>('uuid')!),
    );

    final cache = $_typedResult.readTableOrNull(_curadoriasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MidiaLinksTable, List<MidiaLink>>
  _midiaLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.midiaLinks,
    aliasName: $_aliasNameGenerator(
      db.bensMateriais.uuid,
      db.midiaLinks.bemMaterialId,
    ),
  );

  $$MidiaLinksTableProcessedTableManager get midiaLinksRefs {
    final manager = $$MidiaLinksTableTableManager($_db, $_db.midiaLinks).filter(
      (f) => f.bemMaterialId.uuid.sqlEquals($_itemColumn<String>('uuid')!),
    );

    final cache = $_typedResult.readTableOrNull(_midiaLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ResponsaveisSitioTable,
    List<ResponsaveisSitioData>
  >
  _responsaveisSitioRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.responsaveisSitio,
        aliasName: $_aliasNameGenerator(
          db.bensMateriais.uuid,
          db.responsaveisSitio.bemMaterialId,
        ),
      );

  $$ResponsaveisSitioTableProcessedTableManager get responsaveisSitioRefs {
    final manager =
        $$ResponsaveisSitioTableTableManager(
          $_db,
          $_db.responsaveisSitio,
        ).filter(
          (f) => f.bemMaterialId.uuid.sqlEquals($_itemColumn<String>('uuid')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _responsaveisSitioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BensMateriaisTableFilterComposer
    extends Composer<_$AppDatabase, $BensMateriaisTable> {
  $$BensMateriaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoIphan => $composableBuilder(
    column: $table.codigoIphan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeBem => $composableBuilder(
    column: $table.nomeBem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomesPopulares => $composableBuilder(
    column: $table.nomesPopulares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get natureza => $composableBuilder(
    column: $table.natureza,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meiosAcesso => $composableBuilder(
    column: $table.meiosAcesso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get artefatos => $composableBuilder(
    column: $table.artefatos,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get publicado => $composableBuilder(
    column: $table.publicado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uf => $composableBuilder(
    column: $table.uf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get municipio => $composableBuilder(
    column: $table.municipio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cep => $composableBuilder(
    column: $table.cep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geojson => $composableBuilder(
    column: $table.geojson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anoRegistro => $composableBuilder(
    column: $table.anoRegistro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricaoAtualizacao => $composableBuilder(
    column: $table.descricaoAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletadoEm => $composableBuilder(
    column: $table.deletadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ColetasTableFilterComposer get coletaId {
    final $$ColetasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coletaId,
      referencedTable: $db.coletas,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColetasTableFilterComposer(
            $db: $db,
            $table: $db.coletas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> curadoriasRefs(
    Expression<bool> Function($$CuradoriasTableFilterComposer f) f,
  ) {
    final $$CuradoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.bemMaterialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableFilterComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> midiaLinksRefs(
    Expression<bool> Function($$MidiaLinksTableFilterComposer f) f,
  ) {
    final $$MidiaLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.midiaLinks,
      getReferencedColumn: (t) => t.bemMaterialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MidiaLinksTableFilterComposer(
            $db: $db,
            $table: $db.midiaLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> responsaveisSitioRefs(
    Expression<bool> Function($$ResponsaveisSitioTableFilterComposer f) f,
  ) {
    final $$ResponsaveisSitioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.responsaveisSitio,
      getReferencedColumn: (t) => t.bemMaterialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResponsaveisSitioTableFilterComposer(
            $db: $db,
            $table: $db.responsaveisSitio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BensMateriaisTableOrderingComposer
    extends Composer<_$AppDatabase, $BensMateriaisTable> {
  $$BensMateriaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoIphan => $composableBuilder(
    column: $table.codigoIphan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeBem => $composableBuilder(
    column: $table.nomeBem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomesPopulares => $composableBuilder(
    column: $table.nomesPopulares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get natureza => $composableBuilder(
    column: $table.natureza,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meiosAcesso => $composableBuilder(
    column: $table.meiosAcesso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artefatos => $composableBuilder(
    column: $table.artefatos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get publicado => $composableBuilder(
    column: $table.publicado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uf => $composableBuilder(
    column: $table.uf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get municipio => $composableBuilder(
    column: $table.municipio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cep => $composableBuilder(
    column: $table.cep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geojson => $composableBuilder(
    column: $table.geojson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anoRegistro => $composableBuilder(
    column: $table.anoRegistro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricaoAtualizacao => $composableBuilder(
    column: $table.descricaoAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletadoEm => $composableBuilder(
    column: $table.deletadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ColetasTableOrderingComposer get coletaId {
    final $$ColetasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coletaId,
      referencedTable: $db.coletas,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColetasTableOrderingComposer(
            $db: $db,
            $table: $db.coletas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BensMateriaisTableAnnotationComposer
    extends Composer<_$AppDatabase, $BensMateriaisTable> {
  $$BensMateriaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get codigoIphan => $composableBuilder(
    column: $table.codigoIphan,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nomeBem =>
      $composableBuilder(column: $table.nomeBem, builder: (column) => column);

  GeneratedColumn<String> get nomesPopulares => $composableBuilder(
    column: $table.nomesPopulares,
    builder: (column) => column,
  );

  GeneratedColumn<String> get natureza =>
      $composableBuilder(column: $table.natureza, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get meiosAcesso => $composableBuilder(
    column: $table.meiosAcesso,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get artefatos =>
      $composableBuilder(column: $table.artefatos, builder: (column) => column);

  GeneratedColumn<bool> get publicado =>
      $composableBuilder(column: $table.publicado, builder: (column) => column);

  GeneratedColumn<String> get uf =>
      $composableBuilder(column: $table.uf, builder: (column) => column);

  GeneratedColumn<String> get municipio =>
      $composableBuilder(column: $table.municipio, builder: (column) => column);

  GeneratedColumn<String> get cep =>
      $composableBuilder(column: $table.cep, builder: (column) => column);

  GeneratedColumn<String> get endereco =>
      $composableBuilder(column: $table.endereco, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get geojson =>
      $composableBuilder(column: $table.geojson, builder: (column) => column);

  GeneratedColumn<int> get anoRegistro => $composableBuilder(
    column: $table.anoRegistro,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descricaoAtualizacao => $composableBuilder(
    column: $table.descricaoAtualizacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletadoEm => $composableBuilder(
    column: $table.deletadoEm,
    builder: (column) => column,
  );

  $$ColetasTableAnnotationComposer get coletaId {
    final $$ColetasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coletaId,
      referencedTable: $db.coletas,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColetasTableAnnotationComposer(
            $db: $db,
            $table: $db.coletas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> curadoriasRefs<T extends Object>(
    Expression<T> Function($$CuradoriasTableAnnotationComposer a) f,
  ) {
    final $$CuradoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.bemMaterialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> midiaLinksRefs<T extends Object>(
    Expression<T> Function($$MidiaLinksTableAnnotationComposer a) f,
  ) {
    final $$MidiaLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.midiaLinks,
      getReferencedColumn: (t) => t.bemMaterialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MidiaLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.midiaLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> responsaveisSitioRefs<T extends Object>(
    Expression<T> Function($$ResponsaveisSitioTableAnnotationComposer a) f,
  ) {
    final $$ResponsaveisSitioTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.uuid,
          referencedTable: $db.responsaveisSitio,
          getReferencedColumn: (t) => t.bemMaterialId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ResponsaveisSitioTableAnnotationComposer(
                $db: $db,
                $table: $db.responsaveisSitio,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BensMateriaisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BensMateriaisTable,
          BensMateriai,
          $$BensMateriaisTableFilterComposer,
          $$BensMateriaisTableOrderingComposer,
          $$BensMateriaisTableAnnotationComposer,
          $$BensMateriaisTableCreateCompanionBuilder,
          $$BensMateriaisTableUpdateCompanionBuilder,
          (BensMateriai, $$BensMateriaisTableReferences),
          BensMateriai,
          PrefetchHooks Function({
            bool coletaId,
            bool curadoriasRefs,
            bool midiaLinksRefs,
            bool responsaveisSitioRefs,
          })
        > {
  $$BensMateriaisTableTableManager(_$AppDatabase db, $BensMateriaisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BensMateriaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BensMateriaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BensMateriaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> coletaId = const Value.absent(),
                Value<String?> codigoIphan = const Value.absent(),
                Value<String> nomeBem = const Value.absent(),
                Value<String?> nomesPopulares = const Value.absent(),
                Value<String> natureza = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> meiosAcesso = const Value.absent(),
                Value<List<String>> artefatos = const Value.absent(),
                Value<bool> publicado = const Value.absent(),
                Value<String?> uf = const Value.absent(),
                Value<String?> municipio = const Value.absent(),
                Value<String?> cep = const Value.absent(),
                Value<String?> endereco = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> geojson = const Value.absent(),
                Value<int?> anoRegistro = const Value.absent(),
                Value<String?> descricaoAtualizacao = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> deletadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BensMateriaisCompanion(
                uuid: uuid,
                coletaId: coletaId,
                codigoIphan: codigoIphan,
                nomeBem: nomeBem,
                nomesPopulares: nomesPopulares,
                natureza: natureza,
                tipo: tipo,
                meiosAcesso: meiosAcesso,
                artefatos: artefatos,
                publicado: publicado,
                uf: uf,
                municipio: municipio,
                cep: cep,
                endereco: endereco,
                latitude: latitude,
                longitude: longitude,
                geojson: geojson,
                anoRegistro: anoRegistro,
                descricaoAtualizacao: descricaoAtualizacao,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
                deletadoEm: deletadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String coletaId,
                Value<String?> codigoIphan = const Value.absent(),
                required String nomeBem,
                Value<String?> nomesPopulares = const Value.absent(),
                required String natureza,
                required String tipo,
                Value<String?> meiosAcesso = const Value.absent(),
                Value<List<String>> artefatos = const Value.absent(),
                Value<bool> publicado = const Value.absent(),
                Value<String?> uf = const Value.absent(),
                Value<String?> municipio = const Value.absent(),
                Value<String?> cep = const Value.absent(),
                Value<String?> endereco = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> geojson = const Value.absent(),
                Value<int?> anoRegistro = const Value.absent(),
                Value<String?> descricaoAtualizacao = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> deletadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BensMateriaisCompanion.insert(
                uuid: uuid,
                coletaId: coletaId,
                codigoIphan: codigoIphan,
                nomeBem: nomeBem,
                nomesPopulares: nomesPopulares,
                natureza: natureza,
                tipo: tipo,
                meiosAcesso: meiosAcesso,
                artefatos: artefatos,
                publicado: publicado,
                uf: uf,
                municipio: municipio,
                cep: cep,
                endereco: endereco,
                latitude: latitude,
                longitude: longitude,
                geojson: geojson,
                anoRegistro: anoRegistro,
                descricaoAtualizacao: descricaoAtualizacao,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
                deletadoEm: deletadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BensMateriaisTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                coletaId = false,
                curadoriasRefs = false,
                midiaLinksRefs = false,
                responsaveisSitioRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (curadoriasRefs) db.curadorias,
                    if (midiaLinksRefs) db.midiaLinks,
                    if (responsaveisSitioRefs) db.responsaveisSitio,
                  ],
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
                        if (coletaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.coletaId,
                                    referencedTable:
                                        $$BensMateriaisTableReferences
                                            ._coletaIdTable(db),
                                    referencedColumn:
                                        $$BensMateriaisTableReferences
                                            ._coletaIdTable(db)
                                            .uuid,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (curadoriasRefs)
                        await $_getPrefetchedData<
                          BensMateriai,
                          $BensMateriaisTable,
                          Curadoria
                        >(
                          currentTable: table,
                          referencedTable: $$BensMateriaisTableReferences
                              ._curadoriasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BensMateriaisTableReferences(
                                db,
                                table,
                                p0,
                              ).curadoriasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bemMaterialId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                      if (midiaLinksRefs)
                        await $_getPrefetchedData<
                          BensMateriai,
                          $BensMateriaisTable,
                          MidiaLink
                        >(
                          currentTable: table,
                          referencedTable: $$BensMateriaisTableReferences
                              ._midiaLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BensMateriaisTableReferences(
                                db,
                                table,
                                p0,
                              ).midiaLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bemMaterialId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                      if (responsaveisSitioRefs)
                        await $_getPrefetchedData<
                          BensMateriai,
                          $BensMateriaisTable,
                          ResponsaveisSitioData
                        >(
                          currentTable: table,
                          referencedTable: $$BensMateriaisTableReferences
                              ._responsaveisSitioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BensMateriaisTableReferences(
                                db,
                                table,
                                p0,
                              ).responsaveisSitioRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bemMaterialId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BensMateriaisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BensMateriaisTable,
      BensMateriai,
      $$BensMateriaisTableFilterComposer,
      $$BensMateriaisTableOrderingComposer,
      $$BensMateriaisTableAnnotationComposer,
      $$BensMateriaisTableCreateCompanionBuilder,
      $$BensMateriaisTableUpdateCompanionBuilder,
      (BensMateriai, $$BensMateriaisTableReferences),
      BensMateriai,
      PrefetchHooks Function({
        bool coletaId,
        bool curadoriasRefs,
        bool midiaLinksRefs,
        bool responsaveisSitioRefs,
      })
    >;
typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      required String uuid,
      required String nome,
      required String email,
      required String senhaHash,
      Value<PerfilUsuario> perfil,
      Value<ClassificacaoUsuario> classificacao,
      Value<bool> ativo,
      Value<DateTime> criadoEm,
      Value<int> rowid,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<String> uuid,
      Value<String> nome,
      Value<String> email,
      Value<String> senhaHash,
      Value<PerfilUsuario> perfil,
      Value<ClassificacaoUsuario> classificacao,
      Value<bool> ativo,
      Value<DateTime> criadoEm,
      Value<int> rowid,
    });

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CuradoriasTable, List<Curadoria>>
  _curadoriasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.curadorias,
    aliasName: $_aliasNameGenerator(db.usuarios.uuid, db.curadorias.usuarioId),
  );

  $$CuradoriasTableProcessedTableManager get curadoriasRefs {
    final manager = $$CuradoriasTableTableManager(
      $_db,
      $_db.curadorias,
    ).filter((f) => f.usuarioId.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache = $_typedResult.readTableOrNull(_curadoriasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AuditoriasTable, List<Auditoria>>
  _auditoriasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditorias,
    aliasName: $_aliasNameGenerator(db.usuarios.uuid, db.auditorias.usuarioId),
  );

  $$AuditoriasTableProcessedTableManager get auditoriasRefs {
    final manager = $$AuditoriasTableTableManager(
      $_db,
      $_db.auditorias,
    ).filter((f) => f.usuarioId.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache = $_typedResult.readTableOrNull(_auditoriasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senhaHash => $composableBuilder(
    column: $table.senhaHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PerfilUsuario, PerfilUsuario, String>
  get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    ClassificacaoUsuario,
    ClassificacaoUsuario,
    String
  >
  get classificacao => $composableBuilder(
    column: $table.classificacao,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> curadoriasRefs(
    Expression<bool> Function($$CuradoriasTableFilterComposer f) f,
  ) {
    final $$CuradoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableFilterComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> auditoriasRefs(
    Expression<bool> Function($$AuditoriasTableFilterComposer f) f,
  ) {
    final $$AuditoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.auditorias,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditoriasTableFilterComposer(
            $db: $db,
            $table: $db.auditorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senhaHash => $composableBuilder(
    column: $table.senhaHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classificacao => $composableBuilder(
    column: $table.classificacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get senhaHash =>
      $composableBuilder(column: $table.senhaHash, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PerfilUsuario, String> get perfil =>
      $composableBuilder(column: $table.perfil, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ClassificacaoUsuario, String>
  get classificacao => $composableBuilder(
    column: $table.classificacao,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> curadoriasRefs<T extends Object>(
    Expression<T> Function($$CuradoriasTableAnnotationComposer a) f,
  ) {
    final $$CuradoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> auditoriasRefs<T extends Object>(
    Expression<T> Function($$AuditoriasTableAnnotationComposer a) f,
  ) {
    final $$AuditoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.auditorias,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.auditorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, $$UsuariosTableReferences),
          Usuario,
          PrefetchHooks Function({bool curadoriasRefs, bool auditoriasRefs})
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> senhaHash = const Value.absent(),
                Value<PerfilUsuario> perfil = const Value.absent(),
                Value<ClassificacaoUsuario> classificacao =
                    const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion(
                uuid: uuid,
                nome: nome,
                email: email,
                senhaHash: senhaHash,
                perfil: perfil,
                classificacao: classificacao,
                ativo: ativo,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String nome,
                required String email,
                required String senhaHash,
                Value<PerfilUsuario> perfil = const Value.absent(),
                Value<ClassificacaoUsuario> classificacao =
                    const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion.insert(
                uuid: uuid,
                nome: nome,
                email: email,
                senhaHash: senhaHash,
                perfil: perfil,
                classificacao: classificacao,
                ativo: ativo,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({curadoriasRefs = false, auditoriasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (curadoriasRefs) db.curadorias,
                    if (auditoriasRefs) db.auditorias,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (curadoriasRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          Curadoria
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._curadoriasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).curadoriasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                      if (auditoriasRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          Auditoria
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._auditoriasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).auditoriasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, $$UsuariosTableReferences),
      Usuario,
      PrefetchHooks Function({bool curadoriasRefs, bool auditoriasRefs})
    >;
typedef $$CuradoriasTableCreateCompanionBuilder =
    CuradoriasCompanion Function({
      required String uuid,
      required String coletaId,
      Value<String?> bemMaterialId,
      required String usuarioId,
      Value<StatusCuradoria> status,
      Value<AcaoResultanteCuradoria> acaoResultante,
      Value<DateTime> dataAvaliacao,
      Value<String?> observacao,
      Value<int> rowid,
    });
typedef $$CuradoriasTableUpdateCompanionBuilder =
    CuradoriasCompanion Function({
      Value<String> uuid,
      Value<String> coletaId,
      Value<String?> bemMaterialId,
      Value<String> usuarioId,
      Value<StatusCuradoria> status,
      Value<AcaoResultanteCuradoria> acaoResultante,
      Value<DateTime> dataAvaliacao,
      Value<String?> observacao,
      Value<int> rowid,
    });

final class $$CuradoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CuradoriasTable, Curadoria> {
  $$CuradoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ColetasTable _coletaIdTable(_$AppDatabase db) =>
      db.coletas.createAlias(
        $_aliasNameGenerator(db.curadorias.coletaId, db.coletas.uuid),
      );

  $$ColetasTableProcessedTableManager get coletaId {
    final $_column = $_itemColumn<String>('coleta_id')!;

    final manager = $$ColetasTableTableManager(
      $_db,
      $_db.coletas,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coletaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BensMateriaisTable _bemMaterialIdTable(_$AppDatabase db) =>
      db.bensMateriais.createAlias(
        $_aliasNameGenerator(
          db.curadorias.bemMaterialId,
          db.bensMateriais.uuid,
        ),
      );

  $$BensMateriaisTableProcessedTableManager? get bemMaterialId {
    final $_column = $_itemColumn<String>('bem_material_id');
    if ($_column == null) return null;
    final manager = $$BensMateriaisTableTableManager(
      $_db,
      $_db.bensMateriais,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bemMaterialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.curadorias.usuarioId, db.usuarios.uuid),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<String>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AuditoriasTable, List<Auditoria>>
  _auditoriasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditorias,
    aliasName: $_aliasNameGenerator(
      db.curadorias.uuid,
      db.auditorias.curadoriaId,
    ),
  );

  $$AuditoriasTableProcessedTableManager get auditoriasRefs {
    final manager = $$AuditoriasTableTableManager($_db, $_db.auditorias).filter(
      (f) => f.curadoriaId.uuid.sqlEquals($_itemColumn<String>('uuid')!),
    );

    final cache = $_typedResult.readTableOrNull(_auditoriasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CuradoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CuradoriasTable> {
  $$CuradoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StatusCuradoria, StatusCuradoria, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    AcaoResultanteCuradoria,
    AcaoResultanteCuradoria,
    String
  >
  get acaoResultante => $composableBuilder(
    column: $table.acaoResultante,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get dataAvaliacao => $composableBuilder(
    column: $table.dataAvaliacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnFilters(column),
  );

  $$ColetasTableFilterComposer get coletaId {
    final $$ColetasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coletaId,
      referencedTable: $db.coletas,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColetasTableFilterComposer(
            $db: $db,
            $table: $db.coletas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BensMateriaisTableFilterComposer get bemMaterialId {
    final $$BensMateriaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableFilterComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> auditoriasRefs(
    Expression<bool> Function($$AuditoriasTableFilterComposer f) f,
  ) {
    final $$AuditoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.auditorias,
      getReferencedColumn: (t) => t.curadoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditoriasTableFilterComposer(
            $db: $db,
            $table: $db.auditorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuradoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CuradoriasTable> {
  $$CuradoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acaoResultante => $composableBuilder(
    column: $table.acaoResultante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAvaliacao => $composableBuilder(
    column: $table.dataAvaliacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$ColetasTableOrderingComposer get coletaId {
    final $$ColetasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coletaId,
      referencedTable: $db.coletas,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColetasTableOrderingComposer(
            $db: $db,
            $table: $db.coletas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BensMateriaisTableOrderingComposer get bemMaterialId {
    final $$BensMateriaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableOrderingComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CuradoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CuradoriasTable> {
  $$CuradoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatusCuradoria, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AcaoResultanteCuradoria, String>
  get acaoResultante => $composableBuilder(
    column: $table.acaoResultante,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAvaliacao => $composableBuilder(
    column: $table.dataAvaliacao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  $$ColetasTableAnnotationComposer get coletaId {
    final $$ColetasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coletaId,
      referencedTable: $db.coletas,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColetasTableAnnotationComposer(
            $db: $db,
            $table: $db.coletas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BensMateriaisTableAnnotationComposer get bemMaterialId {
    final $$BensMateriaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableAnnotationComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> auditoriasRefs<T extends Object>(
    Expression<T> Function($$AuditoriasTableAnnotationComposer a) f,
  ) {
    final $$AuditoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.auditorias,
      getReferencedColumn: (t) => t.curadoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.auditorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuradoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CuradoriasTable,
          Curadoria,
          $$CuradoriasTableFilterComposer,
          $$CuradoriasTableOrderingComposer,
          $$CuradoriasTableAnnotationComposer,
          $$CuradoriasTableCreateCompanionBuilder,
          $$CuradoriasTableUpdateCompanionBuilder,
          (Curadoria, $$CuradoriasTableReferences),
          Curadoria,
          PrefetchHooks Function({
            bool coletaId,
            bool bemMaterialId,
            bool usuarioId,
            bool auditoriasRefs,
          })
        > {
  $$CuradoriasTableTableManager(_$AppDatabase db, $CuradoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuradoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuradoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuradoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> coletaId = const Value.absent(),
                Value<String?> bemMaterialId = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<StatusCuradoria> status = const Value.absent(),
                Value<AcaoResultanteCuradoria> acaoResultante =
                    const Value.absent(),
                Value<DateTime> dataAvaliacao = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CuradoriasCompanion(
                uuid: uuid,
                coletaId: coletaId,
                bemMaterialId: bemMaterialId,
                usuarioId: usuarioId,
                status: status,
                acaoResultante: acaoResultante,
                dataAvaliacao: dataAvaliacao,
                observacao: observacao,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String coletaId,
                Value<String?> bemMaterialId = const Value.absent(),
                required String usuarioId,
                Value<StatusCuradoria> status = const Value.absent(),
                Value<AcaoResultanteCuradoria> acaoResultante =
                    const Value.absent(),
                Value<DateTime> dataAvaliacao = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CuradoriasCompanion.insert(
                uuid: uuid,
                coletaId: coletaId,
                bemMaterialId: bemMaterialId,
                usuarioId: usuarioId,
                status: status,
                acaoResultante: acaoResultante,
                dataAvaliacao: dataAvaliacao,
                observacao: observacao,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CuradoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                coletaId = false,
                bemMaterialId = false,
                usuarioId = false,
                auditoriasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (auditoriasRefs) db.auditorias],
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
                        if (coletaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.coletaId,
                                    referencedTable: $$CuradoriasTableReferences
                                        ._coletaIdTable(db),
                                    referencedColumn:
                                        $$CuradoriasTableReferences
                                            ._coletaIdTable(db)
                                            .uuid,
                                  )
                                  as T;
                        }
                        if (bemMaterialId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bemMaterialId,
                                    referencedTable: $$CuradoriasTableReferences
                                        ._bemMaterialIdTable(db),
                                    referencedColumn:
                                        $$CuradoriasTableReferences
                                            ._bemMaterialIdTable(db)
                                            .uuid,
                                  )
                                  as T;
                        }
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable: $$CuradoriasTableReferences
                                        ._usuarioIdTable(db),
                                    referencedColumn:
                                        $$CuradoriasTableReferences
                                            ._usuarioIdTable(db)
                                            .uuid,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (auditoriasRefs)
                        await $_getPrefetchedData<
                          Curadoria,
                          $CuradoriasTable,
                          Auditoria
                        >(
                          currentTable: table,
                          referencedTable: $$CuradoriasTableReferences
                              ._auditoriasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CuradoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).auditoriasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.curadoriaId == item.uuid,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CuradoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CuradoriasTable,
      Curadoria,
      $$CuradoriasTableFilterComposer,
      $$CuradoriasTableOrderingComposer,
      $$CuradoriasTableAnnotationComposer,
      $$CuradoriasTableCreateCompanionBuilder,
      $$CuradoriasTableUpdateCompanionBuilder,
      (Curadoria, $$CuradoriasTableReferences),
      Curadoria,
      PrefetchHooks Function({
        bool coletaId,
        bool bemMaterialId,
        bool usuarioId,
        bool auditoriasRefs,
      })
    >;
typedef $$MidiaLinksTableCreateCompanionBuilder =
    MidiaLinksCompanion Function({
      required String uuid,
      required String bemMaterialId,
      Value<TipoMidia> tipo,
      required String url,
      Value<String?> descricao,
      Value<int> rowid,
    });
typedef $$MidiaLinksTableUpdateCompanionBuilder =
    MidiaLinksCompanion Function({
      Value<String> uuid,
      Value<String> bemMaterialId,
      Value<TipoMidia> tipo,
      Value<String> url,
      Value<String?> descricao,
      Value<int> rowid,
    });

final class $$MidiaLinksTableReferences
    extends BaseReferences<_$AppDatabase, $MidiaLinksTable, MidiaLink> {
  $$MidiaLinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BensMateriaisTable _bemMaterialIdTable(_$AppDatabase db) =>
      db.bensMateriais.createAlias(
        $_aliasNameGenerator(
          db.midiaLinks.bemMaterialId,
          db.bensMateriais.uuid,
        ),
      );

  $$BensMateriaisTableProcessedTableManager get bemMaterialId {
    final $_column = $_itemColumn<String>('bem_material_id')!;

    final manager = $$BensMateriaisTableTableManager(
      $_db,
      $_db.bensMateriais,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bemMaterialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MidiaLinksTableFilterComposer
    extends Composer<_$AppDatabase, $MidiaLinksTable> {
  $$MidiaLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMidia, TipoMidia, String> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  $$BensMateriaisTableFilterComposer get bemMaterialId {
    final $$BensMateriaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableFilterComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MidiaLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $MidiaLinksTable> {
  $$MidiaLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  $$BensMateriaisTableOrderingComposer get bemMaterialId {
    final $$BensMateriaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableOrderingComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MidiaLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MidiaLinksTable> {
  $$MidiaLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMidia, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  $$BensMateriaisTableAnnotationComposer get bemMaterialId {
    final $$BensMateriaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableAnnotationComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MidiaLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MidiaLinksTable,
          MidiaLink,
          $$MidiaLinksTableFilterComposer,
          $$MidiaLinksTableOrderingComposer,
          $$MidiaLinksTableAnnotationComposer,
          $$MidiaLinksTableCreateCompanionBuilder,
          $$MidiaLinksTableUpdateCompanionBuilder,
          (MidiaLink, $$MidiaLinksTableReferences),
          MidiaLink,
          PrefetchHooks Function({bool bemMaterialId})
        > {
  $$MidiaLinksTableTableManager(_$AppDatabase db, $MidiaLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MidiaLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MidiaLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MidiaLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> bemMaterialId = const Value.absent(),
                Value<TipoMidia> tipo = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MidiaLinksCompanion(
                uuid: uuid,
                bemMaterialId: bemMaterialId,
                tipo: tipo,
                url: url,
                descricao: descricao,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String bemMaterialId,
                Value<TipoMidia> tipo = const Value.absent(),
                required String url,
                Value<String?> descricao = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MidiaLinksCompanion.insert(
                uuid: uuid,
                bemMaterialId: bemMaterialId,
                tipo: tipo,
                url: url,
                descricao: descricao,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MidiaLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bemMaterialId = false}) {
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
                    if (bemMaterialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bemMaterialId,
                                referencedTable: $$MidiaLinksTableReferences
                                    ._bemMaterialIdTable(db),
                                referencedColumn: $$MidiaLinksTableReferences
                                    ._bemMaterialIdTable(db)
                                    .uuid,
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

typedef $$MidiaLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MidiaLinksTable,
      MidiaLink,
      $$MidiaLinksTableFilterComposer,
      $$MidiaLinksTableOrderingComposer,
      $$MidiaLinksTableAnnotationComposer,
      $$MidiaLinksTableCreateCompanionBuilder,
      $$MidiaLinksTableUpdateCompanionBuilder,
      (MidiaLink, $$MidiaLinksTableReferences),
      MidiaLink,
      PrefetchHooks Function({bool bemMaterialId})
    >;
typedef $$ResponsaveisSitioTableCreateCompanionBuilder =
    ResponsaveisSitioCompanion Function({
      required String uuid,
      required String bemMaterialId,
      required String contatoNome,
      Value<String?> contatoEmail,
      Value<String?> contatoTelefone,
      Value<int> rowid,
    });
typedef $$ResponsaveisSitioTableUpdateCompanionBuilder =
    ResponsaveisSitioCompanion Function({
      Value<String> uuid,
      Value<String> bemMaterialId,
      Value<String> contatoNome,
      Value<String?> contatoEmail,
      Value<String?> contatoTelefone,
      Value<int> rowid,
    });

final class $$ResponsaveisSitioTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ResponsaveisSitioTable,
          ResponsaveisSitioData
        > {
  $$ResponsaveisSitioTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BensMateriaisTable _bemMaterialIdTable(_$AppDatabase db) =>
      db.bensMateriais.createAlias(
        $_aliasNameGenerator(
          db.responsaveisSitio.bemMaterialId,
          db.bensMateriais.uuid,
        ),
      );

  $$BensMateriaisTableProcessedTableManager get bemMaterialId {
    final $_column = $_itemColumn<String>('bem_material_id')!;

    final manager = $$BensMateriaisTableTableManager(
      $_db,
      $_db.bensMateriais,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bemMaterialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ResponsaveisSitioTableFilterComposer
    extends Composer<_$AppDatabase, $ResponsaveisSitioTable> {
  $$ResponsaveisSitioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contatoNome => $composableBuilder(
    column: $table.contatoNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contatoEmail => $composableBuilder(
    column: $table.contatoEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contatoTelefone => $composableBuilder(
    column: $table.contatoTelefone,
    builder: (column) => ColumnFilters(column),
  );

  $$BensMateriaisTableFilterComposer get bemMaterialId {
    final $$BensMateriaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableFilterComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResponsaveisSitioTableOrderingComposer
    extends Composer<_$AppDatabase, $ResponsaveisSitioTable> {
  $$ResponsaveisSitioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contatoNome => $composableBuilder(
    column: $table.contatoNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contatoEmail => $composableBuilder(
    column: $table.contatoEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contatoTelefone => $composableBuilder(
    column: $table.contatoTelefone,
    builder: (column) => ColumnOrderings(column),
  );

  $$BensMateriaisTableOrderingComposer get bemMaterialId {
    final $$BensMateriaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableOrderingComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResponsaveisSitioTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResponsaveisSitioTable> {
  $$ResponsaveisSitioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get contatoNome => $composableBuilder(
    column: $table.contatoNome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contatoEmail => $composableBuilder(
    column: $table.contatoEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contatoTelefone => $composableBuilder(
    column: $table.contatoTelefone,
    builder: (column) => column,
  );

  $$BensMateriaisTableAnnotationComposer get bemMaterialId {
    final $$BensMateriaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bemMaterialId,
      referencedTable: $db.bensMateriais,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BensMateriaisTableAnnotationComposer(
            $db: $db,
            $table: $db.bensMateriais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResponsaveisSitioTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResponsaveisSitioTable,
          ResponsaveisSitioData,
          $$ResponsaveisSitioTableFilterComposer,
          $$ResponsaveisSitioTableOrderingComposer,
          $$ResponsaveisSitioTableAnnotationComposer,
          $$ResponsaveisSitioTableCreateCompanionBuilder,
          $$ResponsaveisSitioTableUpdateCompanionBuilder,
          (ResponsaveisSitioData, $$ResponsaveisSitioTableReferences),
          ResponsaveisSitioData,
          PrefetchHooks Function({bool bemMaterialId})
        > {
  $$ResponsaveisSitioTableTableManager(
    _$AppDatabase db,
    $ResponsaveisSitioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResponsaveisSitioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResponsaveisSitioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResponsaveisSitioTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> bemMaterialId = const Value.absent(),
                Value<String> contatoNome = const Value.absent(),
                Value<String?> contatoEmail = const Value.absent(),
                Value<String?> contatoTelefone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResponsaveisSitioCompanion(
                uuid: uuid,
                bemMaterialId: bemMaterialId,
                contatoNome: contatoNome,
                contatoEmail: contatoEmail,
                contatoTelefone: contatoTelefone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String bemMaterialId,
                required String contatoNome,
                Value<String?> contatoEmail = const Value.absent(),
                Value<String?> contatoTelefone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResponsaveisSitioCompanion.insert(
                uuid: uuid,
                bemMaterialId: bemMaterialId,
                contatoNome: contatoNome,
                contatoEmail: contatoEmail,
                contatoTelefone: contatoTelefone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ResponsaveisSitioTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bemMaterialId = false}) {
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
                    if (bemMaterialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bemMaterialId,
                                referencedTable:
                                    $$ResponsaveisSitioTableReferences
                                        ._bemMaterialIdTable(db),
                                referencedColumn:
                                    $$ResponsaveisSitioTableReferences
                                        ._bemMaterialIdTable(db)
                                        .uuid,
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

typedef $$ResponsaveisSitioTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResponsaveisSitioTable,
      ResponsaveisSitioData,
      $$ResponsaveisSitioTableFilterComposer,
      $$ResponsaveisSitioTableOrderingComposer,
      $$ResponsaveisSitioTableAnnotationComposer,
      $$ResponsaveisSitioTableCreateCompanionBuilder,
      $$ResponsaveisSitioTableUpdateCompanionBuilder,
      (ResponsaveisSitioData, $$ResponsaveisSitioTableReferences),
      ResponsaveisSitioData,
      PrefetchHooks Function({bool bemMaterialId})
    >;
typedef $$AuditoriasTableCreateCompanionBuilder =
    AuditoriasCompanion Function({
      required String uuid,
      required String usuarioId,
      required String entidadeTipo,
      required String entidadeId,
      Value<String?> curadoriaId,
      required String operacao,
      required String meio,
      Value<DateTime> dataHora,
      Value<Map<String, Object?>?> valorAnterior,
      Value<Map<String, Object?>?> valorNovo,
      Value<int> rowid,
    });
typedef $$AuditoriasTableUpdateCompanionBuilder =
    AuditoriasCompanion Function({
      Value<String> uuid,
      Value<String> usuarioId,
      Value<String> entidadeTipo,
      Value<String> entidadeId,
      Value<String?> curadoriaId,
      Value<String> operacao,
      Value<String> meio,
      Value<DateTime> dataHora,
      Value<Map<String, Object?>?> valorAnterior,
      Value<Map<String, Object?>?> valorNovo,
      Value<int> rowid,
    });

final class $$AuditoriasTableReferences
    extends BaseReferences<_$AppDatabase, $AuditoriasTable, Auditoria> {
  $$AuditoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.auditorias.usuarioId, db.usuarios.uuid),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<String>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CuradoriasTable _curadoriaIdTable(_$AppDatabase db) =>
      db.curadorias.createAlias(
        $_aliasNameGenerator(db.auditorias.curadoriaId, db.curadorias.uuid),
      );

  $$CuradoriasTableProcessedTableManager? get curadoriaId {
    final $_column = $_itemColumn<String>('curadoria_id');
    if ($_column == null) return null;
    final manager = $$CuradoriasTableTableManager(
      $_db,
      $_db.curadorias,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_curadoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditoriasTableFilterComposer
    extends Composer<_$AppDatabase, $AuditoriasTable> {
  $$AuditoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entidadeTipo => $composableBuilder(
    column: $table.entidadeTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entidadeId => $composableBuilder(
    column: $table.entidadeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operacao => $composableBuilder(
    column: $table.operacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meio => $composableBuilder(
    column: $table.meio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get valorAnterior => $composableBuilder(
    column: $table.valorAnterior,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get valorNovo => $composableBuilder(
    column: $table.valorNovo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuradoriasTableFilterComposer get curadoriaId {
    final $$CuradoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.curadoriaId,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableFilterComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditoriasTable> {
  $$AuditoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entidadeTipo => $composableBuilder(
    column: $table.entidadeTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entidadeId => $composableBuilder(
    column: $table.entidadeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operacao => $composableBuilder(
    column: $table.operacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meio => $composableBuilder(
    column: $table.meio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valorAnterior => $composableBuilder(
    column: $table.valorAnterior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valorNovo => $composableBuilder(
    column: $table.valorNovo,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuradoriasTableOrderingComposer get curadoriaId {
    final $$CuradoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.curadoriaId,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableOrderingComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditoriasTable> {
  $$AuditoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get entidadeTipo => $composableBuilder(
    column: $table.entidadeTipo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entidadeId => $composableBuilder(
    column: $table.entidadeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operacao =>
      $composableBuilder(column: $table.operacao, builder: (column) => column);

  GeneratedColumn<String> get meio =>
      $composableBuilder(column: $table.meio, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  get valorAnterior => $composableBuilder(
    column: $table.valorAnterior,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  get valorNovo =>
      $composableBuilder(column: $table.valorNovo, builder: (column) => column);

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuradoriasTableAnnotationComposer get curadoriaId {
    final $$CuradoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.curadoriaId,
      referencedTable: $db.curadorias,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuradoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.curadorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditoriasTable,
          Auditoria,
          $$AuditoriasTableFilterComposer,
          $$AuditoriasTableOrderingComposer,
          $$AuditoriasTableAnnotationComposer,
          $$AuditoriasTableCreateCompanionBuilder,
          $$AuditoriasTableUpdateCompanionBuilder,
          (Auditoria, $$AuditoriasTableReferences),
          Auditoria,
          PrefetchHooks Function({bool usuarioId, bool curadoriaId})
        > {
  $$AuditoriasTableTableManager(_$AppDatabase db, $AuditoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> entidadeTipo = const Value.absent(),
                Value<String> entidadeId = const Value.absent(),
                Value<String?> curadoriaId = const Value.absent(),
                Value<String> operacao = const Value.absent(),
                Value<String> meio = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<Map<String, Object?>?> valorAnterior =
                    const Value.absent(),
                Value<Map<String, Object?>?> valorNovo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditoriasCompanion(
                uuid: uuid,
                usuarioId: usuarioId,
                entidadeTipo: entidadeTipo,
                entidadeId: entidadeId,
                curadoriaId: curadoriaId,
                operacao: operacao,
                meio: meio,
                dataHora: dataHora,
                valorAnterior: valorAnterior,
                valorNovo: valorNovo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String usuarioId,
                required String entidadeTipo,
                required String entidadeId,
                Value<String?> curadoriaId = const Value.absent(),
                required String operacao,
                required String meio,
                Value<DateTime> dataHora = const Value.absent(),
                Value<Map<String, Object?>?> valorAnterior =
                    const Value.absent(),
                Value<Map<String, Object?>?> valorNovo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditoriasCompanion.insert(
                uuid: uuid,
                usuarioId: usuarioId,
                entidadeTipo: entidadeTipo,
                entidadeId: entidadeId,
                curadoriaId: curadoriaId,
                operacao: operacao,
                meio: meio,
                dataHora: dataHora,
                valorAnterior: valorAnterior,
                valorNovo: valorNovo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({usuarioId = false, curadoriaId = false}) {
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
                    if (usuarioId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.usuarioId,
                                referencedTable: $$AuditoriasTableReferences
                                    ._usuarioIdTable(db),
                                referencedColumn: $$AuditoriasTableReferences
                                    ._usuarioIdTable(db)
                                    .uuid,
                              )
                              as T;
                    }
                    if (curadoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.curadoriaId,
                                referencedTable: $$AuditoriasTableReferences
                                    ._curadoriaIdTable(db),
                                referencedColumn: $$AuditoriasTableReferences
                                    ._curadoriaIdTable(db)
                                    .uuid,
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

typedef $$AuditoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditoriasTable,
      Auditoria,
      $$AuditoriasTableFilterComposer,
      $$AuditoriasTableOrderingComposer,
      $$AuditoriasTableAnnotationComposer,
      $$AuditoriasTableCreateCompanionBuilder,
      $$AuditoriasTableUpdateCompanionBuilder,
      (Auditoria, $$AuditoriasTableReferences),
      Auditoria,
      PrefetchHooks Function({bool usuarioId, bool curadoriaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ColetasTableTableManager get coletas =>
      $$ColetasTableTableManager(_db, _db.coletas);
  $$BensMateriaisTableTableManager get bensMateriais =>
      $$BensMateriaisTableTableManager(_db, _db.bensMateriais);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$CuradoriasTableTableManager get curadorias =>
      $$CuradoriasTableTableManager(_db, _db.curadorias);
  $$MidiaLinksTableTableManager get midiaLinks =>
      $$MidiaLinksTableTableManager(_db, _db.midiaLinks);
  $$ResponsaveisSitioTableTableManager get responsaveisSitio =>
      $$ResponsaveisSitioTableTableManager(_db, _db.responsaveisSitio);
  $$AuditoriasTableTableManager get auditorias =>
      $$AuditoriasTableTableManager(_db, _db.auditorias);
}
