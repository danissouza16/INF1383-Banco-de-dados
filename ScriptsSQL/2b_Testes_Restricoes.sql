-- Testes de Violação de Restrição (Esperado dar ERRO)

-- Violação de PK (EmailCliente duplicado)
INSERT INTO Cliente (EmailCliente, NomeCliente) 
VALUES ('contato@aguasexemplo.com.br', 'Outro Cliente');

-- Violação de PK (IDFuncionario duplicado)
INSERT INTO Funcionario (IDFuncionario, NomeFuncionario) 
VALUES ('F001', 'Duplicado Silva');

-- Violação de FK (EmailCliente 'naoexiste@cliente.com' não existe na tabela Cliente)
INSERT INTO Amostra (CodigoPUC, IDAmostra, EmailCliente, AutorizouDescarte, DataEnvioCliente) 
VALUES ('LB-0002-23','A02','naoexiste@cliente.com', TRUE, '2025-01-01');

-- Violação de PK (CodigoPUC 'LB-0001-23' duplicado)
INSERT INTO Amostra (CodigoPUC, IDAmostra, EmailCliente, AutorizouDescarte, DataEnvioCliente)
VALUES ('LB-0001-23','A03','contato@aguasexemplo.com.br', TRUE, '2025-01-01');

-- Violação de FK (CodigoPUC 'LB-9999-23' não existe na tabela Amostra)
INSERT INTO Requerimento_Analise (IDRequerimento, DataRequerimento, CodigoPUC)
VALUES ('R1002','2025-05-22','LB-9999-23');

-- Violação de PK (IDRequerimento 'R1005' duplicado)
INSERT INTO Requerimento_Analise (IDRequerimento, DataRequerimento, CodigoPUC)
VALUES ('R1005','2025-05-22','LB-0001-23');

-- Violação de PK (IDParametro 'P_H' duplicado)
INSERT INTO Parametro (IDParametro, NomeParametro)
VALUES ('P_H','Duplicado pH');

-- Violação de FK (NumeroRequerimento 'R9999' não existe na tabela Requerimento_Analise)
INSERT INTO Ensaio (NumeroRequerimento, IDParametro)
VALUES ('R9999','P_H');

-- Violação de PK (Dupla 'R1005', 'P_H' duplicada)
INSERT INTO Ensaio (NumeroRequerimento, IDParametro)
VALUES ('R1005','P_H');

-- Violação de FK (IDFuncionario 'F999' não existe na tabela Funcionario)
INSERT INTO Boletim (IDBoletim, IDRequerimento, IDFuncionario)
VALUES ('B2025002','R1005','F999');

-- Violação de PK (IDBoletim 'B2025001' duplicado)
INSERT INTO Boletim (IDBoletim, IDRequerimento, IDFuncionario)
VALUES ('B2025001','R1005','F001');

-- Violação de FK (CodigoAmostra 'LB-9999-23' não existe na tabela Amostra)
INSERT INTO Descarte_Amostra (CodigoAmostra, IDFuncionarioDescarte) 
VALUES ('LB-9999-23', 'F001');

-- Violação de FK (IDFuncionarioDescarte 'F999' não existe na tabela Funcionario)
INSERT INTO Descarte_Amostra (CodigoAmostra, IDFuncionarioDescarte) 
VALUES ('LB-0001-23', 'F999');