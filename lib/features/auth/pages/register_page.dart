import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/core/l10n/app_localizations.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
        title: Text(
          l10n.registerTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.displayLarge?.color,
          ),
        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _HeaderArea(theme: theme),
                  const _RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderArea extends StatelessWidget {
  const _HeaderArea({required this.theme});

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
              Icons.person_add_alt_1,
              size: 30,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.registerSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  static final _regexEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  String _selectedClassification = 'estudante';

  bool get _podeSubmeter =>
      _nameController.text.trim().isNotEmpty &&
      _regexEmail.hasMatch(_emailController.text.trim()) &&
      _passwordController.text.length >= 8 &&
      _confirmPasswordController.text == _passwordController.text;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  List<(String, String)> _classificacoes(AppLocalizations l10n) => [
    ('estudante', l10n.registerClassStudent),
    ('professor', l10n.registerClassTeacher),
    ('arqueologo', l10n.registerClassArchaeologist),
  ];

  Future<void> _handleRegister(AuthNotifier notifier) async {
    if (!_formKey.currentState!.validate()) return;

    await notifier.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      classificacao: _selectedClassification,
    );

    if (!mounted) return;
    if (notifier.status == AuthStatus.authenticated) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = AppScope.of(context).authNotifier;
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;
    final classificacoes = _classificacoes(l10n);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          final emailValido = _regexEmail.hasMatch(
            _emailController.text.trim(),
          );
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  l10n.registerFullName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.registerFullNameHint,
                    suffixIcon: _nameController.text.isEmpty
                        ? null
                        : Icon(
                            _nameController.text.trim().isNotEmpty
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            color: _nameController.text.trim().isNotEmpty
                                ? AppColors.success
                                : theme.colorScheme.error,
                            size: 20,
                          ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.registerFullNameRequired
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.loginEmailLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.registerEmailHint,
                    suffixIcon: _emailController.text.isEmpty
                        ? null
                        : Icon(
                            emailValido
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            color: emailValido
                                ? AppColors.success
                                : theme.colorScheme.error,
                            size: 20,
                          ),
                  ),
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
                const SizedBox(height: 16),
                Text(
                  l10n.registerClassification,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedClassification,
                  decoration: InputDecoration(
                    hintText: l10n.registerClassificationHint,
                  ),
                  items: classificacoes
                      .map(
                        (e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedClassification = v!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.registerPasswordLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.registerPasswordHint,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 8)
                      ? l10n.registerPasswordMin
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.registerConfirmPassword,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirmPassword,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.registerConfirmPasswordHint,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (v) => v != _passwordController.text
                      ? l10n.registerPasswordMismatch
                      : null,
                ),
                if (notifier.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    notifier.errorMessage!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: (notifier.isLoading || !_podeSubmeter)
                      ? null
                      : () => _handleRegister(notifier),
                  child: notifier.isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.registerButton,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.person_add_alt_outlined,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.canPop() ? context.pop() : context.go('/login');
                  },
                  child: Text(
                    l10n.registerHaveAccount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.registerTermsText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('#');
                        }
                      },
                      child: Text(
                        l10n.registerTermsService,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.surfaceTint,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      l10n.registerTermsAnd,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('#');
                        }
                      },
                      child: Text(
                        l10n.registerPrivacyPolicy,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.surfaceTint,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
