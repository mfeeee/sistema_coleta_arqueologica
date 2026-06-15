// test/core/entities/entities_test.dart
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_midia.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/core/entities/localizacao_entity.dart';
import 'package:sistema_coleta_arqueologica/core/entities/midia_entity.dart';
import 'package:sistema_coleta_arqueologica/core/entities/usuario_entity.dart';

void main() {
  // ── ArtefatoTipoEntity ───────────────────────────────────────────────────────
  group('ArtefatoTipoEntity', () {
    test('construtor armazena id e nome corretamente', () {
      const entity = ArtefatoTipoEntity(id: 'tipo-1', nome: 'Cerâmica');
      check(entity.id).equals('tipo-1');
      check(entity.nome).equals('Cerâmica');
    });

    test('duas instâncias com mesmos valores são iguais (const)', () {
      const a = ArtefatoTipoEntity(id: 'x', nome: 'Lítico');
      const b = ArtefatoTipoEntity(id: 'x', nome: 'Lítico');
      check(a).equals(b);
    });

    test('instâncias com ids diferentes não são iguais', () {
      const a = ArtefatoTipoEntity(id: '1', nome: 'Cerâmica');
      const b = ArtefatoTipoEntity(id: '2', nome: 'Cerâmica');
      check(a).not((it) => it.equals(b));
    });
  });

  // ── LocalizacaoEntity ────────────────────────────────────────────────────────
  group('LocalizacaoEntity', () {
    test('construtor armazena campos obrigatórios', () {
      const loc = LocalizacaoEntity(id: 'loc-1', uf: 'PI');
      check(loc.id).equals('loc-1');
      check(loc.uf).equals('PI');
    });

    test('lat e lng são nulos quando não fornecidos', () {
      const loc = LocalizacaoEntity(id: 'loc-2', uf: 'BA');
      check(loc.lat).isNull();
      check(loc.lng).isNull();
    });

    test('lat e lng são armazenados quando fornecidos', () {
      const loc = LocalizacaoEntity(
        id: 'loc-3',
        uf: 'PI',
        lat: -2.9078,
        lng: -41.7722,
      );
      check(loc.lat).isNotNull();
      check(loc.lng).isNotNull();
      check(loc.lat!).isCloseTo(-2.9078, 0.0001);
      check(loc.lng!).isCloseTo(-41.7722, 0.0001);
    });
  });

  // ── MidiaEntity ──────────────────────────────────────────────────────────────
  group('MidiaEntity', () {
    const midia = MidiaEntity(
      id: 'midia-001',
      mediableType: 'coleta',
      mediableId: 'coleta-001',
      storagePath: '/fotos/artefato.jpg',
      mimeType: 'image/jpeg',
      tipo: TipoMidia.foto,
      url: 'https://storage.exemplo.com/fotos/artefato.jpg',
    );

    test('construtor armazena todos os campos obrigatórios', () {
      check(midia.id).equals('midia-001');
      check(midia.mediableType).equals('coleta');
      check(midia.storagePath).equals('/fotos/artefato.jpg');
      check(midia.mimeType).equals('image/jpeg');
      check(midia.tipo).equals(TipoMidia.foto);
      check(midia.url).isNotEmpty();
    });

    test('descricao é null quando não fornecida', () {
      check(midia.descricao).isNull();
    });

    test('descricao é armazenada quando fornecida', () {
      const midiaComDescricao = MidiaEntity(
        id: 'midia-002',
        mediableType: 'coleta',
        mediableId: 'coleta-001',
        storagePath: '/fotos/detalhe.jpg',
        mimeType: 'image/jpeg',
        tipo: TipoMidia.foto,
        url: 'https://storage.exemplo.com/fotos/detalhe.jpg',
        descricao: 'Vista frontal do artefato cerâmico',
      );
      check(
        midiaComDescricao.descricao,
      ).equals('Vista frontal do artefato cerâmico');
    });
  });

  // ── UsuarioEntity ─────────────────────────────────────────────────────────────
  group('UsuarioEntity', () {
    test('construtor armazena id e nome corretamente', () {
      const usuario = UsuarioEntity(id: 'usr-001', nome: 'Maria Silva');
      check(usuario.id).equals('usr-001');
      check(usuario.nome).equals('Maria Silva');
    });
  });
}
