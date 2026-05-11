# Task 018 — Mensagem de Erro Amigável no Mapeamento por GPS

## Objetivo
Substituir a interpolação de exceção bruta exibida na tela de nova coleta por uma mensagem clara e contextual sobre falha de GPS.

## Contexto
Ao chamar `iniciarMapeamento()` em `ColetaViewModel`, qualquer exceção cai no bloco `catch (e)` que constrói a string `'Falha ao mapear região: $e'`. O `$e` pode expor ao usuário textos técnicos como `SocketException: Connection refused (OS Error: 111)` ou `LocationServiceDisabledException`, quebrando o critério de não exibir mensagens técnicas.

## Escopo
- Substituir `'Falha ao mapear região: $e'` por uma mensagem amigável em `ColetaViewModel`.
- Distinguir, se possível, erros de GPS desativado de erros genéricos de localização.
- Usar `TratadorDeErros.deExcecao(e)` como fallback para exceções de rede, ou uma constante dedicada em `TratadorDeErros` para erros de geolocalização.

## Critérios de Aceite
- [ ] Nenhum texto técnico (tipo de exceção, OS error, stack) é exibido na tela de nova coleta.
- [ ] Erro de GPS desativado exibe mensagem orientando o usuário a ativar a localização.
- [ ] Erro genérico exibe mensagem genérica amigável (ex.: "Não foi possível obter a localização. Tente novamente.").
- [ ] O log interno (`dart:developer log()`) ainda registra a exceção original para diagnóstico.

## Arquivos Relevantes
- `lib/features/coleta/presentation/viewmodels/coleta_viewmodel.dart` (linha 57)
- `lib/core/utils/tratador_de_erros.dart` (adicionar constante de GPS, se necessário)

## Prioridade
Alta — exceção técnica pode aparecer diretamente na tela em campo.
