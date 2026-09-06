/* =====================================================================
   DESAFIO 5 — GESTÃO DA FORÇA DE TRABALHO MULTIGERACIONAL
   =====================================================================

   PANORAMA DE MERCADO
   76% dos líderes de RH brasileiros apontam a Geração Z como a mais
   desafiadora de gerenciar. A população com mais de 50 anos é ~27% da
   população brasileira, mas está drasticamente sub-representada nas
   empresas. Fonte: Matchbox Brasil — Tendências de RH 2026.

   PERGUNTA DE NEGÓCIO
   "Como a pirâmide etária da Aurora se distribui por cargo e
   departamento? Existe risco de 'apagão de conhecimento' concentrado em
   poucas pessoas seniores, enquanto a geração mais jovem cresce sem
   plano de carreira claro?"

   DECISÃO METODOLÓGICA
   Idade calculada com data de referência FIXA (2025-12-31), não
   GETDATE() — garante reprodutibilidade do resultado.
   ===================================================================== */

-- -----------------------------------------------------------------------
-- H1: A Diretoria e a Gerência concentram desproporcionalmente
--     profissionais 50+ em relação ao restante da empresa.
-- -----------------------------------------------------------------------
SELECT
    c.nivel_hierarquico,
    COUNT(DISTINCT f.id_funcionario) AS Total_Ativos,
    COUNT(CASE WHEN DATEDIFF(YEAR, f.data_nascimento, '2025-12-31') >= 50 THEN f.id_funcionario END) AS Qtd_50_Mais,
    ROUND(COUNT(CASE WHEN DATEDIFF(YEAR, f.data_nascimento, '2025-12-31') >= 50 THEN f.id_funcionario END) * 100.0 /
        COUNT(DISTINCT f.id_funcionario), 2) AS Pct_50_Mais
FROM funcionarios f
LEFT JOIN cargos c ON f.id_cargo = c.id_cargo
WHERE f.data_desligamento IS NULL
GROUP BY c.nivel_hierarquico
ORDER BY Pct_50_Mais DESC;

/* RESULTADO VALIDADO:
   Diretoria    38 -> 19 (50,00%)
   Gerência     71 -> 27 (38,03%)
   Coordenação 109 -> 6  (5,50%)
   Operacional 618 -> 0  (0,00%)
*/

-- -----------------------------------------------------------------------
-- H2: A Geração Z (até 29 anos) está concentrada no Operacional, com
--     pouca ou nenhuma presença em Gerência/Diretoria.
-- -----------------------------------------------------------------------
SELECT
    c.nivel_hierarquico,
    COUNT(DISTINCT f.id_funcionario) AS Total_Ativos,
    COUNT(CASE WHEN DATEDIFF(YEAR, f.data_nascimento, '2025-12-31') <= 29 THEN f.id_funcionario END) AS Qtd_Geracao_Z,
    ROUND(COUNT(CASE WHEN DATEDIFF(YEAR, f.data_nascimento, '2025-12-31') <= 29 THEN f.id_funcionario END) * 100.0 /
        COUNT(DISTINCT f.id_funcionario), 2) AS Pct_Geracao_Z
FROM funcionarios f
LEFT JOIN cargos c ON f.id_cargo = c.id_cargo
WHERE f.data_desligamento IS NULL
GROUP BY c.nivel_hierarquico
ORDER BY Pct_Geracao_Z DESC;

/* RESULTADO VALIDADO:
   Operacional 618 -> 286 (46,28%)
   Coordenação 109 -> 6   (5,50%)
   Gerência     71 -> 0   (0,00%)
   Diretoria    38 -> 0   (0,00%)
*/

-- -----------------------------------------------------------------------
-- H3: A população 50+ da Aurora está sub-representada frente aos ~27%
--     que essa faixa representa na população brasileira.
-- -----------------------------------------------------------------------
SELECT
    COUNT(DISTINCT f.id_funcionario) AS Total_Ativos,
    COUNT(CASE WHEN DATEDIFF(YEAR, f.data_nascimento, '2025-12-31') >= 50 THEN f.id_funcionario END) AS Qtd_50_Mais,
    ROUND(COUNT(CASE WHEN DATEDIFF(YEAR, f.data_nascimento, '2025-12-31') >= 50 THEN f.id_funcionario END) * 100.0 /
        COUNT(DISTINCT f.id_funcionario), 2) AS Pct_50_Mais
FROM funcionarios f
WHERE f.data_desligamento IS NULL;

/* RESULTADO VALIDADO: 836 ativos -> 52 pessoas 50+ (6,22%) vs. ~27% nacional */

/* -----------------------------------------------------------------------
   INSIGHT
   H1 confirma com muita força: metade da Diretoria (50%) e mais de um
   terço da Gerência (38%) já têm 50+, contra 0% no Operacional.
   H2 confirma com muita força: Geração Z é quase metade do Operacional
   (46,28%), mas ausente de Gerência/Diretoria (0% nos dois).
   H3 confirma com força: só 6,22% do quadro tem 50+, vs. ~27% nacional
   — sub-representação de mais de 4x.

   RECOMENDAÇÃO
   O risco real é a combinação de conhecimento concentrado em poucas
   pessoas seniores no topo, sem trilha de sucessão visível vinda de
   baixo (conecta com a estagnação de carreira do Desafio 4). Programa
   de mentoria estruturada + plano de atração de profissionais 50+.
   ----------------------------------------------------------------------- */
