# Sistema para Coleta de Dados Arqueológicos 🏺

Este projeto consiste no desenvolvimento de uma ferramenta computacional móvel, de uso gratuito, projetada para otimizar a coleta de dados em campo por arqueólogos. O sistema foca no registro minucioso de bens provenientes de prospecção e/ou escavação, garantindo a integridade da informação em cenários de baixa conectividade.

## 🎓 Contexto Acadêmico
Este software é o resultado técnico de dois marcos acadêmicos:
- **Trabalho de Conclusão de Curso (TCC)** em Análise e Desenvolvimento de Sistemas.
- **Iniciação Científica (PIBIC/CNPq)**, com vigência de outubro de 2025 a setembro de 2026.

**Instituição:** Instituto Federal do Piauí (IFPI) - Campus Parnaíba  
**Autora:** Maria Fernanda Rodrigues Costa  
**Orientador:** Prof. Dr. Francisco Gerson Amorim de Meneses.  
**Coorientador:** Prof. Dr. Angelo Alves Corrêa.

## 🚀 Problema e Justificativa
Sistemas atuais como o CNSA e o SICG apresentam limitações de usabilidade e exigem conexão constante com a internet. O preenchimento manual aumenta o risco de perda do contexto histórico, que é irrecuperável após a escavação 93. Este aplicativo resolve esses gargalos através de:
- **Interface Especializada:** Formulários adaptados ao fluxo de trabalho arqueológico.
- **Arquitetura Offline-First:** Funcionamento pleno em áreas remotas.
- **Sincronização Automatizada:** Envio de dados em background assim que houver conectividade.

## 🛠️ Tecnologias e Arquitetura
O sistema utiliza uma arquitetura de integração bidirecional entre banco local e remoto.

### Mobile (Este repositório)
- **Framework:** Flutter (Linguagem Dart).
- **Banco de Dados Local:** SQLite (via `sqflite`) para persistência offline.
- **Geoprocessamento:** Suporte a coordenadas GPS e dados geoespaciais.

### Backend & Persistência
- **API:** RESTful desenvolvida em Laravel.
- **Banco de Dados Remoto:** PostgreSQL com extensão PostGIS para georreferenciamento.
- **Segurança:** Autenticação via JWT/OAuth 2.0 e criptografia AES-256 para dados em repouso.

## 📊 Modelagem do Sistema
O projeto foi estruturado utilizando a Linguagem de Modelagem Unificada (UML):
- **Entidades Principais:** Usuário, Coleta (Staging), Sítio, Localização, MidiaLink, Curadoria e Auditoria.
- **Fluxo de Curadoria:** Os dados coletados passam por uma "Lista Suja" para validação por um curador antes de se tornarem públicos, evitando duplicidades.

## ⚖️ Aspectos Éticos
A pesquisa é de natureza tecnológica e bibliográfica, não envolvendo a participação direta de seres humanos, estando em conformidade com a Resolução $n^{\circ}$ 466/2012 do CNS, 232. Todo o código-fonte será disponibilizado em repositório público para contribuir com a comunidade científica.

## 📬 Contato
Maria Fernanda Rodrigues Costa - [LinkedIn](https://www.linkedin.com/in/mfernandacs/) | [Lattes](https://lattes.cnpq.br/0438264747363074)