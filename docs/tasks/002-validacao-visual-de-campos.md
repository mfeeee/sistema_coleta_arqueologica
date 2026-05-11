# Task 002 — Validação Visual dos Campos Antes do Request

## Objetivo
Implementar validação em tempo real nos formulários de login e cadastro, fornecendo feedback visual imediato antes de qualquer chamada à API.

## Contexto
Os formulários atuais enviam o request sem validar localmente os campos, gerando round-trips desnecessários à API e uma experiência ruim quando campos obrigatórios estão vazios ou mal formatados.

## Escopo
- Adicionar validadores (`validator`) nos `TextFormField` das páginas de login e cadastro usando `Form` + `GlobalKey<FormState>`.
- Implementar validação de formato de e-mail com `RegExp`.
- Implementar validação de senha mínima (ex.: 8 caracteres).
- Exibir ícones de estado (erro/sucesso) via `suffixIcon` nos campos.
- Bloquear o botão de submissão enquanto o formulário for inválido.

## Critérios de Aceite
- [ ] Campo de e-mail exibe erro inline se o formato for inválido ao perder foco.
- [ ] Campo de senha exibe erro se tiver menos de 8 caracteres.
- [ ] Campo de confirmação de senha exibe erro se os valores não coincidirem.
- [ ] Botão de cadastro/login fica desabilitado enquanto houver campos inválidos.
- [ ] Nenhum request é feito com campos inválidos.

## Arquivos Relevantes
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/register_page.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`

## Prioridade
Alta — reduz carga na API e melhora a experiência offline.
