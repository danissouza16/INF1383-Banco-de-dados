-- -----------------------------------------------------
-- Tabela Cliente
-- -----------------------------------------------------
CREATE TABLE Cliente (
    EmailCliente        VARCHAR(120) PRIMARY KEY,
    NomeCliente         VARCHAR(120) NOT NULL,
    contato_responsavel VARCHAR(120),
    Endereco            VARCHAR(255),
    TelefoneFax         VARCHAR(25)
);

-- -----------------------------------------------------
-- Tabela Funcionario
-- -----------------------------------------------------
CREATE TABLE Funcionario (
    IDFuncionario      VARCHAR(20) PRIMARY KEY,
    NomeFuncionario    VARCHAR(100) NOT NULL,
    HabilitacaoTecnica VARCHAR(80)
);

-- -----------------------------------------------------
-- Tabela Amostra
-- -----------------------------------------------------
CREATE TABLE Amostra (
    CodigoPUC           VARCHAR(20) NOT NULL,
    IDAmostra           VARCHAR(20) NOT NULL,
    AutorizouDescarte   BOOLEAN      NOT NULL,
    PontoColeta         VARCHAR(255),
    DataEnvioCliente    DATE         NOT NULL,
    DataColeta          DATE,
    NomeColetor         VARCHAR(100),
    TipoFrasco          VARCHAR(50),
    MatrizAmostra       VARCHAR(50),
    TipoAmostra         VARCHAR(50),
    FormaEntrega        VARCHAR(50),
    DataHoraRecebimento TIMESTAMP,
    ID_Funcionario      VARCHAR(20),
    EmailCliente        VARCHAR(120) NOT NULL,
    CONSTRAINT FK_Amostra_Funcionario
        FOREIGN KEY (ID_Funcionario)
        REFERENCES Funcionario (IDFuncionario),
    CONSTRAINT FK_Amostra_Cliente
        FOREIGN KEY (EmailCliente)
        REFERENCES Cliente (EmailCliente)
);

ALTER TABLE Amostra
    ADD CONSTRAINT PK_Amostra
        PRIMARY KEY (CodigoPUC);

-- -----------------------------------------------------
-- Tabela Requerimento_Analise
-- -----------------------------------------------------
CREATE TABLE Requerimento_Analise (
    IDRequerimento       VARCHAR(20) PRIMARY KEY,
    DataRequerimento     DATE        NOT NULL,
    Valor                NUMERIC(12,2),
    DataPagamento        DATE,
    NumeroNotaFiscal     VARCHAR(30),
    DataLimiteEnvioLaudo DATE,
    CodigoPUC            VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Requ_Amostra
        FOREIGN KEY (CodigoPUC)
        REFERENCES Amostra (CodigoPUC)
);

-- -----------------------------------------------------
-- Tabela Parametro
-- -----------------------------------------------------
CREATE TABLE Parametro (
    IDParametro           VARCHAR(20) PRIMARY KEY,
    NomeParametro         VARCHAR(60)  NOT NULL,
    DescricaoParametro    TEXT,
    UnidadeMedidaPadrao   VARCHAR(20),
    ValorMinimoReferencia NUMERIC(14,4),
    ValorMaximoReferencia NUMERIC(14,4)
);

-- -----------------------------------------------------
-- Tabela Ensaio (Entidade Associativa)
-- -----------------------------------------------------
CREATE TABLE Ensaio (
    NumeroRequerimento       VARCHAR(20) NOT NULL,
    IDParametro              VARCHAR(20) NOT NULL,
    ValorObtido              NUMERIC(14,4),
    UnidadeMedida            VARCHAR(20),
    MetodologiaUtilizada     VARCHAR(255),
    ValorMaximoPermitido_VMP NUMERIC(14,4),
    ValorMinimoPermitido_VMP NUMERIC(14,4),
    ResultadoDentroLimite    BOOLEAN,
    ObservacoesResultado     TEXT,
    CONSTRAINT PK_Ensaio PRIMARY KEY (NumeroRequerimento, IDParametro),
    CONSTRAINT FK_Ensaio_Requerimento
        FOREIGN KEY (NumeroRequerimento)
        REFERENCES Requerimento_Analise (IDRequerimento),
    CONSTRAINT FK_Ensaio_Parametro
        FOREIGN KEY (IDParametro)
        REFERENCES Parametro (IDParametro)
);

-- -----------------------------------------------------
-- Tabela Boletim
-- -----------------------------------------------------
CREATE TABLE Boletim (
    IDBoletim        VARCHAR(20) PRIMARY KEY,
    DataEnvioCliente DATE,
    StatusEnvio      VARCHAR(20),
    IDRequerimento   VARCHAR(20) NOT NULL,
    IDFuncionario    VARCHAR(20) NOT NULL,
    DataAprovacao    DATE,
    CONSTRAINT FK_Boletim_Requerimento
        FOREIGN KEY (IDRequerimento)
        REFERENCES Requerimento_Analise (IDRequerimento),
    CONSTRAINT FK_Boletim_Funcionario
        FOREIGN KEY (IDFuncionario)
        REFERENCES Funcionario (IDFuncionario)
);

-- -----------------------------------------------------
-- Tabela Descarte_Amostra
-- -----------------------------------------------------
CREATE TABLE Descarte_Amostra (
    CodigoAmostra         VARCHAR(20) PRIMARY KEY,
    DataPrevistaDescarte  DATE,
    DataEfetivaDescarte   DATE,
    ObservacoesDescarte   TEXT,
    IDFuncionarioDescarte VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Descarte_Amostra
        FOREIGN KEY (CodigoAmostra)
        REFERENCES Amostra (CodigoPUC)
);

ALTER TABLE Descarte_Amostra
    ADD CONSTRAINT FK_Descarte_Funcionario
        FOREIGN KEY (IDFuncionarioDescarte)
        REFERENCES Funcionario (IDFuncionario);