# Task 010 — Perfil do Usuário com Dados Reais e Ações Funcionais

## Objetivo
Conectar a `ProfilePage` a dados reais do usuário autenticado e implementar as ações que atualmente são stubs (logout funcional, switches de preferência, exportação de logs).

## Contexto
`lib/features/profile/presentation/pages/profile_page.dart` exibe nome, e-mail, avatar e classificação hardcoded (linhas 96-122). Os switches de notificação e modo escuro não persistem estado. O botão de logout apenas navega para `/login` sem chamar `AuthNotifier.sair()`. TODOs nas linhas 39 e 346 marcam settings e export como não implementados.

## Escopo
- Criar `ProfileViewModel` em `lib/features/profile/presentation/viewmodels/profile_viewmodel.dart`:
  - Ler nome, e-mail e classificação do `AuthNotifier` / `SecureStorageService`.
  - `ValueNotifier<bool> notificacoesAtivas` — persistido em `SharedPreferences` ou `SecureStorageService`.
  - `ValueNotifier<bool> modoEscuro` — integrado ao `ThemeMode` do app via `AppScope`.
- Implementar logout real: chamar `AuthNotifier.sair()` que revoga token e limpa storage.
- Conectar switches de notificação e modo escuro ao ViewModel (persiste entre sessões).
- Implementar exportação de logs: gerar arquivo `.txt` com os últimos N logs via `dart:developer` records e acionar compartilhamento via `share_plus` (ou `path_provider` + file picker).
- Exibir avatar com iniciais do nome quando sem foto (sem depender de URL hardcoded).

## Critérios de Aceite
- [ ] Nome, e-mail e classificação do usuário logado exibidos corretamente.
- [ ] Logout chama `AuthNotifier.sair()`, limpa token e redireciona para `/login`.
- [ ] Switch de modo escuro persiste após fechar e reabrir o app.
- [ ] Switch de notificações persiste entre sessões.
- [ ] Exportar logs gera arquivo compartilhável com conteúdo real.
- [ ] Nenhum dado hardcoded na página.

## Arquivos Relevantes
- `lib/features/profile/presentation/pages/profile_page.dart`
- `lib/features/profile/presentation/viewmodels/profile_viewmodel.dart` (criar)
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`
- `lib/core/services/secure_storage_service.dart`
- `lib/core/theme/` (integração ThemeMode)

## Prioridade
**Média** — não bloqueia o fluxo core, mas é fundamental para a experiência completa.
