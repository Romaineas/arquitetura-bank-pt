🏦 Base de Dados Bancária — Análise de Crédito e Incumprimento

> **Plataforma:** Microsoft SQL Server (MSSQL) · **Setor:** Banca — Portugal  
> **Conformidade:** DL 227/2012 · PARI · PERSI · CRC · Aviso BdP 4/2017 · Aviso BdP 7/2021 · RGPD

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Roadmap do Projeto](#roadmap-do-projeto)
- [Arquitetura da Base de Dados](#arquitetura-da-base-de-dados)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Configuração](#instalação-e-configuração)
- [Execução dos Scripts SQL](#execução-dos-scripts-sql)
- [Funcionalidades](#funcionalidades)
- [Conformidade Regulatória](#conformidade-regulatória)
- [Tecnologias](#tecnologias)
- [Contribuição](#contribuição)
- [Licença](#licença)

---

## 📌 Sobre o Projeto

Este repositório contém o **modelo completo de base de dados relacional** para o setor bancário português, com foco em **análise de crédito**, **gestão de incumprimento** e **conformidade regulatória** perante o **Banco de Portugal**.

O projeto foi desenvolvido para **Microsoft SQL Server (MSSQL)** e cobre todo o ciclo de vida do crédito: desde a avaliação de solvabilidade até ao reporte mensal à **Central de Responsabilidades de Crédito (CRC)**.

### ✨ Destaques

- 📂 **12 tabelas** estruturadas com relacionamentos normalizados (3FN)
- ⚖️ **PARI e PERSI** implementados como entidades nativas, com procedures automáticas
- 📡 **Reporte CRC** gerado automaticamente via SQL Server Agent Job
- 🔒 **RGPD** — campos sensíveis com encriptação via `ENCRYPTBYKEY` / Always Encrypted
- 📊 **Views analíticas** e KPIs de incumprimento prontos a usar
- 🧪 **Dataset de teste** com dados ficcionais portugueses

---

## 🗺️ Roadmap do Projeto

### Fase 1 — Fundação da Base de Dados
> **Objetivo:** criar a estrutura nuclear do modelo relacional

- [x] Definição do modelo entidade-relacionamento (MER)
- [x] Criação do schema `banco_credito` no SQL Server
- [x] DDL — Tabela `clientes` (NIF, NIPC, DSTI, RGPD)
- [x] DDL — Tabela `contas_bancarias` (IBAN, BIC/SWIFT)
- [x] DDL — Tabela `produtos_credito` (LTV máx., DSTI máx., Euribor, TAEG)
- [x] DDL — Tabela `contratos_credito` (DSTI e LTV contratual, tipo_negociacao)
- [x] DDL — Tabela `prestacoes` (capital, juros, situacao, dias_atraso)
- [x] DDL — Tabela `pagamentos` (Multibanco, MBWay, débito direto)
- [x] Criação de todas as chaves primárias, estrangeiras e constraints
- [x] Índices de performance nas colunas críticas

---

### Fase 2 — Gestão de Incumprimento
> **Objetivo:** implementar o ciclo legal de incumprimento (DL 227/2012)

- [x] DDL — Tabela `incumprimento` (capital vencido, juros vencidos, fase_cobranca)
- [x] DDL — Tabela `pari` (Plano de Ação para o Risco de Incumprimento)
- [x] DDL — Tabela `persi` (Procedimento Extrajudicial de Regularização)
- [x] Procedure `sp_registar_incumprimento` — atualização diária via SQL Agent
- [x] Procedure `sp_activar_persi` — ativação automática ao 60.º dia
- [x] Procedure `sp_monitorizar_pari` — deteção proativa de sinais de risco
- [x] View `vw_alertas_legais` — contratos em risco de incumprimento legal
- [x] View `vw_cumprimento_regulatorio` — dashboard PARI/PERSI por contrato
- [ ] Integração com sistema de notificações (email/SMS ao cliente)
- [ ] Módulo de propostas automáticas PERSI (carência, alargamento de prazo)

---

### Fase 3 — Reporte à CRC (Banco de Portugal)
> **Objetivo:** automatizar o reporte mensal obrigatório à Central de Responsabilidades de Crédito

- [x] DDL — Tabela `crc_comunicacoes` (período, situação, tipo_negociacao)
- [x] Procedure `sp_gerar_reporte_crc` — gera registos do mês de referência
- [x] View `vw_crc_mensal` — pré-visualização do ficheiro a enviar
- [ ] Exportação para formato XML (Instrução BdP 17/2018)
- [ ] Integração com SFTP do Banco de Portugal
- [ ] Validação automática de NIF/NIPC antes do envio
- [ ] Painel de controlo de envios (confirmados / com erro / pendentes)

---

### Fase 4 — Análise de Crédito e Scoring
> **Objetivo:** avaliação de solvabilidade e modelo interno de risco (IFRS 9)

- [x] DDL — Tabela `score_credito` (DSTI, LTV, PD, classe_risco IFRS 9)
- [x] DDL — Tabela `historico_credito` (eventos, impacto_risco)
- [x] Consulta de elegibilidade por produto (DSTI + LTV + rendimento mínimo)
- [x] Consulta de carteira vencida por faixa de dias (Aging)
- [x] Consulta de taxa de incumprimento por produto
- [ ] Stored Procedure de cálculo de DSTI com cenários Euribor (+2%, +3%)
- [ ] Modelo de Probabilidade de Default (PD) — regressão logística em Python/R com scoring gravado em SQL
- [ ] Cálculo de LGD (Loss Given Default) e EAD (Exposure at Default)
- [ ] View de provisões IFRS 9 (Stage 1 / Stage 2 / Stage 3)

---

### Fase 5 — Segurança, RGPD e Auditoria
> **Objetivo:** proteger dados pessoais e garantir rastreabilidade

- [x] Campos NIF e IBAN com suporte a `ENCRYPTBYKEY` (MSSQL)
- [x] Campo `consentimento_rgpd` e `data_consentimento` em `clientes`
- [ ] Implementação de **Always Encrypted** para NIF, IBAN e rendimento
- [ ] **Row-Level Security (RLS)** — acesso por departamento (crédito, cobrança, compliance)
- [ ] Tabela de auditoria `audit_log` com triggers em INSERT/UPDATE/DELETE
- [ ] Política de retenção de dados CRC (purga automática após 5 anos)
- [ ] Procedure de anonimização para ambientes de desenvolvimento/teste
- [ ] Relatório de conformidade RGPD (dados tratados, base legal, prazo retenção)

---

### Fase 6 — Dashboards e Reporting
> **Objetivo:** relatórios operacionais e de gestão

- [ ] View `vw_kpis_incumprimento` — NPL ratio, cobertura, aging total
- [ ] View `vw_carteira_por_segmento` — crédito habitação vs. consumo vs. auto
- [ ] View `vw_evolucao_mensal` — série temporal de incumprimento
- [ ] Integração com **Power BI** via DirectQuery ao SQL Server
- [ ] Relatório de provisões para a Comissão Executiva (formato PDF via SSRS)
- [ ] Dashboard de alertas PARI/PERSI em tempo real

---

## 🗄️ Arquitetura da Base de Dados

```
┌─────────────────────────────────────────────────────────────────┐
│                        banco_credito (schema)                   │
│                                                                 │
│   clientes ──────────── contas_bancarias                        │
│       │                                                         │
│       ├──── contratos_credito ◄──── produtos_credito            │
│       │           │                                             │
│       │           ├──── prestacoes ──── pagamentos              │
│       │           │          │                                  │
│       │           │          └──── incumprimento                │
│       │           │                                             │
│       │           ├──── pari   (DL 227/2012)                    │
│       │           └──── persi  (DL 227/2012)                    │
│       │                                                         │
│       ├──── crc_comunicacoes  (Instrução BdP 17/2018)           │
│       ├──── score_credito     (IFRS 9 / Aviso BdP 4/2017)       │
│       └──── historico_credito                                   │
└─────────────────────────────────────────────────────────────────┘
```
