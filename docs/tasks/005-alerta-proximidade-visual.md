# Task 005 — Implementar Widget de Alerta de Proximidade

## Objetivo
Construir o `AlertaProximidadeWidget` atualmente em estado de placeholder, exibindo ao arqueólogo um alerta visual quando ele estiver próximo de um sítio já cadastrado no banco local.

## Contexto
`lib/features/coleta/presentation/widgets/alerta_proximidade_widget.dart` tem TODOs nas linhas 4 e 15 e não renderiza nada útil. O `ProximidadeService` (baseado em Haversine) já calcula distâncias corretamente, e o `ColetaViewModel` já orquestra a chamada ao serviço — o elo que falta é a apresentação do resultado ao usuário.

## Escopo
- Implementar o layout do `AlertaProximidadeWidget`:
  - Ícone de alerta e nome do sítio próximo.
  - Distância em metros/km formatada.
  - Botão "Ver detalhes do sítio" que abre `DetalhesColetaPage` com o id do sítio.
  - Botão "Ignorar e continuar" que descarta o alerta.
- Definir a tipagem correta para `sitios` recebidos via parâmetro (linha 4 do widget).
- Tratar o caso de múltiplos sítios próximos (exibir o mais próximo, ou lista rolável).
- Integrar ao `ColetaViewModel`: após GPS obtido, chamar `ProximidadeService.verificarProximidade()` e expor o resultado via `ValueNotifier<List<BemMaterialEntity>?>`.
- Exibir o widget como `BottomSheet` modal em `NovaColetaPage` quando `sitiosProximos.isNotEmpty`.

## Critérios de Aceite
- [ ] Quando o GPS detectar posição a menos de 500m de um sítio cadastrado, o alerta aparece.
- [ ] O alerta exibe nome e distância do sítio mais próximo.
- [ ] "Ver detalhes" navega para a tela correta.
- [ ] "Ignorar" descarta o alerta e permite continuar a coleta.
- [ ] Com múltiplos sítios próximos, o mais próximo é destacado.
- [ ] Sem sítios próximos, nenhum widget é renderizado.

## Arquivos Relevantes
- `lib/features/coleta/presentation/widgets/alerta_proximidade_widget.dart` (reescrever placeholder)
- `lib/features/coleta/presentation/viewmodels/coleta_viewmodel.dart`
- `lib/features/coleta/presentation/pages/nova_coleta_page.dart`
- `lib/features/coleta/domain/services/proximidade_service.dart`
- `lib/features/bem_material/domain/entities/bem_material_entity.dart`

## Prioridade
**Crítica** — é a feature de segurança arqueológica central do app (evitar duplicação de coletas).
