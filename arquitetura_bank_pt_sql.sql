
-- PROJETO DE BASE DE DADOS RELACIONAL
--Setor Bancário Português


CREATE DATABASE banco_credito_pt;
GO

USE banco_credito_pt;
GO


CREATE TABLE clientes (
	id_cliente INT IDEnTITY(1,1) PRIMARY KEY,
	nif VARCHAR(9) UNIQUE,
	nipc VARCHAR(9) UNIQUE,

	tipo_pessoa  CHAR(2) NOT NULL DEFAULT 'PF',

	nome VARCHAR(150) NOT NULL,
	email VARCHAR(120),
	telefone VARCHAR(20),

	data_nascimento DATE,

	rendimento_mensal DECIMAL(15,2) NOT NULL DEFAULT 0,
	taxa_esforco_atual DECIMAL(5,2) NOT NULL DEFAULT 0,

	situacao_profissional VARCHAR(30),
	estado_civil VARCHAR(20),

	codigo_postal VARCHAR(8),
	localidade VARCHAR(80),
	Distrito VARCHAR(40),
	pais CHAR(2) NOT NULL DEFAULT 'PT',

	data_cadastro DATETIME2 NOT NULL DEFAULT GETDATE(),

	consentimento_rgpd BIT NOT NULL DEFAULT 0,
	data_consentimento DATETIME2,

	ativo BIT NOT NULL DEFAULT 1,

	CONSTRAINT chk_tipo_pessoa CHECK (tipo_pessoa IN ('PF', 'PJ')),
	CONSTRAINT chk_nif_nipc CHECK (nif IS NOT NULL OR nipc IS NOT NULL),
);


-- =========================
-- 3. TABELA CONTAS BANCÁRIAS
-- =========================


CREATE TABLE contas_bancarias (
	id_conta INT IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,

	iban VARCHAR(25) NOT NULL UNIQUE,
	bic_swift VARCHAR(11),

	tipo_conta VARCHAR(25) NOT NULL,

	saldo DECIMAL(15,2) NOT NULL DEFAULT 0,
	limite_descoberto DECIMAL(15,2) NOT NULL DEFAULT 0,
	taxa_descoberto_tan DECIMAL(6,4),

	data_abertura DATE NOT NULL DEFAULT GETDATE(),
	data_encerramento_tan DATE,

	estatuto VARCHAR(15) NOT NULL DEFAULT 'ATIVA',

	CONSTRAINT fk_conta_cliente
		FOREIGN KEY (id_cliente)
		REFERENCES clientes(id_cliente),

	CONSTRAINT chk_tipo_conta CHECK
		(tipo_conta IN ('ORDEM', 'POUPANCA', 'ORDENADO', 'DEPOSITO_PRAZO', 'INVESTIMENTO'))
);


-- =========================
-- 4. TABELA PRODUTOS_CREDITO
-- =========================

CREATE TABLE produtos_credito (
	id_produto INT IDENTITY(1,1) PRIMARY KEY,
	nome_produto VARCHAR(100) NOT NULL,
	tipo_credito VARCHAR(50) NOT NULL,
	taxa_juro_anual DECIMAL(6,3) NOT NULL,
	prazo_max_meses INT NOT NULL,
	ativo BIT NOT NULL DEFAULT 1

);

GO



-- =========================
-- 5. TABELA CONTRATOS_CREDITO
-- =========================

CREATE TABLE contratos_credito (
	id_contrato INT IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	id_produto INT NOT NULL,
	id_conta INT NOT NULL,

	montante_aprovado DECIMAL(15,2) NOT NULL,
	taxa_juro DECIMAL(6,3) NOT NULL,
	prazo_meses INT NOT NULL,

	data_inicio DATE NOT NULL,
	data_fim DATE,
	estatuto VARCHAR(20) NOT NULL DEFAULT 'ATIVO',

	CONSTRAINT fk_contrato_produto
		FOREIGN KEY (id_produto) REFERENCES produtos_credito(id_produto),

	CONSTRAINT fk_contrato_conta
		FOREIGN KEY (id_conta) REFERENCES contas_bancarias(Id_conta)

);


SELECT * FROM [dbo].[produtos_credito]


-- =========================
-- 6. TABELA PRESTACOES
-- =========================

CREATE TABLE prestacoes (
	id_prestacao INT IDENTITY(1,1) PRIMARY KEY,
	id_contrato INT NOT NULL,
	numero_prestacao INT NOT NULL,
	valor_prestacao DECIMAL(15,2) NOT NULL,
	data_vencimento DATE NOT NULL,
	data_pagamento DATE,

	estatuto VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',

	CONSTRAINT fk_prestacao_contrato
		FOREIGN KEY (id_contrato) REFERENCES contratos_credito(ID_contrato)


);
GO

-- =========================
-- 7. TABELA TRANSACOES
-- =========================

CREATE TABLE transacoes (
    id_transacao INT IDENTITY(1,1) PRIMARY KEY,
    id_conta INT NOT NULL,

    tipo_transacao VARCHAR(20) NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    descricao VARCHAR(200),

    data_transacao DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT fk_transacao_conta
        FOREIGN KEY (id_conta) REFERENCES contas_bancarias(id_conta)
);
GO


-- =========================
-- 8. TABELA PARI (Prevenção de Risco de Incumprimento)
-- =========================

CREATE TABLE pari (
	id_pari INT IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	id_contrato INT NOT NULL,

	data_alerta DATE NOT NULL DEFAULT GETDATE(),
	motivo_alerta VARCHAR(200),
	estatuto VARCHAR(20) NOT NULL DEFAULT 'EM_ANALISE',

	CONSTRAINT fk_pari_cliente
		FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente),

	CONSTRAINT fl_pari_contrato
		FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),

);
GO


-- =========================
-- 9. TABELA PERSI (Gestão de Incumprimento)
-- =========================

CREATE TABLE PERSI(
	id_persi INT IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	id_contrato INT NOT NULL,

	data_inicio DATE NOT NULL DEFAULT GETDATE(),
	fase VARCHAR(30),
	estatuto VARCHAR(20) NOT NULL DEFAULT 'ATIVO',

	CONSTRAINT fk_persi_cliente
		FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),

	CONSTRAINT fk_persi_contrato
	FOREIGN KEY (id_contrato) REFERENCES contratos_credito(id_contrato)



);
GO


-- =========================
-- 10. TABELA CRC (Central de Responsabilidades de Crédito)
-- =========================

CREATE TABLE crc_registros (
	id_crc iNT IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	total_credito DECIMAL(15,2) NOT NULL,
	total_em_divida DECIMAL(15,2) NOT NULL,
	classificacao_risco VARCHAR(20),
	data_reporte DATE NOT NULL DEFAULT GETDATE(),

	CONSTRAINT fk_crc_cliente
		FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)

);
GO


-- =========================
-- 11. TABELA AUDITORIA (Compliance Bancário)
-- =========================

CREATE TABLE auditoria_logs(
	id_log INT IDENTITY(1,1) PRIMARY KEY,
	tabela_afetada VARCHAR(100),
	operacao VARCHAR(20),
	utilizador VARCHAR(100),
	data_evento DATETIME2 NOT NULL DEFAULT GETDATE(),
	detalhes VARCHAR(max)

);
GO

-- =========================
-- 12. INSERTS DE TESTE (OBRIGATÓRIO PARA NÃO DAR ERRO DE FK)
-- =========================

INSERT INTO clientes (nif, nome, email, rendimento_mensal, consentimento_rgpd)
VALUES ('123456789', 'Maria Cardoso', 'mariac@email.pt', 2500, 1);
GO

INSERT INTO contas_bancarias (id_cliente, iban, tipo_conta, saldo)
VALUES (1, 'PT50000201231234567890154', 'ORDEM', 5000);
GO

INSERT INTO produtos_credito (nome_produto, tipo_credito, taxa_juro_anual, prazo_max_meses)
VALUES ('Crédito Habitação', 'HABITACAO', 3.25, 360);
GO

