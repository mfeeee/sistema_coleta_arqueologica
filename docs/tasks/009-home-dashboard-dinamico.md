# Task 009 — Home Dashboard com Dados Dinâmicos

## Objetivo
Substituir todos os dados hardcoded da `InicioPage` por valores reais lidos do banco de dados local e do `AuthNotifier`, conectando a UI ao ViewModel conforme a arquitetura do projeto.

## Contexto
`lib/features/home/presentation/pages/inicio_page.dart` exibe:
- Avatar e nome hardcoded "Dr. Silva" (linha 96-98).
- Contadores fixos "42" coletas e "03" pendentes (linhas 302, 338).
- Botão "Nova Coleta" com `onPressed` vazio (linha 73).
- Callbacks de atividades recentes vazios (linhas 417, 426).

## Escopo
- Criar `HomeViewModel` em `lib/features/home/presentation/viewmodels/home_viewmodel.dart`:
  - `ValueNotifier<int> totalColetas` — lido de `ColetaRepository.contarTodas()`.
  - `ValueNotifier<int> coletasPendentes` — lido de `ColetaRepository.contarPorStatus(StatusColeta.pendente)`.
  - `ValueNotifier<List<ColetaEntity>> coletasRecentes` — últimas 5 do repositório local.
  - `ValueNotifier<String> nomeUsuario` — do `AuthNotifier`.
- Adicionar métodos de contagem no `ColetaRepository` (interface + implementação Drift).
- Conectar `InicioPage` ao `HomeViewModel` via `ListenableBuilder`.
- Implementar `onPressed` do botão "Nova Coleta" (navega para `/nova-coleta`).
- Implementar tap nas atividades recentes (navega para `/detalhes-coleta`).
- Remover dados hardcoded de nome, avatar, contadores e atividades.

## Critérios de Aceite
- [ ] Nome do usuário logado aparece corretamente no dashboard.
- [ ] Contadores refletem o estado real do banco local.
- [ ] Botão "Nova Coleta" navega para a tela correta.
- [ ] Lista de atividades recentes exibe as 5 últimas coletas salvas.
- [ ] Tap em atividade recente abre os detalhes da coleta.
- [ ] Dashboard atualiza automaticamente após nova coleta ser salva.

## Arquivos Relevantes
- `lib/features/home/presentation/pages/inicio_page.dart`
- `lib/features/home/presentation/viewmodels/home_viewmodel.dart` (criar)
- `lib/features/coleta/domain/repositories/coleta_repository.dart` (adicionar métodos)
- `lib/features/coleta/data/repositories/coleta_repository_impl.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`

## Prioridade
**Alta** — dashboard com dados falsos passa impressão errada do estado do app para o usuário.
