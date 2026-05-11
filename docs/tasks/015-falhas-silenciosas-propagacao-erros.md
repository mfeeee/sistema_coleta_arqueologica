# Task 015 — Eliminar Falhas Silenciosas e Padronizar Propagação de Erros

## Objetivo
Substituir o padrão de capturar exceções e retornar listas vazias/valores default por uma hierarquia de exceções de domínio, garantindo que falhas sejam sempre visíveis ao usuário ou ao sistema de log.

## Contexto
Múltiplos datasources retornam `[]` em catch sem propagar o erro:
- `ColetaApiDatasource.fetchMinhas()` — retorna `[]` em qualquer falha.
- `PullService` em `AuthNotifier` — erros capturados com `.catchError((_) {})`.
- `ProximidadeService` — sem try/catch, crashes não reportados.

O usuário não sabe se uma lista vazia significa "sem dados" ou "erro de rede".

## Escopo
- Criar hierarquia de exceções em `lib/core/errors/`:
  ```
  ArqueoException (base)
  ├── ErroDeRede (timeout, socket)
  ├── ErroDeAutorizacao (401, 403)
  ├── ErroDeServidor (5xx)
  ├── ErroDeValidacao (422)
  └── ErroDeBancoDeDados (sqlite exceptions)
  ```
- Refatorar datasources para lançar `ArqueoException` em vez de retornar listas vazias.
- Refatorar repositórios para propagar exceções até o ViewModel.
- ViewModels expõem `ValueNotifier<String?> erroAtual` que a UI exibe via `SnackBar` ou widget inline.
- Corrigir `.catchError((_) {})` em `AuthNotifier` (pull service): logar e expor erro no notifier.
- Garantir que todo `catch` registre stacktrace via `log(..., error: e, stackTrace: st)`.

## Critérios de Aceite
- [ ] Falha de rede em `fetchMinhas` exibe mensagem na UI, não lista vazia silenciosa.
- [ ] Falha no Pull pós-login é logada com stacktrace completo e exibe aviso não-bloqueante.
- [ ] Nenhum `catch` descarta exceção sem log.
- [ ] `flutter analyze` sem novos warnings de supressão de erros.
- [ ] Teste unitário verifica que `ColetaApiDatasource` lança `ErroDeRede` em timeout.

## Arquivos Relevantes
- `lib/core/errors/` (criar hierarquia)
- `lib/features/coleta/data/datasources/coleta_api_datasource.dart`
- `lib/features/sync/data/datasources/sync_api_datasource.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart` (catchError)
- Todos os ViewModels (adicionar `ValueNotifier<String?> erroAtual`)

## Prioridade
**Alta** — falhas silenciosas são especialmente perigosas em app de coleta científica onde "sem dados" pode ser confundido com "dados coletados com sucesso".
