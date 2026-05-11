# Task 003 — Teste Automatizado da Rota de Cadastro na API

## Objetivo
Criar testes automatizados para a rota de cadastro, cobrindo cenários de sucesso e falha, garantindo que regressões sejam detectadas antes do merge.

## Contexto
A rota de cadastro (`POST /api/register`) foi implementada recentemente, mas não possui cobertura de testes. Mudanças futuras no `AuthService` ou no contrato da API podem introduzir bugs silenciosos.

## Escopo

### Testes de Unidade (`test/features/auth/`)
- Testar `AuthService.registrar()` com um datasource fake:
  - Sucesso: token retornado e armazenado.
  - Falha 422 (validação): exceção correta lançada.
  - Falha de rede: exceção de conectividade lançada.

### Testes de Widget (`test/features/auth/presentation/`)
- Testar `RegisterPage`:
  - Submissão com campos válidos chama o ViewModel.
  - Submissão com campos inválidos não chama o ViewModel.
  - Estado de carregamento desabilita o botão.

### Testes de Integração (`integration_test/`) — opcional
- Fluxo completo de cadastro contra o mock-api local.

## Critérios de Aceite
- [ ] Cobertura mínima de 3 cenários no `AuthService`.
- [ ] Testes de widget cobrem o caminho feliz e o caminho de erro.
- [ ] `flutter test` passa sem erros em CI.
- [ ] Fake/stub usado no lugar de mocks gerados por código (conforme diretriz do projeto).

## Arquivos Relevantes
- `lib/features/auth/data/services/auth_service.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`
- `test/features/auth/` (criar estrutura de pastas)
- `mock-api/` (servidor local para testes de integração)

## Prioridade
Média — essencial para sustentabilidade do projeto a longo prazo.
