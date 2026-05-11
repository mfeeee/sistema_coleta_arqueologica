# Task 013 — Implementar Renovação de Token de Sessão

## Objetivo
Implementar renovação automática do token JWT quando a sessão expirar, evitando que o usuário seja deslogado abruptamente durante trabalho de campo.

## Contexto
`AuthService.refreshToken()` (linha 142-146) retorna `false` com log, sem implementação. O `AuthenticatedHttpClient` não intercepta respostas 401 para tentar renovar o token — o usuário simplesmente recebe erro de autorização sem feedback adequado. O backend usa Laravel Sanctum, que suporta tokens com expiração configurável.

## Escopo

### Verificar contrato do backend
- Confirmar se existe endpoint `POST /auth/refresh` no Laravel.
- Alternativa Sanctum: verificar se o token tem expiração configurada (`SANCTUM_TOKEN_EXPIRATION`) e qual a estratégia de renovação (sliding window vs. fixed expiry).

### Implementação Flutter
- Implementar `AuthService.renovarToken()` que chama o endpoint de refresh com o token atual.
- Em `AuthenticatedHttpClient`: adicionar interceptor de resposta 401:
  1. Tenta `renovarToken()` uma vez.
  2. Se sucesso: re-executa a requisição original com novo token.
  3. Se falha: chama `AuthNotifier.sair()` e redireciona para `/login` com mensagem "Sessão expirada. Faça login novamente."
- Proteger contra loop infinito de refresh (flag `_renovandoToken`).
- Garantir que requisições paralelas aguardem o refresh em andamento (queue pattern).

## Critérios de Aceite
- [ ] Token expirado durante sync: renovação automática e retry transparente.
- [ ] Refresh falha (token inválido): logout automático com mensagem clara.
- [ ] Múltiplas requisições paralelas com 401 não disparam múltiplos refreshes.
- [ ] Usuário não perde dados de coleta em andamento quando sessão expira.

## Arquivos Relevantes
- `lib/features/auth/data/services/auth_service.dart` (linha 142, stub)
- `lib/core/network/authenticated_http_client.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`

## Prioridade
**Média** — crítico para sessões longas em campo sem acesso a computador para re-login.
