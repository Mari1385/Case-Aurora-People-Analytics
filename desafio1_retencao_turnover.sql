/* =====================================================================
   DESAFIO 1 — RETENÇÃO DE TALENTOS E TURNOVER
   =====================================================================

   PANORAMA DE MERCADO
   O Brasil lidera o ranking mundial de rotatividade: dados baseados no
   Caged indicam uma taxa de 51,3% entre trabalhadores formais (mai/2025
   a abr/2026). A SHRM estima que substituir um colaborador custa entre
   50% e 200% do salário anual. Fonte: Mundo RH (abr/2026, base Caged/MTE);
   SHRM; BGC Brasil.

   PERGUNTA DE NEGÓCIO
   "A Aurora tem um problema real de retenção, ou o turnover está
   concentrado em departamentos, cargos ou faixas de tempo de casa
   específicas?"

   DECISÃO METODOLÓGICA
   Turnover calculado sobre o ano fiscal de 2025 completo (não sobre o
   histórico acumulado da empresa) — responde "a Aurora tem um problema
   HOJE", não "desde que a empresa existe". Headcount (denominador) =
   quem já estava ativo em 01/01/2025.
   ===================================================================== */

-- -----------------------------------------------------------------------
-- H1: A taxa de turnover varia significativamente entre departamentos
--     (não é um problema uniforme da empresa).
-- -----------------------------------------------------------------------
SELECT
    d.nome_departamento,
    COUNT(DISTINCT CASE WHEN f.data_admissao <= '2025-01-01'
                     AND (f.data_desligamento IS NULL OR f.data_desligamento >= '2025-01-01')
                    THEN f.id_funcionario END) AS HeadCount_Inicio_2025,
    COUNT(DISTINCT CASE WHEN f.data_desligamento BETWEEN '2025-01-01' AND '2025-12-31'
                    THEN f.id_funcionario END) AS Desligados_2025,
    ROUND(COUNT(DISTINCT CASE WHEN f.data_desligamento BETWEEN '2025-01-01' AND '2025-12-31'
                    THEN f.id_funcionario END) * 100.0
        / COUNT(DISTINCT CASE WHEN f.data_admissao <= '2025-01-01'
                     AND (f.data_desligamento IS NULL OR f.data_desligamento >= '2025-01-01')
                    THEN f.id_funcionario END), 2) AS Taxa_Turnover_Pct
FROM funcionarios f
INNER JOIN departamentos d ON f.id_departamento = d.id_departamento
GROUP BY d.nome_departamento
ORDER BY Taxa_Turnover_Pct DESC;

/* RESULTADO VALIDADO:
   Marketing 65/5   -> 7,69%
   Operações 163/10 -> 6,13%
   Comercial 153/5  -> 3,27%
   RH        49/1   -> 2,04%
   Tecnologia179/4  -> 2,23%
   Financeiro101/1  -> 0,99%
*/

-- -----------------------------------------------------------------------
-- H2: O turnover está concentrado nos primeiros 12-18 meses de casa
--     (problema de onboarding), por departamento.
-- -----------------------------------------------------------------------
SELECT
    d.nome_departamento,
    COUNT(CASE WHEN DATEDIFF(MONTH, f.data_admissao, f.data_desligamento) BETWEEN 12 AND 18 THEN 1 END) AS Desligados_12_a_18_Meses,
    ROUND(COUNT(CASE WHEN DATEDIFF(MONTH, f.data_admissao, f.data_desligamento) BETWEEN 12 AND 18 THEN 1 END) * 100.0 / COUNT(*), 2) AS Percentual,
    COUNT(CASE WHEN DATEDIFF(MONTH, f.data_admissao, f.data_desligamento) < 12 THEN 1 END) AS Desligados_Ate_11_Meses,
    COUNT(CASE WHEN DATEDIFF(MONTH, f.data_admissao, f.data_desligamento) > 18 THEN 1 END) AS Desligados_Mais_18_Meses,
    COUNT(*) AS Total_Desligamento
FROM funcionarios f
LEFT JOIN departamentos d ON f.id_departamento = d.id_departamento
WHERE f.data_desligamento BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY d.nome_departamento
ORDER BY Percentual DESC;

/* RESULTADO VALIDADO (agregado da empresa, 26 desligados em 2025):
   Até 11 meses: 8  (30,8%)
   12-18 meses:  5  (19,2%)
   Mais 18 meses:13 (50,0%)
   Por departamento as bases são pequenas (1-5 desligamentos), pouco
   robustas isoladamente.
*/

/* -----------------------------------------------------------------------
   INSIGHT
   H1 confirma com força: turnover varia de 0,99% (Financeiro) a 7,69%
   (Marketing) — quase 8x de diferença. Marketing e Operações concentram
   o problema em 2025 (diferente da leitura histórica acumulada, que
   sugeria "problema disseminado").
   H2 confirma parcialmente: metade das saídas acontece após 18 meses de
   casa — o oposto do que a hipótese de "problema de onboarding" previa.

   RECOMENDAÇÃO
   Investigação direcionada de clima e liderança em Marketing e
   Operações; monitoramento trimestral do turnover por departamento
   (não só o agregado da empresa).
   ----------------------------------------------------------------------- */
