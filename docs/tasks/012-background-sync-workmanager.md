# Task 012 — Background Sync com WorkManager

## Objetivo
Configurar o `workmanager` (já instalado) para agendar sincronizações automáticas em background, garantindo que coletas pendentes sejam enviadas ao servidor mesmo sem interação explícita do usuário.

## Contexto
`workmanager: ^0.9.0+3` está no `pubspec.yaml` mas nunca inicializado ou registrado. Atualmente, a sincronização só ocorre quando o usuário acessa manualmente a aba "Sincronizar". Em campo, arqueólogos podem esquecer de sincronizar, ou o app pode estar em background quando a conexão é restabelecida.

## Escopo
- Inicializar o WorkManager em `main.dart` com `Workmanager().initialize(callbackDispatcher)`.
- Criar `callbackDispatcher` em `lib/core/services/background_sync_service.dart`:
  - Task name: `sincronizacao_periodica`.
  - Instanciar `AppScope` mínimo (sem UI) para acessar repositório e token.
  - Chamar `SyncRepository.sincronizarTodas()` se houver pendentes e token válido.
  - Registrar resultado via `dart:developer log`.
- Registrar task periódica (frequência mínima: 15 minutos, conforme limitação do WorkManager no Android).
- Configurar constraints: `networkType: NetworkType.connected` para só executar com rede disponível.
- Cancelar e re-registrar a task no login/logout para evitar execuções com token inválido.
- Configurar permissão `RECEIVE_BOOT_COMPLETED` no `AndroidManifest.xml` para persistir entre reinicializações.

## Critérios de Aceite
- [ ] App fechado, com rede disponível e coletas pendentes: sync ocorre automaticamente em até 15 min.
- [ ] Sem rede, a task aguarda até conectividade ser restabelecida.
- [ ] Logout cancela a task agendada.
- [ ] Login registra a task novamente.
- [ ] Logs de background sync são visíveis via `logcat` / `dart:developer`.
- [ ] Sync manual em foreground não conflita com a task de background.

## Arquivos Relevantes
- `lib/main.dart`
- `lib/core/services/background_sync_service.dart` (criar)
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart` (trigger registro/cancelamento)
- `android/app/src/main/AndroidManifest.xml`

## Prioridade
**Média** — melhora significativamente a confiabilidade offline-first sem depender do usuário.

## Observação
WorkManager no iOS tem restrições severas (BGTaskScheduler). A implementação inicial pode ser Android-only, com suporte iOS adicionado separadamente.
