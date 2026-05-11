# Task 017 — Salvar e Retomar Rascunhos de Coleta

## Objetivo
Implementar o salvamento automático de rascunhos durante o preenchimento do wizard de nova coleta, permitindo que o arqueólogo retome o formulário de onde parou em caso de interrupção (chamada, fechamento acidental do app).

## Contexto
`lib/features/coleta/presentation/pages/nova_coleta_page.dart` tem TODO na linha 73: "Salvar rascunho". O `ColetaFormNotifier` mantém o estado em memória, que é perdido ao fechar a página. Em campo, interrupções são frequentes e perder um formulário parcialmente preenchido é frustrante.

## Escopo
- Adicionar método `salvarRascunho()` em `ColetaFormNotifier`:
  - Serializa o estado atual para JSON via `toMap()`.
  - Persiste em `SecureStorageService` com chave `rascunho_coleta`.
  - Chamado automaticamente em `dispose()` se o formulário estiver incompleto.
- Adicionar método `carregarRascunho()` em `ColetaFormNotifier`:
  - Lê o JSON do storage e restaura os campos.
  - Chamado em `initState()` de `NovaColetaPage`.
- Implementar `ColétasPage` ou `InicioPage` com banner: "Você tem um rascunho salvo. Continuar?" com botões "Continuar" e "Descartar".
- Descartar rascunho ao salvar coleta com sucesso ou ao pressionar "Descartar".
- Serializar apenas campos serializáveis (excluir `File` objects; salvar apenas paths).

## Critérios de Aceite
- [ ] Fechar `NovaColetaPage` em qualquer passo salva o rascunho.
- [ ] Ao reabrir o app, banner de rascunho aparece se houver dados salvos.
- [ ] "Continuar" reabre o wizard no passo onde parou com dados restaurados.
- [ ] "Descartar" limpa o rascunho do storage.
- [ ] Salvar coleta com sucesso remove o rascunho automaticamente.
- [ ] Rascunho não interfere com nova coleta iniciada do zero.

## Arquivos Relevantes
- `lib/features/coleta/presentation/pages/nova_coleta_page.dart` (linha 73, TODO)
- `lib/features/coleta/presentation/viewmodels/coleta_form_notifier.dart`
- `lib/core/services/secure_storage_service.dart`
- `lib/features/coleta/presentation/pages/coletas_page.dart` (banner de rascunho)

## Prioridade
**Média** — QoL importante para trabalho de campo real com interrupções frequentes.
