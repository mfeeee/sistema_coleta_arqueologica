// test/core/database/enums/enums_test.dart
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/perfil_usuario.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_curadoria.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_midia.dart';

void main() {
  // ── StatusColeta ────────────────────────────────────────────────────────────
  group('StatusColeta', () {
    test('fromString retorna o valor correto para cada nome', () {
      check(StatusColeta.fromString('pendente')).equals(StatusColeta.pendente);
      check(
        StatusColeta.fromString('sincronizado'),
      ).equals(StatusColeta.sincronizado);
      check(StatusColeta.fromString('conflito')).equals(StatusColeta.conflito);
      check(StatusColeta.fromString('rascunho')).equals(StatusColeta.rascunho);
    });

    test('fromString retorna pendente para valor desconhecido (fallback)', () {
      check(
        StatusColeta.fromString('valor_inexistente'),
      ).equals(StatusColeta.pendente);
    });

    test('StatusColetaConverter.toSql serializa para string correta', () {
      const converter = StatusColetaConverter();
      check(converter.toSql(StatusColeta.pendente)).equals('pendente');
      check(converter.toSql(StatusColeta.sincronizado)).equals('sincronizado');
      check(converter.toSql(StatusColeta.conflito)).equals('conflito');
      check(converter.toSql(StatusColeta.rascunho)).equals('rascunho');
    });

    test('StatusColetaConverter.fromSql desserializa corretamente', () {
      const converter = StatusColetaConverter();
      check(converter.fromSql('pendente')).equals(StatusColeta.pendente);
      check(
        converter.fromSql('sincronizado'),
      ).equals(StatusColeta.sincronizado);
    });

    test('values contém exatamente 4 valores', () {
      check(StatusColeta.values.length).equals(4);
    });
  });

  // ── ArtefatoBem ─────────────────────────────────────────────────────────────
  group('ArtefatoBem', () {
    test('cada valor tem label não vazio', () {
      for (final artefato in ArtefatoBem.values) {
        check(artefato.label).isNotEmpty();
      }
    });

    test('tryFromString retorna o valor correto', () {
      check(ArtefatoBem.tryFromString('ceramica')).equals(ArtefatoBem.ceramica);
      check(ArtefatoBem.tryFromString('litico')).equals(ArtefatoBem.litico);
      check(ArtefatoBem.tryFromString('metalico')).equals(ArtefatoBem.metalico);
    });

    test(
      'tryFromString com prefixo "nome:extra" ainda retorna o enum correto',
      () {
        check(
          ArtefatoBem.tryFromString('ceramica:extra'),
        ).equals(ArtefatoBem.ceramica);
      },
    );

    test('tryFromString retorna null para valor desconhecido', () {
      check(ArtefatoBem.tryFromString('valor_inexistente')).isNull();
    });

    test('values contém 21 artefatos', () {
      check(ArtefatoBem.values.length).equals(21);
    });

    test('labels conhecidos estão corretos', () {
      check(ArtefatoBem.ceramica.label).equals('Cerâmica');
      check(ArtefatoBem.litico.label).equals('Lítico');
      check(ArtefatoBem.ossosHumanos.label).equals('Ossos humanos');
    });
  });

  // ── NaturezaBem ─────────────────────────────────────────────────────────────
  group('NaturezaBem', () {
    test('values é não vazio', () {
      check(NaturezaBem.values).isNotEmpty();
    });

    test('todos os valores têm name não vazio', () {
      for (final v in NaturezaBem.values) {
        check(v.name).isNotEmpty();
      }
    });
  });

  // ── TipoBem ─────────────────────────────────────────────────────────────────
  group('TipoBem', () {
    test('values é não vazio', () {
      check(TipoBem.values).isNotEmpty();
    });

    test('sitio está presente', () {
      check(TipoBem.values.map((e) => e.name)).contains('sitio');
    });
  });

  // ── TipoMidia ────────────────────────────────────────────────────────────────
  group('TipoMidia', () {
    test('values é não vazio', () {
      check(TipoMidia.values).isNotEmpty();
    });

    test('todos os valores têm name não vazio', () {
      for (final v in TipoMidia.values) {
        check(v.name).isNotEmpty();
      }
    });

    test('imagem está presente nos values', () {
      check(TipoMidia.values.map((e) => e.name)).contains('imagem');
    });

    test('fromString retorna o valor correto', () {
      check(TipoMidia.fromString('imagem')).equals(TipoMidia.imagem);
      check(TipoMidia.fromString('video')).equals(TipoMidia.video);
      check(TipoMidia.fromString('tese')).equals(TipoMidia.tese);
      check(TipoMidia.fromString('artigo')).equals(TipoMidia.artigo);
    });

    test('fromString retorna imagem para valor desconhecido (fallback)', () {
      check(TipoMidia.fromString('inexistente')).equals(TipoMidia.imagem);
    });
  });

  // ── PerfilUsuario ────────────────────────────────────────────────────────────
  group('PerfilUsuario', () {
    test('fromString retorna o valor correto', () {
      check(PerfilUsuario.fromString('coletor')).equals(PerfilUsuario.coletor);
      check(PerfilUsuario.fromString('curador')).equals(PerfilUsuario.curador);
      check(PerfilUsuario.fromString('admin')).equals(PerfilUsuario.admin);
    });

    test('fromString retorna coletor para valor desconhecido (fallback)', () {
      check(
        PerfilUsuario.fromString('inexistente'),
      ).equals(PerfilUsuario.coletor);
    });

    test('values contém exatamente 3 perfis', () {
      check(PerfilUsuario.values.length).equals(3);
    });
  });

  // ── ClassificacaoUsuario ─────────────────────────────────────────────────────
  group('ClassificacaoUsuario', () {
    test('fromString retorna o valor correto', () {
      check(
        ClassificacaoUsuario.fromString('estudante'),
      ).equals(ClassificacaoUsuario.estudante);
      check(
        ClassificacaoUsuario.fromString('professor'),
      ).equals(ClassificacaoUsuario.professor);
      check(
        ClassificacaoUsuario.fromString('arqueologo'),
      ).equals(ClassificacaoUsuario.arqueologo);
    });

    test('fromString retorna estudante para valor desconhecido (fallback)', () {
      check(
        ClassificacaoUsuario.fromString('inexistente'),
      ).equals(ClassificacaoUsuario.estudante);
    });
  });

  // ── StatusCuradoria ──────────────────────────────────────────────────────────
  group('StatusCuradoria', () {
    test('fromString retorna o valor correto', () {
      check(
        StatusCuradoria.fromString('pendente'),
      ).equals(StatusCuradoria.pendente);
      check(
        StatusCuradoria.fromString('aprovado'),
      ).equals(StatusCuradoria.aprovado);
      check(
        StatusCuradoria.fromString('rejeitado'),
      ).equals(StatusCuradoria.rejeitado);
    });

    test('fromString retorna pendente para valor desconhecido (fallback)', () {
      check(
        StatusCuradoria.fromString('inexistente'),
      ).equals(StatusCuradoria.pendente);
    });
  });

  // ── AcaoResultanteCuradoria ──────────────────────────────────────────────────
  group('AcaoResultanteCuradoria', () {
    test('fromString retorna o valor correto', () {
      check(
        AcaoResultanteCuradoria.fromString('criarSitio'),
      ).equals(AcaoResultanteCuradoria.criarSitio);
      check(
        AcaoResultanteCuradoria.fromString('atualizarSitio'),
      ).equals(AcaoResultanteCuradoria.atualizarSitio);
      check(
        AcaoResultanteCuradoria.fromString('rejeitar'),
      ).equals(AcaoResultanteCuradoria.rejeitar);
    });

    test('fromString retorna rejeitar para valor desconhecido (fallback)', () {
      check(
        AcaoResultanteCuradoria.fromString('inexistente'),
      ).equals(AcaoResultanteCuradoria.rejeitar);
    });
  });
}
