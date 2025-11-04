-- VIEW 1: Saldo pendente por cliente
CREATE OR REPLACE VIEW vw_cliente_saldo AS
SELECT
  c.emailcliente,
  c.nomecliente,
  SUM(r.valor) AS saldo_pendente
FROM   cliente c
JOIN   amostra a ON a.emailcliente = c.emailcliente
JOIN   requerimento_analise r ON   r.codigopuc = a.codigopuc
WHERE  r.datapagamento IS NULL
GROUP  BY c.emailcliente, c.nomecliente;

-- Exemplo de uso da VIEW 1:
-- SELECT * FROM vw_cliente_saldo WHERE emailcliente = 'aquaprime@cliente.com';


-- VIEW 2: Requerimentos atrasados
CREATE OR REPLACE VIEW vw_reqs_atrasados AS
SELECT
  r.idrequerimento,
  a.codigopuc,
  c.nomecliente,
  r.datalimiteenviolaudo,
  (CURRENT_DATE - r.datalimiteenviolaudo) AS dias_atraso
FROM   requerimento_analise r
JOIN   amostra a ON a.codigopuc = r.codigopuc
JOIN   cliente c ON c.emailcliente = a.emailcliente
WHERE  r.datalimiteenviolaudo < CURRENT_DATE;

-- Exemplo de uso da VIEW 2:
-- SELECT idrequerimento, nomecliente, dias_atraso
-- FROM   vw_reqs_atrasados
-- ORDER  BY dias_atraso DESC
-- LIMIT  3;


-- VIEW 3: View com Check Option
CREATE VIEW v_boletins_para_emissao AS 
SELECT IDBoletim, IDRequerimento, IDFuncionario, DataAprovacao, StatusEnvio 
FROM Boletim 
WHERE StatusEnvio = 'Pendente' 
WITH CHECK OPTION;

-- Teste de sucesso (Permitido):
-- INSERT INTO V_Boletins_Para_Emissao (IDBoletim, IDRequerimento, IDFuncionario, StatusEnvio) 
-- VALUES ('B2025002', 'R1005', 'F001', 'Pendente'); 

-- Teste de falha (Erro - Violação do CHECK OPTION):
-- INSERT INTO V_Boletins_Para_Emissao (IDBoletim, IDRequerimento, IDFuncionario, StatusEnvio) 
-- VALUES ('B2025003', 'R1005', 'F001', 'Enviado');