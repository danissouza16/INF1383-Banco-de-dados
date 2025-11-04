-- -----------------------------------------------------
-- ÍNDICE 1: Índice secundário em NomeCliente
-- -----------------------------------------------------
-- Útil para buscas por nome, que são comuns.
CREATE INDEX idx_cliente_nomecliente ON Cliente (NomeCliente);


-- -----------------------------------------------------
-- ÍNDICE 2: Índice secundário em DataColeta
-- -----------------------------------------------------
-- Útil para consultas que filtram por range de datas.
CREATE INDEX idx_amostra_datacoleta ON Amostra (DataColeta);


-- -----------------------------------------------------
-- Teste de Otimizador (PostgreSQL)
-- -----------------------------------------------------
/*
-- Para forçar o otimizador a USAR o índice (apenas para diagnóstico):
SET enable_seqscan TO OFF;

-- Execute sua consulta de teste:
SELECT
    a.CodigoPUC,
    a.PontoColeta,
    a.DataColeta
FROM
    Amostra a
WHERE
    a.DataColeta = '2025-05-20';

-- Lembre-se de reabilitar a varredura sequencial depois:
SET enable_seqscan TO ON;
*/