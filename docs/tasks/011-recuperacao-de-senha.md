# Task 011 — Implementar Fluxo de Recuperação de Senha

## Objetivo
Completar o fluxo de recuperação de senha, atualmente com TODO na linha 131 de `recover_password_page.dart`, integrando com o endpoint do backend Laravel.

## Contexto
A rota `/recover-password` existe no GoRouter e a `RecoverPasswordPage` tem UI de campo de e-mail, mas o botão de envio não faz nada (TODO comentado). O backend Laravel usa Sanctum/Fortify com suporte nativo a password reset via e-mail.

## Escopo

### Backend (verificar contrato antes de implementar)
- Confirmar endpoint: `POST /auth/forgot-password { email }`.
- Confirmar resposta esperada (200 com mensagem, 422 se e-mail não encontrado).

### Dart/Flutter
- Adicionar `AuthService.solicitarRecuperacaoSenha(String email)` em `auth_service.dart`.
- Adicionar método correspondente em `AuthNotifier` com estados: idle, carregando, emailEnviado, erro.
- Conectar `RecoverPasswordPage` ao `AuthNotifier`:
  - Validar formato de e-mail antes de submeter.
  - Exibir feedback visual: `CircularProgressIndicator` no botão durante request.
  - Sucesso: exibir mensagem "Verifique seu e-mail para redefinir a senha." e botão "Voltar ao login".
  - Erro: mensagem específica (e-mail não cadastrado, falha de rede).
- Implementar tela de redefinição de senha (`ResetPasswordPage`) para receber o token via deep link (se o backend suportar).

## Critérios de Aceite
- [ ] E-mail inválido exibe erro inline antes de qualquer request.
- [ ] Request bem-sucedido exibe mensagem de confirmação.
- [ ] E-mail não cadastrado exibe mensagem amigável (sem vazar se o e-mail existe ou não, por segurança).
- [ ] Falha de rede exibe mensagem de retry.
- [ ] Botão desabilitado durante carregamento.

## Arquivos Relevantes
- `lib/features/auth/presentation/pages/recover_password_page.dart` (linha 131, TODO)
- `lib/features/auth/data/services/auth_service.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`
- `lib/core/router/app_router.dart` (adicionar rota de reset se necessário)

## Prioridade
**Média** — essencial para usabilidade em produção; sem isso, usuários que esquecem a senha ficam bloqueados.
