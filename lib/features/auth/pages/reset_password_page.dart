import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/features/auth/data/password_reset_repository.dart';
import 'package:sistema_coleta_arqueologica/features/auth/presentation/viewmodels/password_reset_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/auth/presentation/viewmodels/password_reset_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, this.token, this.email});

  final String? token;
  final String? email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  PasswordResetNotifier? _notifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_notifier == null) {
      final scope = AppScope.of(context);
      _notifier = PasswordResetNotifier(
        repositorio: PasswordResetRepository(dio: scope.dioPublic),
      );
      _notifier!.addListener(_escutarEstado);
    }
  }

  void _escutarEstado() {
    final estado = _notifier?.estado;
    if (estado is! PasswordResetError) return;
    final mensagem = estado.mensagem;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    });
  }

  @override
  void dispose() {
    _notifier?.removeListener(_escutarEstado);
    _notifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = _notifier;
    if (notifier == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListenableBuilder(
                listenable: notifier,
                builder: (context, _) {
                  if (notifier.estado is PasswordResetSuccess) {
                    return _SucessoRedefinicao(theme: theme);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeaderRedefinicao(theme: theme),
                      _ResetForm(
                        notifier: notifier,
                        tokenInicial: widget.token,
                        emailInicial: widget.email,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SucessoRedefinicao extends StatelessWidget {
  const _SucessoRedefinicao({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.lock_open_outlined,
          size: 72,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Senha Redefinida',
          textAlign: TextAlign.center,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 28,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sua senha foi alterada com sucesso. Faça login com a nova senha.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => context.go('/login'),
          child: const Text(
            'Ir para Login',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _HeaderRedefinicao extends StatelessWidget {
  const _HeaderRedefinicao({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.lock_reset,
              size: 50,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Redefinir Senha',
          textAlign: TextAlign.center,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 30,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Informe o código recebido no e-mail e crie uma nova senha.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}

class _ResetForm extends StatefulWidget {
  const _ResetForm({
    required this.notifier,
    this.tokenInicial,
    this.emailInicial,
  });

  final PasswordResetNotifier notifier;
  final String? tokenInicial;
  final String? emailInicial;

  @override
  State<_ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<_ResetForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenController;
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  bool _senhaOculta = true;
  bool _confirmacaoOculta = true;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.tokenInicial ?? '');
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _senhaController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.notifier.confirmarReset(
      widget.emailInicial ?? '',
      _tokenController.text.trim(),
      _senhaController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = widget.notifier;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LabelCampo(texto: 'Código de Verificação', theme: theme),
            const SizedBox(height: 8),
            Semantics(
              label: 'Código de verificação recebido por e-mail',
              child: TextFormField(
                controller: _tokenController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Cole ou digite o código',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe o código recebido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            _LabelCampo(texto: 'Nova Senha', theme: theme),
            const SizedBox(height: 8),
            Semantics(
              label: 'Nova senha',
              child: TextFormField(
                controller: _senhaController,
                obscureText: _senhaOculta,
                decoration: InputDecoration(
                  hintText: 'Mínimo 8 caracteres',
                  suffixIcon: IconButton(
                    tooltip: _senhaOculta ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(
                      _senhaOculta
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _senhaOculta = !_senhaOculta),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a nova senha';
                  if (v.length < 8) {
                    return 'A senha deve ter ao menos 8 caracteres';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            _LabelCampo(texto: 'Confirmar Nova Senha', theme: theme),
            const SizedBox(height: 8),
            Semantics(
              label: 'Confirmação da nova senha',
              child: TextFormField(
                controller: _confirmacaoController,
                obscureText: _confirmacaoOculta,
                decoration: InputDecoration(
                  hintText: 'Repita a nova senha',
                  suffixIcon: IconButton(
                    tooltip: _confirmacaoOculta
                        ? 'Mostrar senha'
                        : 'Ocultar senha',
                    icon: Icon(
                      _confirmacaoOculta
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(
                      () => _confirmacaoOculta = !_confirmacaoOculta,
                    ),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirme a nova senha';
                  if (v != _senhaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            Tooltip(
              message: 'Confirmar redefinição de senha',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: notifier.carregando ? null : _handleConfirmar,
                child: notifier.carregando
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Redefinir Senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lembrou sua senha?', style: theme.textTheme.bodyMedium),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Fazer login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
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
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
