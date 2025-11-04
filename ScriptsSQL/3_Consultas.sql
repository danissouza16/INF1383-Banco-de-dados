-- Consulta 1 (Seção 8)
-- Listar amostras de 'Água Bruta' do 1º semestre de 2025, entregues presencialmente.
SELECT
    a.CodigoPUC,
    a.PontoColeta,
    a.DataColeta,
    c.NomeCliente,
    c.contato_responsavel
FROM
    Amostra a
INNER JOIN
    Cliente c ON a.EmailCliente = c.EmailCliente
WHERE
    a.MatrizAmostra = 'Água Bruta'
    AND a.DataColeta >= '2025-01-01' AND a.DataColeta <= '2025-06-30'
    AND a.FormaEntrega = 'Coleta Presencial' -- Assumindo 'Coleta Presencial' como no texto
ORDER BY
    a.DataColeta ASC;

-- Consulta 2 (Seção 8)
-- Contar parâmetros não conformes (ResultadoDentroLimite = FALSE) por nome do parâmetro, em 2025.
SELECT
    p.NomeParametro,
    COUNT(*) AS TotalNaoConforme
FROM
    Ensaio e
INNER JOIN
    Requerimento_Analise ra ON e.NumeroRequerimento = ra.IDRequerimento
INNER JOIN
    Parametro p ON e.IDParametro = p.IDParametro
WHERE
    e.ResultadoDentroLimite = FALSE
    AND EXTRACT(YEAR FROM ra.DataRequerimento) = 2025
GROUP BY
    p.NomeParametro
ORDER BY
    TotalNaoConforme DESC;

-- Consulta 3 (Seção 8)
-- Listar funcionários de 'Química Analítica' responsáveis por descarte não autorizado.
SELECT 
  f.IDFuncionario, 
  f.NomeFuncionario, 
  da.CodigoAmostra
FROM 
  Funcionario AS f
  JOIN Descarte_Amostra AS da
    ON f.IDFuncionario = da.IDFuncionarioDescarte
  JOIN Amostra AS a
    ON a.CodigoPUC = da.CodigoAmostra
WHERE 
  f.HabilitacaoTecnica = 'Química Analítica'
  AND a.AutorizouDescarte = FALSE; -- Corrigido de 'autorizadescarte' para 'AutorizouDescarte'


-- Consulta 4 (Seção 10)
-- Listar clientes e total de ensaios fora do limite (com pelo menos 1).
SELECT c.nomecliente,
       COUNT(*) AS ensaios_fora_limite
FROM   cliente        c
JOIN   amostra        a ON a.emailcliente   = c.emailcliente
JOIN   requerimento_analise r ON r.codigopuc = a.codigopuc
JOIN   ensaio         e ON e.numerorequerimento = r.idrequerimento
WHERE  e.resultadodentrolimite = FALSE
GROUP  BY c.nomecliente
ORDER  BY ensaios_fora_limite DESC;

-- Consulta 5 (Seção 10)
-- Listar funcionários que nunca aprovaram um boletim.
SELECT f.idfuncionario,
       f.nomefuncionario
FROM   funcionario f
WHERE  NOT EXISTS (
           SELECT 1
           FROM   boletim b
           WHERE  b.idfuncionario = f.idfuncionario
             AND  b.dataaprovacao IS NOT NULL
       );

-- Consulta 6 (Seção 10)
-- Calcular o faturamento mensal (requerimentos com pagamento registrado).
SELECT EXTRACT(YEAR  FROM datapagamento) AS ano,
       EXTRACT(MONTH FROM datapagamento) AS mes,
       SUM(valor)                      AS valor_total
FROM   requerimento_analise
WHERE  datapagamento IS NOT NULL
GROUP  BY ano, mes
ORDER  BY ano, mes;

-- Consulta 7 (Seção 10)
-- Listar clientes com mais de 1 amostra enviada.
SELECT c.nomecliente,
       COUNT(*) AS total_amostras
FROM   cliente c
JOIN   amostra a ON a.emailcliente = c.emailcliente
GROUP  BY c.nomecliente
HAVING COUNT(*) > 1
ORDER  BY total_amostras DESC;

-- Consulta 8 (Seção 10)
-- Identificar requerimentos atrasados (prazo passou e boletim não enviado).
WITH boletins_enviados AS (
    SELECT idrequerimento
    FROM   boletim
    WHERE  statusenvio = 'Enviado'
)
SELECT r.idrequerimento,
       r.datalimiteenviolaudo,
       c.nomecliente
FROM   requerimento_analise r
JOIN   amostra  a ON a.codigopuc    = r.codigopuc
JOIN   cliente  c ON c.emailcliente = a.emailcliente
WHERE  r.datalimiteenviolaudo < CURRENT_DATE
  AND  r.idrequerimento NOT IN (SELECT idrequerimento FROM boletins_enviados);

-- Consulta 9 (Seção 10)
-- Calcular estatísticas (Média, Min, Max) de pH por ponto de coleta.
-- Nota: Assumindo que IDParametro 'P_H' (do seu insert) seja o correto, não 'P001'.
SELECT a.pontocoleta,
       ROUND(AVG(e.valorobtido), 2) AS media_ph, -- Removida a conversão desnecessária '::NUMERIC'
       MIN(e.valorobtido)             AS min_ph,
       MAX(e.valorobtido)             AS max_ph
FROM   amostra            a
JOIN   requerimento_analise r ON r.codigopuc          = a.codigopuc
JOIN   ensaio               e ON e.numerorequerimento = r.idrequerimento
WHERE  e.idparametro = 'P_H' -- Usando 'P_H' do seu script de inserção
GROUP  BY a.pontocoleta
ORDER  BY media_ph DESC;