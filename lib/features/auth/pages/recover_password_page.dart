import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late final AuthNotifier _notifier;
  String _emailDigitado = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier = AppScope.of(context).authNotifier;
  }

  @override
  void dispose() {
    _notifier.resetarEstadoRecuperacao();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                listenable: _notifier,
                builder: (context, _) {
                  if (_notifier.recuperacaoStatus ==
                      RecuperacaoStatus.sucesso) {
                    return _SucessoEnvio(theme: theme, email: _emailDigitado);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeaderArea(theme: theme),
                      _RecoverPasswordForm(
                        notifier: _notifier,
                        onEmailEnviado: (email) =>
                            setState(() => _emailDigitado = email),
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

class _SucessoEnvio extends StatelessWidget {
  const _SucessoEnvio({required this.theme, required this.email});

  final ThemeData theme;
  final String email;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.mark_email_read_outlined,
          size: 72,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.recoverPasswordEmailSent,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 28,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.recoverPasswordEmailSentDesc,
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
          child: Text(
            l10n.recoverPasswordBackToLogin,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () =>
              context.go('/reset-password', extra: {'email': email}),
          child: Text(
            l10n.recoverPasswordEnterCode,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _HeaderArea extends StatelessWidget {
  const _HeaderArea({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              Icons.architecture,
              size: 50,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.recoverPasswordTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 30,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.recoverPasswordSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}

class _RecoverPasswordForm extends StatefulWidget {
  const _RecoverPasswordForm({
    required this.notifier,
    required this.onEmailEnviado,
  });

  final AuthNotifier notifier;
  final void Function(String email) onEmailEnviado;

  @override
  State<_RecoverPasswordForm> createState() => _RecoverPasswordFormState();
}

class _RecoverPasswordFormState extends State<_RecoverPasswordForm> {
  static final _regexEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool get _podeSubmeter => _regexEmail.hasMatch(_emailController.text.trim());

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleEnviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    widget.onEmailEnviado(email);
    await widget.notifier.solicitarRecuperacaoSenha(email);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final notifier = widget.notifier;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.loginEmailLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: l10n.registerEmailHint),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l10n.loginEmailRequired;
                }
                if (!_regexEmail.hasMatch(v.trim())) {
                  return l10n.commonInvalidEmail;
                }
                return null;
              },
            ),
            if (notifier.recuperacaoStatus == RecuperacaoStatus.erro &&
                notifier.recuperacaoErro != null) ...[
              const SizedBox(height: 8),
              Text(
                notifier.recuperacaoErro!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: (notifier.recuperacaoCarregando || !_podeSubmeter)
                  ? null
                  : _handleEnviar,
              child: notifier.recuperacaoCarregando
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.recoverPasswordSendLink,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.recoverPasswordRemember,
                  style: theme.textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/login');
                    }
                  },
                  child: Text(
                    l10n.recoverPasswordDoLogin,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
