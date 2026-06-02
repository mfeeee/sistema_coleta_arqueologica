import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/features/profile/viewmodels/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileViewModel _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final scope = AppScope.of(context);
      _viewModel = ProfileViewModel(
        authNotifier: scope.authNotifier,
        profileService: scope.profileService,
        coletaRepository: scope.coletaRepository,
        prefs: scope.prefs,
        temaModo: scope.temaModo,
        idiomaAtual: scope.idiomaAtual,
        fotoPerfilPath: scope.fotoPerfilPath,
      );
      _viewModel.carregarEstatisticas();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _confirmarLogout() async {
    final l10n = context.l10n;
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutContent),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.profileLogoutCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.profileLogoutConfirm),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    await _viewModel.sair();

    if (!mounted) return;

    if (_viewModel.temPendentesSemSync.value) {
      _viewModel.temPendentesSemSync.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profilePendingWarning)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        titleSpacing: 16.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
        title: Text(
          l10n.profileTitle,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 18,
            height: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
          child: Column(
            children: <Widget>[
              _FotoSection(viewModel: _viewModel),
              const SizedBox(height: 32.0),
              _DadosPessoaisSection(viewModel: _viewModel),
              const SizedBox(height: 16.0),
              _SenhaSection(viewModel: _viewModel),
              const SizedBox(height: 16.0),
              const _NotificacoesSection(),
              const SizedBox(height: 16.0),
              _PreferenciasSection(viewModel: _viewModel),
              const SizedBox(height: 16.0),
              _AcoesSection(viewModel: _viewModel, onLogout: _confirmarLogout),
            ],
          ),
        ),
      ),
    );
  }
}

class _FotoSection extends StatefulWidget {
  const _FotoSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<_FotoSection> createState() => _FotoSectionState();
}

class _FotoSectionState extends State<_FotoSection> {
  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final arquivo = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (arquivo == null || !mounted) return;
    await widget.viewModel.atualizarFoto(File(arquivo.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewModel.avatarUrl,
        widget.viewModel.fotoCarregando,
        widget.viewModel.nomeAtual,
      ]),
      builder: (context, _) {
        final url = widget.viewModel.avatarUrl.value;
        final carregando = widget.viewModel.fotoCarregando.value;

        return Center(
          child: SizedBox(
            width: 136,
            height: 136,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        width: 4.0,
                      ),
                    ),
                    child: ClipOval(
                      child: url != null
                          ? Image.network(url, fit: BoxFit.cover)
                          : ColoredBox(
                              color: theme.colorScheme.primaryContainer,
                              child: Center(
                                child: Text(
                                  widget.viewModel.iniciais,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                if (carregando)
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (!kIsWeb)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Semantics(
                      label: 'Alterar foto de perfil',
                      button: true,
                      child: GestureDetector(
                        onTap: carregando ? null : _selecionarFoto,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: theme.colorScheme.onPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DadosPessoaisSection extends StatefulWidget {
  const _DadosPessoaisSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<_DadosPessoaisSection> createState() => _DadosPessoaisSectionState();
}

class _DadosPessoaisSectionState extends State<_DadosPessoaisSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late String _classificacaoSelecionada;
  bool _editando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(
      text: widget.viewModel.nomeAtual.value,
    );
    _emailController = TextEditingController(
      text: widget.viewModel.emailAtual.value,
    );
    _classificacaoSelecionada = widget.viewModel.classificacaoAtual.value;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _iniciarEdicao() {
    _nomeController.text = widget.viewModel.nomeAtual.value;
    _emailController.text = widget.viewModel.emailAtual.value;
    _classificacaoSelecionada = widget.viewModel.classificacaoAtual.value;
    setState(() => _editando = true);
  }

  void _cancelar() => setState(() => _editando = false);

  Future<void> _salvar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final sucesso = await widget.viewModel.salvarDadosPessoais(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      classificacao: _classificacaoSelecionada,
    );
    if (sucesso && mounted) setState(() => _editando = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Dados Pessoais',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: -0.45,
                  ),
                ),
              ),
              if (!_editando)
                IconButton(
                  tooltip: 'Editar dados pessoais',
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: _iniciarEdicao,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _editando ? _FormEdicao(this) : _Visualizacao(this),
          ),
        ],
      ),
    );
  }
}

class _Visualizacao extends StatelessWidget {
  const _Visualizacao(this.state);

  final _DadosPessoaisSectionState state;

  String _nomeDaClassificacao(String valor) => switch (valor) {
    'estudante' => 'Estudante',
    'professor' => 'Professor',
    'arqueologo' => 'Arqueólogo',
    _ => valor,
  };

  @override
  Widget build(BuildContext context) {
    final vm = state.widget.viewModel;
    return ListenableBuilder(
      listenable: Listenable.merge([
        vm.nomeAtual,
        vm.emailAtual,
        vm.classificacaoAtual,
      ]),
      builder: (context, _) => Column(
        children: <Widget>[
          _InfoRow(label: 'Nome', value: vm.nomeAtual.value),
          const Divider(height: 1, indent: 16),
          _InfoRow(label: 'E-mail', value: vm.emailAtual.value),
          const Divider(height: 1, indent: 16),
          _InfoRow(
            label: 'Perfil',
            value: _nomeDaClassificacao(vm.classificacaoAtual.value),
          ),
        ],
      ),
    );
  }
}

class _FormEdicao extends StatelessWidget {
  const _FormEdicao(this.state);

  final _DadosPessoaisSectionState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: state.widget.viewModel.salvandoDados,
      builder: (context, salvando, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: state._formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _LabelCampo(texto: 'Nome completo', theme: theme),
              const SizedBox(height: 8),
              TextFormField(
                controller: state._nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Seu nome completo',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              _LabelCampo(texto: 'E-mail', theme: theme),
              const SizedBox(height: 8),
              TextFormField(
                controller: state._emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'seu@email.com'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(v.trim())) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _LabelCampo(texto: 'Perfil', theme: theme),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: state._classificacaoSelecionada,
                decoration: const InputDecoration(),
                items: const [
                  DropdownMenuItem(
                    value: 'estudante',
                    child: Text('Estudante'),
                  ),
                  DropdownMenuItem(
                    value: 'professor',
                    child: Text('Professor'),
                  ),
                  DropdownMenuItem(
                    value: 'arqueologo',
                    child: Text('Arqueólogo'),
                  ),
                ],
                onChanged: salvando
                    ? null
                    : (v) {
                        if (v != null) {
                          state._classificacaoSelecionada = v;
                        }
                      },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: state.widget.viewModel.erroSalvamento,
                builder: (context, erro, _) => erro != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          erro,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: salvando ? null : state._cancelar,
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: salvando ? null : state._salvar,
                      child: salvando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Salvar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SenhaSection extends StatefulWidget {
  const _SenhaSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<_SenhaSection> createState() => _SenhaSectionState();
}

class _SenhaSectionState extends State<_SenhaSection> {
  bool _editando = false;
  final _formKey = GlobalKey<FormState>();
  final _atualController = TextEditingController();
  final _novaController = TextEditingController();
  final _confirmacaoController = TextEditingController();

  @override
  void dispose() {
    _atualController.dispose();
    _novaController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  void _cancelar() {
    _atualController.clear();
    _novaController.clear();
    _confirmacaoController.clear();
    setState(() => _editando = false);
  }

  Future<void> _salvar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final sucesso = await widget.viewModel.alterarSenha(
      senhaAtual: _atualController.text,
      novaSenha: _novaController.text,
    );
    if (sucesso && mounted) _cancelar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Segurança',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _editando
                ? _FormSenha(
                    atualController: _atualController,
                    novaController: _novaController,
                    confirmacaoController: _confirmacaoController,
                    formKey: _formKey,
                    viewModel: widget.viewModel,
                    onCancelar: _cancelar,
                    onSalvar: _salvar,
                  )
                : _SettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Alterar Senha',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.outline,
                    ),
                    onTap: () => setState(() => _editando = true),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FormSenha extends StatefulWidget {
  const _FormSenha({
    required this.atualController,
    required this.novaController,
    required this.confirmacaoController,
    required this.formKey,
    required this.viewModel,
    required this.onCancelar,
    required this.onSalvar,
  });

  final TextEditingController atualController;
  final TextEditingController novaController;
  final TextEditingController confirmacaoController;
  final GlobalKey<FormState> formKey;
  final ProfileViewModel viewModel;
  final VoidCallback onCancelar;
  final Future<void> Function() onSalvar;

  @override
  State<_FormSenha> createState() => _FormSenhaState();
}

class _FormSenhaState extends State<_FormSenha> {
  bool _atualOculta = true;
  bool _novaOculta = true;
  bool _confirmacaoOculta = true;

  Widget _campoSenha({
    required TextEditingController controller,
    required String label,
    required bool oculta,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LabelCampo(texto: label, theme: theme),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: oculta,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(
              tooltip: oculta ? 'Mostrar senha' : 'Ocultar senha',
              icon: Icon(
                oculta
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggle,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.viewModel.salvandoDados,
      builder: (context, salvando, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _campoSenha(
                controller: widget.atualController,
                label: 'Senha atual',
                oculta: _atualOculta,
                onToggle: () => setState(() => _atualOculta = !_atualOculta),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a senha atual' : null,
              ),
              const SizedBox(height: 16),
              _campoSenha(
                controller: widget.novaController,
                label: 'Nova senha',
                oculta: _novaOculta,
                onToggle: () => setState(() => _novaOculta = !_novaOculta),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a nova senha';
                  if (v.length < 8) return 'Mínimo 8 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _campoSenha(
                controller: widget.confirmacaoController,
                label: 'Confirmar nova senha',
                oculta: _confirmacaoOculta,
                onToggle: () =>
                    setState(() => _confirmacaoOculta = !_confirmacaoOculta),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirme a nova senha';
                  if (v != widget.novaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: widget.viewModel.erroSalvamento,
                builder: (context, erro, _) => erro != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          erro,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: salvando ? null : widget.onCancelar,
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: salvando ? null : widget.onSalvar,
                      child: salvando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Salvar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificacoesSection extends StatelessWidget {
  const _NotificacoesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.profileNotificationsSection,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _SettingsTile(
              icon: Icons.tune_outlined,
              title: l10n.profileNotificationPrefs,
              trailing: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.outline,
              ),
              onTap: () => context.push('/perfil/preferencias-notificacao'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenciasSection extends StatelessWidget {
  const _PreferenciasSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.profileAppPreferences,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.profileDarkMode,
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.modoEscuro,
                    builder: (_, valor, __) => Switch(
                      value: valor,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (v) => viewModel.modoEscuro.value = v,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                ValueListenableBuilder<Locale>(
                  valueListenable: viewModel.idiomaAtual,
                  builder: (_, locale, __) => _SettingsTile(
                    icon: Icons.language_outlined,
                    title: l10n.profileLanguage,
                    trailing: Text(
                      locale.languageCode == 'pt' ? 'PT-BR' : 'EN-US',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onTap: viewModel.alternarIdioma,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AcoesSection extends StatelessWidget {
  const _AcoesSection({required this.viewModel, required this.onLogout});

  final ProfileViewModel viewModel;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: viewModel.exportandoLogs,
            builder: (_, exportando, __) => OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: exportando ? null : viewModel.exportarLogs,
              child: exportando
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bug_report_outlined,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.profileExportLogs,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: viewModel.estaCarregando,
            builder: (_, carregando, __) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.onSurface,
                elevation: 0,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: carregando ? null : onLogout,
              child: carregando
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.errorContainer,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.logout,
                          color: theme.colorScheme.errorContainer,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.profileLogoutButton,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.errorContainer,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelCampo extends StatelessWidget {
  const _LabelCampo({required this.texto, required this.theme});

  final String texto;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
