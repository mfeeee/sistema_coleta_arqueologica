# Task 006 — Integrar Detecção de Conectividade Real

## Objetivo
Utilizar o pacote `connectivity_plus` (já instalado) para monitorar o estado de rede em tempo real, substituindo o status "Online" hardcoded e bloqueando operações que exigem internet quando o dispositivo estiver offline.

## Contexto
`connectivity_plus: ^7.1.1` está no `pubspec.yaml` mas nunca importado em nenhum arquivo Dart. Em `ColétasPage`, o badge "Online" é hardcoded. O fluxo de sincronização em `SyncNotifier` não verifica conectividade antes de tentar o POST — falha com erro de rede sem aviso prévio ao usuário.

## Escopo
- Criar `ConectividadeService` em `lib/core/services/conectividade_service.dart`:
  - Expor `ValueNotifier<bool> estaOnline`.
  - Subscrever `Connectivity().onConnectivityChanged` para atualizar o notifier.
  - Método `Future<bool> verificar()` para checagem pontual.
- Registrar `ConectividadeService` no `AppScope` e fazer dispose correto.
- Em `ColétasPage`: substituir badge hardcoded por `ValueListenableBuilder` conectado ao serviço.
- Em `SyncNotifier.sincronizar()`: verificar conectividade antes de iniciar. Se offline, emitir estado `semConexao` com mensagem orientativa.
- Em `NovaColetaPage`: mostrar banner informativo (não bloqueante) quando offline, pois salvar localmente ainda é possível.

## Critérios de Aceite
- [ ] Badge de status em `ColétasPage` reflete o estado real da rede.
- [ ] Tentativa de sync sem conexão exibe: "Sem conexão. Conecte-se à internet para sincronizar."
- [ ] Ao recuperar conexão, o banner some automaticamente.
- [ ] Salvar coleta offline continua funcionando sem erros.
- [ ] `flutter analyze` sem novos warnings.

## Arquivos Relevantes
- `lib/core/services/conectividade_service.dart` (criar)
- `lib/core/di/app_scope.dart`
- `lib/features/sync/presentation/viewmodels/sync_notifier.dart`
- `lib/features/coleta/presentation/pages/coletas_page.dart`
- `lib/features/coleta/presentation/pages/nova_coleta_page.dart`

## Prioridade
**Alta** — o app é offline-first, mas ignora completamente o estado da rede.
