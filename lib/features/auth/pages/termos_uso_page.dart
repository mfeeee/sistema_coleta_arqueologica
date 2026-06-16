import 'package:flutter/material.dart';

class TermosUsoPage extends StatelessWidget {
  const TermosUsoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso e Privacidade'),
        centerTitle: true,
      ),
      body: Semantics(
        label: 'Conteúdo dos Termos de Uso e Política de Privacidade',
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            _Titulo(texto: 'Termos de Uso e Política de Privacidade'),
            _Subtitulo(texto: 'ArqueoPI Hub - IFPI Campus Parnaíba'),
            SizedBox(height: 16),
            _Secao(
              titulo: '1. Aceitação dos Termos',
              conteudo:
                  'Ao acessar e utilizar o aplicativo ArqueoPI Hub, você concorda em cumprir e estar vinculado aos seguintes Termos de Uso e Política de Privacidade. Se você não concordar com qualquer parte destes termos, não deverá utilizar o aplicativo.',
            ),
            _Secao(
              titulo: '2. Sobre o Aplicativo',
              conteudo:
                  'O ArqueoPI Hub é uma ferramenta desenvolvida no âmbito de um projeto de TCC/PIBIC no IFPI Campus Parnaíba, destinada à coleta de dados arqueológicos em campo. O aplicativo permite o registro de informações de forma offline e a posterior sincronização com um servidor central.',
            ),
            _Secao(
              titulo: '3. Cadastro e Acesso',
              conteudo:
                  'Para utilizar as funcionalidades de sincronização, o usuário deve realizar um cadastro fornecendo nome, e-mail e sua classificação (estudante, professor ou arqueólogo). O usuário é responsável por manter a confidencialidade de suas credenciais de acesso.',
            ),
            _Secao(
              titulo: '4. Responsabilidades do Usuário',
              conteudo:
                  'O usuário compromete-se a utilizar o aplicativo de forma ética e legal, inserindo apenas dados verídicos e respeitando a legislação vigente sobre patrimônio arqueológico e proteção de dados.',
            ),
            _Secao(
              titulo: '5. Dados Coletados',
              conteudo:
                  'O ArqueoPI Hub coleta dados necessários para a pesquisa arqueológica, incluindo coordenadas de GPS, fotografias, vídeos e descrições técnicas. Os dados são armazenados localmente de forma criptografada (SQLCipher) e transmitidos via conexão segura (HTTPS).',
            ),
            _Secao(
              titulo: '6. Finalidade do Tratamento',
              conteudo:
                  'Os dados coletados destinam-se exclusivamente a fins acadêmicos e de gestão do patrimônio arqueológico, permitindo o mapeamento e a preservação de sítios e bens materiais.',
            ),
            _Secao(
              titulo: '7. Base Legal — LGPD',
              conteudo:
                  'O tratamento de dados pessoais pelo ArqueoPI Hub é realizado em conformidade com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018), fundamentado no consentimento do usuário e no legítimo interesse acadêmico.',
            ),
            _Secao(
              titulo: '8. Compartilhamento de Dados',
              conteudo:
                  'Os dados sincronizados são acessíveis apenas pela curadoria do projeto no IFPI e órgãos competentes, não sendo compartilhados com terceiros para fins comerciais.',
            ),
            _Secao(
              titulo: '9. Segurança',
              conteudo:
                  'Empregamos medidas técnicas de segurança, como criptografia local e protocolos de comunicação seguros, para proteger seus dados contra acessos não autorizados.',
            ),
            _Secao(
              titulo: '10. Direitos do Usuário',
              conteudo:
                  'Nos termos da LGPD, o usuário tem direito a acessar, corrigir, anonimizar ou excluir seus dados pessoais, bem como revogar seu consentimento a qualquer momento através do contato com os administradores do sistema.',
            ),
            _Secao(
              titulo: '11. Alterações',
              conteudo:
                  'Estes termos podem ser atualizados periodicamente. O uso continuado do aplicativo após alterações constitui aceitação dos novos termos.',
            ),
            _Secao(
              titulo: '12. Legislação e Foro',
              conteudo:
                  'Estes termos são regidos pelas leis brasileiras. Fica eleito o foro da comarca de Parnaíba/PI para dirimir eventuais controvérsias.',
            ),
            SizedBox(height: 24),
            Text(
              'Última atualização: Junho de 2026',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Subtitulo extends StatelessWidget {
  final String texto;
  const _Subtitulo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final String conteudo;

  const _Secao({required this.titulo, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            conteudo,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
