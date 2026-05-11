# Task 022 — Barra de Progresso da Sincronização Sempre Parada em 65%

## Objetivo
Corrigir a barra de progresso na tela de Sincronizar para refletir o estado real
do processo de envio de coletas ao servidor.

## Causa Raiz
Em `_SyncProgressCard` (`sync_page.dart`), o `TweenAnimationBuilder<double>`
recebe o `progresso` real como `end` e anima corretamente, mas o `builder`
ignora o parâmetro `value` e passa `widthFactor: 0.65` diretamente ao
`FractionallySizedBox`. A barra fica estática em 65% independentemente do
estado da sincronização.

```dart
// Atual — hardcoded:
FractionallySizedBox(
  widthFactor: 0.65,    // nunca muda
  ...
)

// Correto:
FractionallySizedBox(
  widthFactor: value,   // valor animado pelo Tween
  ...
)
```

## Escopo
- Substituir `widthFactor: 0.65` por `widthFactor: value` em `_SyncProgressCard`.
- Verificar se `progresso` é calculado corretamente:
  `progresso = resumo != null ? (sucessos / total).clamp(0.0, 1.0) : 0.0`
  - Antes de iniciar: barra deve estar em 0%.
  - Durante: barra deve avançar conforme `sucessos / total`.
  - Concluído com sucesso total: barra deve chegar a 100%.

## Critérios de Aceite
- [ ] Antes de qualquer sincronização a barra mostra 0%.
- [ ] Após sincronização bem-sucedida a barra reflete `sucessos / total` em %.
- [ ] A animação de 600ms do `TweenAnimationBuilder` funciona visivelmente ao
      avançar de um estado para outro.
- [ ] `flutter analyze` sem warnings.

## Arquivo Relevante
- `lib/features/sync/presentation/pages/sync_page.dart` — classe `_SyncProgressCard`,
  dentro do `TweenAnimationBuilder.builder`, linha do `FractionallySizedBox`.

## Prioridade
Média — funcional cosmético, mas induz o usuário a crer que já sincronizou 65%
dos dados quando ainda não iniciou nenhuma operação.
