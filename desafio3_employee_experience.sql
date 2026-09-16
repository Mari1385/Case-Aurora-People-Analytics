/* =====================================================================
   DESAFIO 3 — EMPLOYEE EXPERIENCE E ENGAJAMENTO
   =====================================================================

   PANORAMA DE MERCADO
   O Panorama do Bem-Estar Corporativo 2026 (Wellhub) mostra que
   empresas que investem de forma estruturada em bem-estar reduzem o
   turnover em até 40%. Fonte: Wellhub (2026); Mundo RH (abr/2026).

   PERGUNTA DE NEGÓCIO
   "As notas de desempenho da Aurora variam por departamento?
   Departamentos com notas mais baixas também têm turnover mais alto?"

 DEFINIÇÃO
 - Nota média: todas as avaliações do departamento, sem recorte de ano.
 - Turnover 2025: mesma lógica do Desafio 1, mas headcount inclui
   também quem foi admitido durante 2025 (não só quem já estava no
   início do ano).
   ===================================================================== */

-- -----------------------------------------------------------------------
-- H1: Departamentos com nota média mais baixa possuem mais desligamentos.
-- -----------------------------------------------------------------------
SELECT
    d.nome_departamento,
    ROUND(AVG(a.nota), 2) AS Media_Nota,
    COUNT(DISTINCT CASE WHEN f.data_desligamento BETWEEN '2025-01-01' AND '2025-12-31'
                    THEN f.id_funcionario END) AS Desligados_2025,
    COUNT(DISTINCT CASE WHEN f.data_admissao <= '2025-12-31'
                 AND (f.data_desligamento IS NULL OR f.data_desligamento >= '2025-01-01')
                THEN f.id_funcionario END) AS Total_Funcionarios,
    ROUND(COUNT(DISTINCT CASE WHEN f.data_desligamento BETWEEN '2025-01-01' AND '2025-12-31'
                    THEN f.id_funcionario END) * 100.0 /
        COUNT(DISTINCT CASE WHEN f.data_admissao <= '2025-12-31'
                 AND (f.data_desligamento IS NULL OR f.data_desligamento >= '2025-01-01')
                THEN f.id_funcionario END), 2) AS Turnover_2025
FROM funcionarios f
LEFT JOIN avaliacoes a ON f.id_funcionario = a.id_funcionario
LEFT JOIN departamentos d ON f.id_departamento = d.id_departamento
GROUP BY d.nome_departamento
ORDER BY Media_Nota DESC;

/* RESULTADO:
   Marketing   -> nota 7,66 | turnover 6,58% 
   Tecnologia  -> nota 7,61 | turnover 1,97%
   Operações   -> nota 7,60 | turnover 5,56%
   Financeiro  -> nota 7,59 | turnover 0,92%
   RH          -> nota 7,57 | turnover 1,79%
   Comercial   -> nota 7,55 | turnover 2,98%
*/

-- -----------------------------------------------------------------------
-- H2: Existem funcionários que nunca foram avaliados (por tipo de
--     avaliação: PDI, Desempenho, 360).
-- -----------------------------------------------------------------------
WITH ListaAvaliacoes AS (
    SELECT
        d.nome_departamento,
        COUNT(DISTINCT f.id_funcionario) AS Total_Ativos,
        COUNT(DISTINCT CASE WHEN a.tipo_avaliacao = 'PDI' THEN f.id_funcionario END) AS Realizado_PDI,
        COUNT(DISTINCT CASE WHEN a.tipo_avaliacao = 'Desempenho' THEN f.id_funcionario END) AS Realizado_Desempenho,
        COUNT(DISTINCT CASE WHEN a.tipo_avaliacao = '360' THEN f.id_funcionario END) AS Realizado_360
    FROM funcionarios f
    LEFT JOIN departamentos d ON f.id_departamento = d.id_departamento
    LEFT JOIN avaliacoes a ON f.id_funcionario = a.id_funcionario
    WHERE f.data_desligamento IS NULL
    GROUP BY d.nome_departamento
)
SELECT
    nome_departamento, Total_Ativos, Realizado_PDI, Realizado_Desempenho, Realizado_360,
    Total_Ativos - Realizado_PDI AS Nunca_Teve_PDI,
    Total_Ativos - Realizado_Desempenho AS Nunca_Teve_Desempenho,
    Total_Ativos - Realizado_360 AS Nunca_Teve_360
FROM ListaAvaliacoes;

/* RESULTADO:
   Tecnologia 213 -> PDI 141 | Desemp. 63  | 360 140
   Operações  191 -> PDI 132 | Desemp. 55  | 360 144
   Comercial  177 -> PDI 127 | Desemp. 47  | 360 129
   Financeiro 116 -> PDI 71  | Desemp. 35  | 360 73
   Marketing   79 -> PDI 54  | Desemp. 27  | 360 57
   RH          60 -> PDI 33  | Desemp. 22  | 360 38

   O número de pessoas que "Nunca_Teve_PDI" e "Nunca_Teve_360" estão 
   sempre altos, mesmo no departamento de Tecnologia ~66% nunca teve 
   PDI ou 360.
*/

-- -----------------------------------------------------------------------
-- H3: As lideranças fazem avaliações de forma regular e homogênea
--     entre departamentos.
-- -----------------------------------------------------------------------
WITH ListaAvaliados AS (
    SELECT
        f.id_funcionario,
        d.nome_departamento,
        COUNT(a.id_avaliacao) AS Numero_Avaliacoes
    FROM funcionarios f
    LEFT JOIN departamentos d ON f.id_departamento = d.id_departamento
    LEFT JOIN avaliacoes a ON f.id_funcionario = a.id_funcionario
    WHERE f.data_desligamento IS NULL
    GROUP BY f.id_funcionario, d.nome_departamento
)
SELECT
    nome_departamento,
    ROUND(AVG(Numero_Avaliacoes * 1.0), 2) AS Media_Avaliacoes_Por_Funcionario,
    MIN(Numero_Avaliacoes) AS Qtd_Min_Avaliacoes,
    MAX(Numero_Avaliacoes) AS Qtd_Max_Avaliacoes
FROM ListaAvaliados
GROUP BY nome_departamento
ORDER BY Media_Avaliacoes_Por_Funcionario DESC;

/* RESULTADO:  
    Min=0 e Max=3 em TODOS os departamentos:
        Financeiro 2,15
        RH 2,03 
        Tecnologia 2,02
        Comercial 1,92
        Operações 1,90
        Marketing 1,76
*/

/* -----------------------------------------------------------------------
   INSIGHT
   H1 Não confirma: nota quase não varia (7,55-7,66); Marketing tem a
   maior nota e o maior turnover ao mesmo tempo. O oposto da hipótese.
   H2 confirma: Desempenho é quase em todos os departamento, mas PDI e 360
   são deixa a desejar em toda a empresa (~66% nunca teve, mesmo na Tec).
   H3 Não confirma, porém mostra que a inconsistência
   é por gestor, não por área.

   RECOMENDAÇÃO
   Tornar PDI e 360 obrigatórios e padronizados, com acompanhamento por
   gestor. Investigar por que Marketing combina nota alta com turnover
   alto. Ponto de atenção: a nota pode não capturar os reais motivos de saída.
   ----------------------------------------------------------------------- */
