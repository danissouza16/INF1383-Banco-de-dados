-- Inserções válidas para a tabela Cliente
INSERT INTO Cliente (EmailCliente, NomeCliente, ContatoResponsavel, Endereco, TelefoneFax) 
VALUES ('contato@aguasexemplo.com.br', 'Águas Exemplo Ltda.', 'Maria souza', 'Rua das Flores, 123 – Rio de Janeiro/RJ', '(21) 3527-1814');

INSERT INTO Cliente (EmailCliente, NomeCliente, contato_responsavel, Endereco, TelefoneFax) 
VALUES ('novaempresa@cliente.com', 'Nova Empresa S/A', 'REBECCA ROCHA', 'Rua Z, 101, Petrópolis, RJ', '(24) 1357-2468');

-- Inserções válidas para a tabela Funcionario
INSERT INTO Funcionario (IDFuncionario, NomeFuncionario, HabilitacaoTecnica) 
VALUES ('F001', 'José Godoy', 'Química Analítica');

INSERT INTO Funcionario (IDFuncionario, NomeFuncionario, HabilitacaoTecnica) 
VALUES ('F018', 'Ricardo Nunes', 'Técnico de Campo');

-- Inserção válida para a tabela Amostra
-- Nota: Havia um erro de sintaxe no seu PDF (faltava uma vírgula antes de DataHoraRecebimento). Eu corrigi.
INSERT INTO Amostra (
  CodigoPUC,
  IDAmostra,
  PontoColeta,
  DataColeta,
  NomeColetor,
  TipoFrasco,
  MatrizAmostra,
  TipoAmostra,
  FormaEntrega,
  EmailCliente,
  AutorizouDescarte,
  DataEnvioCliente,
  DataHoraRecebimento
) VALUES (
  'LB-0001-23',
  'A01',
  'Capacete I – Rio Branco',
  '2025-05-20',
  'Antônio Silva',
  'Vidro 500 mL',
  'Água de Consumo',
  'Fonte',
  'Coleta Própria',
  'contato@aguasexemplo.com.br',
  TRUE,
  '2025-05-26',
  '2025-06-24 15:45:00'
);

-- Inserção válida para a tabela Requerimento_Analise
INSERT INTO Requerimento_Analise (
  IDRequerimento,
  DataRequerimento,
  Valor,
  DataPagamento,
  NumeroNotaFiscal,
  DataLimiteEnvioLaudo,
  CodigoPUC
) VALUES (
  'R1005',
  '2025-05-21',
  450.00,
  NULL,
  NULL,
  '2025-05-28',
  'LB-0001-23'
);

-- Inserção válida para a tabela Parametro
INSERT INTO Parametro (
  IDParametro,
  NomeParametro,
  DescricaoParametro,
  UnidadeMedidaPadrao,
  ValorMinimoReferencia,
  ValorMaximoReferencia
) VALUES (
  'P_H',
  'pH',
  'Potencial hidrogeniônico',
  'adimensional',
  6.0,
  9.0
);

-- Inserção válida para a tabela Ensaio
-- Nota: Assumindo que o requerimento 'R1001' exista (seu exemplo usava R1001, mas o insert válido era R1005. Ajuste se necessário).
INSERT INTO Ensaio (
  NumeroRequerimento,
  IDParametro,
  ValorObtido,
  UnidadeMedida,
  MetodologiaUtilizada,
  ValorMaximoPermitido_VMP,
  ValorMinimoPermitido_VMP,
  ResultadoDentroLimite,
  ObservacoesResultado
) VALUES (
  'R1005', -- Trocado de 'R1001' para 'R1005' para ser consistente com o insert anterior
  'P_H',
  7.4,
  'adimensional',
  'Potenciometria',
  9.0,
  6.0,
  TRUE,
  NULL
);

-- Inserção válida para a tabela Boletim
INSERT INTO Boletim (
  IDBoletim,
  DataEnvioCliente,
  StatusEnvio,
  IDRequerimento,
  IDFuncionario,
  DataAprovacao
) VALUES (
  'B2025001',
  NULL,
  'Pendente',
  'R1005', -- Trocado de 'R1001' para 'R1005'
  'F001',
  '2025-05-22'
);

-- Inserção válida para a tabela Descarte_Amostra
INSERT INTO Descarte_Amostra (
  CodigoAmostra,
  DataPrevistaDescarte,
  DataEfetivaDescarte,
  ObservacoesDescarte,
  IDFuncionarioDescarte
) VALUES (
  'LB-0001-23',
  '2025-06-05',
  NULL,
  NULL,
  'F001'
);