# Task 021 — Validação Prematura nos Campos de Login

## Objetivo
Eliminar a exibição das mensagens de validação ("Informe seu e-mail" / "Informe sua senha")
ao abrir a tela de login antes de qualquer interação do usuário.

## Contexto
`LoginPage` usa `AutovalidateMode.onUserInteraction` dentro de um `ListenableBuilder`
vinculado ao `AuthNotifier`. Quando o notifier emite uma notificação na inicialização
(ex.: checar estado de sessão), o Flutter reconstrói o widget `Form` e interpreta essa
reconstrução como "interação", disparando os validadores em campos ainda intocados.
O mesmo padrão existe em `RegisterPage` mas lá os campos têm valores padrão
(Dropdown preenchido) que mascaram o problema.

## Causa Raiz
`AutovalidateMode.onUserInteraction` é propagado pelo `Form` para todos os `FormField`
filhos. Um rebuild do `Form` causado por `ListenableBuilder` pode marcar campos como
"sujos" dependendo da versão do Flutter, revelando erros prematuramente.

## Escopo
- Remover `AutovalidateMode.onUserInteraction` de `LoginPage` e `RegisterPage`.
- Substituir pela estratégia de validação somente no submit:
  `_formKey.currentState!.validate()` já é chamado em `_handleLogin` e
  `_handleRegister` antes de qualquer chamada à API — isso é suficiente.
- O botão já fica desabilitado via `_podeSubmeter` enquanto os campos estiverem
  inválidos, então o feedback de "campos incompletos" já existe via UI sem precisar
  de mensagem de erro inline prematura.
- Manter os `suffixIcon` de check/X no campo de e-mail, que mostram estado em
  tempo real sem exibir texto de erro.

## Critérios de Aceite
- [ ] Abrir o app: tela de login não exibe nenhuma mensagem de erro nos campos.
- [ ] Clicar em "Entrar" com campos vazios: mensagens de erro aparecem inline.
- [ ] Clicar em "Entrar" com e-mail inválido: mensagem de erro aparece no campo.
- [ ] `RegisterPage` tem o mesmo comportamento — sem erros ao abrir.
- [ ] `flutter analyze` sem warnings.

## Arquivos Relevantes
- `lib/features/auth/pages/login_page.dart`
- `lib/features/auth/pages/register_page.dart`

## Prioridade
Alta — erro visível na primeira tela do app, impacta a primeira impressão.
