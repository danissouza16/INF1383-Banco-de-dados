# Projeto da Disciplina de Banco de Dados

Este repositório acadêmico contém a implementação de um sistema de banco de dados relacional para a disciplina de Banco de Dados (INF1383). O projeto foi dividido em duas entregas (G1 e G2) e inclui a modelagem conceitual, o esquema relacional e a implementação completa em SQL.

## 1. Contexto do Projeto (O Enunciado)

O projeto central é o desenvolvimento de um sistema de gerenciamento de dados para o **Laboratório de Caracterização de Águas (LabÁguas)**.

O objetivo é substituir os processos manuais e planilhas existentes por um banco de dados robusto e rastreável. O sistema deve ser capaz de gerenciar e rastrear o ciclo de vida completo de uma amostra de água, desde o seu recebimento (vinculado a um `Cliente` e a um `Funcionario`), passando pela formalização de um `Requerimento_Analise`, a execução de múltiplos `Ensaios` (medição de `Parametros`), até a emissão de um `Boletim` final e o eventual `Descarte_Amostra`.

## 2. Estrutura do Repositório

O projeto está organizado em duas pastas principais:

* **`Relatorio/`**: Contém os documentos PDF das duas entregas do trabalho.
    * `BD1_TrabalhoG1_2025_1.pdf`: Foco na análise do problema, Modelo Entidade-Relacionamento (MER) e Esquema Lógico-Relacional.
    * `BD1_TrabalhoG2_2025_1.pdf`: Foco na implementação avançada, incluindo consultas, views, triggers e otimização.

* **`Scripts_SQL/`**: Contém todos os scripts SQL que implementam o banco de dados, separados por funcionalidade para maior clareza.

## 3. Detalhamento dos Scripts SQL

A pasta `Scripts_SQL/` contém a implementação prática do banco de dados:

* **`1_Criacao_Tabelas.sql`**: Scripts DDL (Data Definition Language). Contém todos os comandos `CREATE TABLE` para construir a estrutura do banco (Cliente, Amostra, Funcionario, Requerimento_Analise, Parametro, Ensaio, Boletim, Descarte_Amostra).

* **`2_Insercao_Dados.sql`**: Scripts DML (Data Manipulation Language). Contém uma massa de dados de exemplo (`INSERT INTO`) para popular o banco de dados e permitir a execução de testes.

* **`2b_Testes_Restricoes.sql`**: Contém scripts de `INSERT` que falham propositalmente. Servem para validar a correta aplicação das restrições de Chave Primária (PK) e Chave Estrangeira (FK).

* **`3_Consultas.sql`**: Contém uma variedade de consultas `SELECT` (DML) para extrair informações de negócio do banco. Inclui exemplos de `JOIN`, `GROUP BY`, `HAVING`, `ORDER BY` e subconsultas.

* **`4_Views.sql`**: Definição de `CREATE VIEW` para abstrair consultas complexas e reutilizáveis (ex: `vw_cliente_saldo`, `vw_reqs_atrasados`).

* **`5_Funcoes_Procedures_Triggers.sql`**: Lógica de negócio avançada implementada diretamente no banco:
    * **Funções (`CREATE FUNCTION`)**: Para cálculos reutilizáveis (ex: `qtd_parametros_fora_limite`, `valor_pendente_cliente`).
    * **Procedures (`CREATE PROCEDURE`)**: Para encapsular transações (ex: `registrar_pagamento`).
    * **Triggers (`CREATE TRIGGER`)**: Para garantir regras de negócio complexas (ex: `trg_validar_envio_apos_pagamento` que impede o envio de um boletim antes do pagamento).

* **`6_Indices.sql`**: Scripts `CREATE INDEX` para criar índices secundários em colunas frequentemente usadas em filtros (ex: `NomeCliente`, `DataColeta`), visando a otimização de performance das consultas.
