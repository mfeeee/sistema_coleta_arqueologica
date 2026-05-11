# Task 020 — Timeout na Requisição HTTP de Logout

## Objetivo
Adicionar `.timeout()` à chamada HTTP do endpoint `/auth/logout` em `AuthService` para evitar que o fluxo de saída fique visualmente travado com servidores lentos ou inacessíveis.

## Contexto
O método `logout()` em `auth_service.dart` faz um `httpClient.post('/auth/logout', ...)` sem `.timeout()`. Embora o `finally { clearAll() }` garanta que o token local seja removido independentemente do resultado da rede, uma requisição travada pode manter a tela de logout em estado de carregamento por tempo indeterminado. Os métodos `login` e `register` no mesmo arquivo já usam `.timeout(_kTimeoutRequisicao)`.

## Escopo
- Encadear `.timeout(_kTimeoutRequisicao)` na chamada `httpClient.post(...)` dentro de `logout()`.
- Nenhuma mudança no comportamento externo: o bloco `finally { clearAll() }` deve ser mantido.

## Critérios de Aceite
- [ ] A chamada `httpClient.post(...)` em `logout()` encadeia `.timeout(const Duration(seconds: 15))`.
- [ ] O bloco `finally { await secureStorage.clearAll() }` permanece inalterado.
- [ ] `flutter analyze` passa sem avisos.

## Arquivos Relevantes
- `lib/core/services/auth_service.dart` (linha 163)

## Prioridade
Baixa — falha já é absorvida pelo `catch`, mas o timeout melhora a experiência de logout em redes lentas.
