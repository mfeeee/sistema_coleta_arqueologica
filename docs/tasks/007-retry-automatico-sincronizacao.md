# Task 007 — Retry Automático com Backoff Exponencial na Sincronização

## Objetivo
Implementar retry automático com backoff exponencial para falhas de rede transitórias durante a sincronização, reduzindo a necessidade de intervenção manual do usuário em campo com conexão instável.

## Contexto
`SyncApiDatasource` tenta cada coleta uma única vez. Em caso de `DioException` de rede (timeout, socket closed, server error 5xx), a coleta permanece `pendente` e o usuário precisa re-abrir o app e tentar novamente. Em campo, com 3G instável, isso gera frustração e risco de dados não sincronizados.

## Escopo
- Criar função utilitária `comRetry<T>()` em `lib/core/utils/retry_util.dart`:
  - Parâmetros: `maxTentativas` (default 3), `delayInicial` (default 1s), fator multiplicador (2x).
  - Só reenvia em erros transitórios: `DioExceptionType.connectionTimeout`, `receiveTimeout`, `connectionError`, e HTTP 5xx.
  - Não reenvia em erros definitivos: 400, 401, 403, 409 (conflito de versão).
- Aplicar `comRetry` em `SyncApiDatasource.enviar()`.
- Expor o número da tentativa atual no `SyncNotifier` para a UI exibir (ex.: "Tentativa 2/3...").
- Adicionar timeout explícito de 30s no `Dio` usado pelo datasource de sync.

## Critérios de Aceite
- [ ] Falha de rede transitória dispara até 3 tentativas com delays 1s, 2s, 4s.
- [ ] Erro 409 (conflito) nunca é retentado.
- [ ] UI exibe "Tentativa N/3" durante retry.
- [ ] Após 3 falhas, coleta permanece `pendente` e log registra stacktrace completo.
- [ ] Timeout de 30s por requisição previne travamento indefinido.

## Arquivos Relevantes
- `lib/core/utils/retry_util.dart` (criar)
- `lib/features/sync/data/datasources/sync_api_datasource.dart`
- `lib/features/sync/presentation/viewmodels/sync_notifier.dart`
- `lib/features/sync/presentation/pages/sync_page.dart`

## Prioridade
**Alta** — operação crítica em ambientes de campo com conectividade intermitente.
