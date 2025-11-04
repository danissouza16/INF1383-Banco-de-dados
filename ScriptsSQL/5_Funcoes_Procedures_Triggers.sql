-- -----------------------------------------------------
-- FUNÇÃO 1: Quantidade de parâmetros fora do limite
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION qtd_parametros_fora_limite(cod_puc varchar)
RETURNS integer AS $$
DECLARE
    qtd integer := 0;
BEGIN
    SELECT COUNT(*) INTO qtd
    FROM ENSAIO e
    JOIN REQUERIMENTO_ANALISE r ON e.NumeroRequerimento = r.IDRequerimento
    WHERE r.CodigoPuc = cod_puc
      AND (e.ResultadoDentroLimite = false OR e.ResultadoDentroLimite IS NULL);
    RETURN qtd;
END;
$$ LANGUAGE plpgsql;

-- Exemplo de teste da Função 1:
-- SELECT 'LB-0001-23' AS amostra, qtd_parametros_fora_limite('LB-0001-23') AS qtd_fora;


-- -----------------------------------------------------
-- FUNÇÃO 2: Soma de valores de requerimentos em dívida
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION valor_pendente_cliente(
            p_email VARCHAR)
RETURNS NUMERIC(12,2) AS $$
DECLARE
    total_pendente NUMERIC(12,2);
BEGIN
    SELECT SUM(r.valor)
      INTO total_pendente
    FROM   cliente            c
    JOIN   amostra            a ON a.emailcliente = c.emailcliente
    JOIN   requerimento_analise r ON r.codigopuc    = a.codigopuc
    WHERE  c.emailcliente = p_email
      AND  r.datapagamento IS NULL;

    IF total_pendente IS NULL THEN
        total_pendente := 0.00; -- Corrigido de 0 para 0.00
    END IF;

    RETURN total_pendente;
END;
$$ LANGUAGE plpgsql;

-- Exemplo de teste da Função 2:
-- SELECT valor_pendente_cliente('contato@aguasexemplo.com.br') AS pendente;


-- -----------------------------------------------------
-- PROCEDURE 1: Registrar pagamento
-- -----------------------------------------------------
CREATE OR REPLACE PROCEDURE registrar_pagamento(
    p_requerimento   VARCHAR,
    p_data_pagamento DATE
)
AS $$
BEGIN
  UPDATE requerimento_analise
     SET datapagamento = p_data_pagamento
   WHERE idrequerimento = p_requerimento;
END;
$$ LANGUAGE plpgsql;

-- Exemplo de teste da Procedure 1:
-- CALL registrar_pagamento('R1005', '2025-07-20');
-- SELECT idrequerimento, datapagamento FROM requerimento_analise WHERE idrequerimento = 'R1005';


-- -----------------------------------------------------
-- TRIGGER 1: Validar envio de boletim após pagamento
-- -----------------------------------------------------

-- Primeiro, a FUNÇÃO que o trigger irá chamar:
CREATE OR REPLACE FUNCTION trg_validar_envio_apos_pagamento()
RETURNS TRIGGER AS $$
DECLARE
    v_pagamento DATE;
BEGIN
    IF NEW.statusenvio = 'Enviado' THEN 
        SELECT datapagamento
          INTO v_pagamento
        FROM requerimento_analise
        WHERE idrequerimento = NEW.idrequerimento;

        IF v_pagamento IS NULL THEN
            RAISE EXCEPTION
                'Nao e possivel enviar laudo para requerimento % sem pagamento.',
                NEW.idrequerimento;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Agora, o TRIGGER que é disparado
CREATE OR REPLACE TRIGGER validar_envio_apos_pagamento -- Nome do Trigger corrigido
  BEFORE INSERT OR UPDATE OF statusenvio
  ON boletim
  FOR EACH ROW
  EXECUTE FUNCTION trg_validar_envio_apos_pagamento();

-- Exemplo de teste do Trigger (deve falhar se R1005 não tiver pagamento):
-- UPDATE boletim
--    SET statusenvio = 'Enviado'
--  WHERE idboletim = 'B2025001';