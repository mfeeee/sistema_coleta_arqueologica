# Task 014 — Cobertura de Testes: Unidade, Widget e Integração

## Objetivo
Estabelecer cobertura de testes mínima para as camadas críticas do app, criando uma base de regressão que permita evoluir o projeto com segurança.

## Contexto
O diretório `test/` está completamente vazio. Nenhuma classe tem testes. O projeto está em fase de crescimento rápido e mudanças em serviços core (auth, sync, proximidade) não têm proteção contra regressões. A task 003 cobre especificamente a rota de cadastro; esta task cobre o restante do projeto.

## Escopo

### Testes Unitários (Priority 1)
**ProximidadeService:**
- Dois pontos idênticos → distância 0.
- Parnaíba e Teresina → distância correta (~300km).
- Raio 500m: ponto dentro deve ser detectado, ponto fora não.

**SyncRepository:**
- Coleta `pendente` é enviada e marcada como `sincronizado`.
- Coleta com resposta 409 é marcada como `conflito`.
- Falha de rede mantém status `pendente`.

**ColetaFormNotifier:**
- Passo 1 inválido (nome vazio) → `passo1Valido == false`.
- Toggle de artefato adiciona/remove da lista corretamente.
- `toResult()` retorna entity com todos os campos preenchidos.

**AuthService:**
- Login com credenciais válidas (fake datasource) → token salvo, retorno `AuthSuccess`.
- Login com 401 → retorno `AuthFailure` com mensagem.

### Testes de Widget (Priority 2)
- `LoginPage`: submissão válida aciona ViewModel; campos inválidos não submetem.
- `SyncPage`: estado `sincronizando` exibe `CircularProgressIndicator`; estado `concluido` exibe resumo.
- `ColetaWizardWidget`: botão "Próximo" desabilitado quando passo inválido.

### Testes de Integração (Priority 3)
- Fluxo completo: login → nova coleta → salvar → sync (contra `mock-api` local).

## Convenções
- Seguir padrão Arrange-Act-Assert.
- Usar fakes/stubs em vez de `mockito` (conforme diretriz do CLAUDE.md).
- Criar fakes em `test/helpers/fakes/` reutilizáveis entre suites.
- Assertions com `package:checks` ao invés dos matchers default.

## Critérios de Aceite
- [ ] `flutter test` passa sem erros.
- [ ] Cobertura mínima: `ProximidadeService` 100%, `SyncRepository` 80%, `ColetaFormNotifier` 80%.
- [ ] CI (se configurado) executa testes em cada PR.
- [ ] Nenhum teste usa `mockito` com geração de código.

## Estrutura de Pastas
```
test/
├── helpers/
│   └── fakes/
│       ├── fake_coleta_repository.dart
│       ├── fake_sync_api_datasource.dart
│       └── fake_secure_storage_service.dart
├── features/
│   ├── auth/
│   │   └── auth_service_test.dart
│   ├── coleta/
│   │   ├── proximidade_service_test.dart
│   │   └── coleta_form_notifier_test.dart
│   └── sync/
│       └── sync_repository_test.dart
└── widgets/
    ├── login_page_test.dart
    └── sync_page_test.dart
```

## Prioridade
**Alta** — sem testes, qualquer refactor das tasks 004-013 pode quebrar funcionalidades silenciosamente.
