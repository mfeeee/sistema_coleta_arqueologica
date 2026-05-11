# Task 004 — Implementar Geolocalização Real (Remover Stub)

## Objetivo
Substituir as coordenadas hardcoded do `GeolocatorHelper` pela captura real do GPS do dispositivo, desbloqueando a funcionalidade central do fluxo de nova coleta.

## Contexto
`lib/core/services/geolocator_helper.dart` retorna coordenadas fixas de Parnaíba (-8.8475, -42.5480) após um delay artificial de 2 segundos. O pacote `geolocator: ^14.0.2` já está instalado no `pubspec.yaml` mas nunca usado de fato. `ColetaViewModel` tem um TODO explícito na linha 35 para implementar esse fluxo.

## Escopo
- Implementar `GeolocatorHelper.obterLocalizacaoAtual()` usando `Geolocator.getCurrentPosition()` com `LocationAccuracy.high`.
- Tratar estados de permissão: `denied`, `deniedForever`, e `whileInUse` vs `always`.
- Solicitar permissão ao usuário antes da captura, com fallback amigável se negada.
- Configurar permissões nativas:
  - Android: `ACCESS_FINE_LOCATION` e `ACCESS_COARSE_LOCATION` no `AndroidManifest.xml`.
  - iOS: `NSLocationWhenInUseUsageDescription` no `Info.plist`.
- Implementar timeout de 15 segundos com mensagem de erro clara.
- Expor `ValueNotifier<LocationStatus>` no `ColetaViewModel` para a UI reagir ao estado (buscando, obtido, erro, permissão negada).

## Critérios de Aceite
- [ ] Em dispositivo/emulador, o GPS retorna coordenadas reais, não hardcoded.
- [ ] Permissão negada exibe diálogo explicativo com botão para abrir configurações.
- [ ] Permissão `deniedForever` exibe mensagem persistente com link para configurações do SO.
- [ ] Timeout de 15s exibe erro ao usuário sem travar a UI.
- [ ] `flutter analyze` sem warnings relacionados ao geolocator.

## Arquivos Relevantes
- `lib/core/services/geolocator_helper.dart` (reescrever stub)
- `lib/features/coleta/presentation/viewmodels/coleta_viewmodel.dart` (linha 35, TODO)
- `lib/features/coleta/presentation/pages/nova_coleta_page.dart`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

## Prioridade
**Crítica** — sem GPS real, a funcionalidade principal do app é inutilizável em campo.
