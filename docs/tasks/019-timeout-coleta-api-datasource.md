# Task 019 — Timeout na Requisição HTTP de Coletas

## Objetivo
Adicionar `.timeout()` à chamada HTTP em `ColetaApiDatasourceImpl.fetchMinhas` para evitar que a requisição pendutre indefinidamente em campo com conexão instável.

## Contexto
O método `fetchMinhas` em `coleta_api_datasource.dart` faz um `httpClient.get(...)` sem encadear `.timeout()`. Em condições de rede ruim (cenário comum em trabalho de campo), a requisição pode bloquear indefinidamente. O padrão já adotado em `AuthService` é usar `.timeout(const Duration(seconds: 15))` com captura explícita de `TimeoutException`.

## Escopo
- Encadear `.timeout(_kTimeoutRequisicao)` na chamada `httpClient.get(...)`.
- Capturar `TimeoutException` no bloco `catch` e registrar via `log()`.
- O retorno em caso de timeout deve continuar sendo `[]` (falha silenciosa), pois `fetchMinhas` é usada como pull de dados em background.

## Critérios de Aceite
- [ ] A chamada `httpClient.get(...)` encadeia `.timeout(const Duration(seconds: 15))`.
- [ ] `TimeoutException` é capturada explicitamente e registrada com `log()`.
- [ ] O retorno continua sendo `[]` em caso de timeout (sem quebra de contrato da interface).
- [ ] `flutter analyze` passa sem avisos.

## Arquivos Relevantes
- `lib/features/coleta/data/datasources/coleta_api_datasource.dart` (linha 29)

## Prioridade
Média — não expõe erros técnicos ao usuário, mas pode travar operações de background em campo.
