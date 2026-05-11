# Task 016 — Gestão Completa de Bens Materiais

## Objetivo
Completar a feature `bem_material` implementando a interface de usuário para listagem, detalhes e associação de bens materiais a coletas, além do datasource remoto para fetch via API.

## Contexto
A feature tem entity, model, datasource local e repository implementados (50% completo), mas não existe nenhuma página de UI para o usuário interagir com bens materiais. A abstração de repositório também está incompleta (sem interface). A tabela `BensMateriais` no banco local tem índices bem definidos, sugerindo que o uso intensivo desta entidade foi planejado.

## Escopo

### Domínio
- Criar `BemMaterialRepository` (interface abstrata) em `lib/features/bem_material/domain/repositories/`.
- Métodos: `buscarPorColeta(String coletaId)`, `salvar(BemMaterialEntity)`, `listarTodos()`.

### Dados
- Criar `BemMaterialApiDatasource` para fetch remoto: `GET /v1/mobile/bens-materiais`.
- Implementar `BemMaterialRepositoryImpl` com decisão local vs. remoto.

### Apresentação
- `BensMateriaisPage`: lista de bens associados a uma coleta com `ListView.builder`.
- `DetalhesItemPage`: detalhes de um bem com campos: código IPHAN, coordenadas, endereço, fotos.
- `NovoBemMaterialPage`: formulário para criar bem material associado a uma coleta existente.
- Adicionar acesso pela `DetalhesColetaPage` com botão "Bens Materiais".

### Navegação
- Adicionar rota `/bens-materiais/:coletaId` no GoRouter.
- Adicionar rota `/novo-bem-material/:coletaId`.

## Critérios de Aceite
- [ ] `DetalhesColetaPage` exibe botão "Bens Materiais" com contagem.
- [ ] `BensMateriaisPage` lista todos os bens da coleta do banco local.
- [ ] `NovoBemMaterialPage` salva localmente com status `pendente`.
- [ ] Bens materiais são incluídos no payload de sync.
- [ ] `flutter analyze` sem erros.

## Arquivos Relevantes
- `lib/features/bem_material/` (toda a feature)
- `lib/features/coleta/presentation/pages/detalhes_coleta_page.dart`
- `lib/core/router/app_router.dart`

## Prioridade
**Média** — complementa o fluxo de coleta, mas o core funciona sem esta feature.
