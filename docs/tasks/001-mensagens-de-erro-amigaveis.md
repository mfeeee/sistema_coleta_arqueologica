# Task 001 — Mensagens de Erro Amigáveis no App

## Objetivo
Substituir mensagens de erro genéricas por textos claros e contextuais, melhorando a experiência do usuário em fluxos de autenticação e coleta.

## Contexto
Atualmente, erros de rede ou falhas de validação retornam mensagens técnicas (ex.: exceções Dart ou códigos HTTP crus) que não orientam o usuário sobre o que fazer a seguir.

## Escopo
- Mapear os erros possíveis em `AuthService` e `AuthNotifier` (ex.: credenciais inválidas, timeout, sem conexão).
- Criar uma classe utilitária `TratadorDeErros` em `lib/core/utils/` que converta exceções em strings legíveis em português.
- Atualizar as páginas de login e cadastro para exibir as mensagens via `SnackBar` ou widget de erro inline.

## Critérios de Aceite
- [ ] Erro de credenciais inválidas exibe: "E-mail ou senha incorretos. Verifique e tente novamente."
- [ ] Erro de sem conexão exibe: "Sem conexão com a internet. Verifique sua rede."
- [ ] Timeout exibe: "O servidor demorou para responder. Tente novamente em instantes."
- [ ] Nenhuma mensagem de erro técnica (stack trace, nome de exceção) é exibida ao usuário final.

## Arquivos Relevantes
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/features/auth/presentation/viewmodels/auth_notifier.dart`
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/register_page.dart`
- `lib/core/utils/` (novo arquivo `tratador_de_erros.dart`)

## Prioridade
Alta — impacta diretamente a usabilidade em campo.
