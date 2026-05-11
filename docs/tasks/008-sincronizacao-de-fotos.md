# Task 008 — Sincronização de Fotos com a API

## Objetivo
Implementar o upload das fotos capturadas durante a coleta para o servidor remoto, já que atualmente apenas os caminhos de arquivo locais são armazenados no campo `dados_coletados`, tornando as fotos invisíveis na sincronização.

## Contexto
`ColetaFormNotifier` armazena os paths das fotos como strings locais (ex.: `/data/user/0/.../image_1.jpg`) no JSON do campo `dadosColetados`. O `SyncApiDatasource` envia esse JSON diretamente, mas o servidor recebe apenas strings de caminho que não existem no ambiente remoto. As fotos nunca chegam ao backend.

## Escopo

### Upload de Fotos
- Criar `FotoUploadService` em `lib/core/services/foto_upload_service.dart`:
  - Recebe lista de paths locais e token JWT.
  - Faz `multipart/form-data` POST para `/v1/mobile/fotos` (ou endpoint a definir com o backend).
  - Retorna lista de URLs remotas após upload bem-sucedido.
- Integrar ao fluxo de sync: antes de enviar a coleta, fazer upload das fotos e substituir paths locais pelas URLs remotas no payload.

### Persistência de URLs
- Adicionar coluna `fotos_urls` na tabela `Coletas` do Drift para armazenar URLs pós-upload.
- Registrar migration de banco (`migrationSteps`) para não quebrar instalações existentes.

### UX
- Exibir progresso de upload por foto (ex.: "Enviando foto 2/5...").
- Distinguir falha de foto de falha de dados: coleta pode ser marcada como `sincronizado` mesmo se uma foto falhar, registrando as fotos pendentes separadamente.

## Critérios de Aceite
- [ ] Após sync, o servidor recebe as fotos como multipart e retorna URLs.
- [ ] Coleta no BD armazena URLs remotas das fotos.
- [ ] Falha de upload de foto individual não bloqueia sync dos dados textuais.
- [ ] Migration de BD executa sem erros em instalação existente.
- [ ] Compressão de imagem (já implementada) permanece ativa antes do upload.

## Arquivos Relevantes
- `lib/core/services/foto_upload_service.dart` (criar)
- `lib/features/sync/data/datasources/sync_api_datasource.dart`
- `lib/features/sync/presentation/viewmodels/sync_notifier.dart`
- `lib/core/database/` (migration Drift)
- `lib/features/coleta/data/models/coleta_model.dart`

## Prioridade
**Alta** — fotos são evidência documental primária em arqueologia; sem sync, o registro é incompleto.
