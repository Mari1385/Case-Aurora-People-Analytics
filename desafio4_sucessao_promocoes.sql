/* =====================================================================
   DESAFIO 4 — PIPELINE DE SUCESSÃO E MERITOCRACIA NAS PROMOÇÕES
   =====================================================================

   PANORAMA DE MERCADO
   Apenas 8,1% das empresas brasileiras têm plano de sucessão formal
   consistente; 45% dos profissionais dizem que oportunidades claras de
   crescimento são o principal motivo para permanecer numa empresa.
   Fonte: Evermonte Institute (dez/2025); TI Inside; Matchbox Brasil.

   PERGUNTA DE NEGÓCIO
   "Quantas pessoas na Aurora já têm nota de desempenho alta e tempo de
   casa suficiente para uma promoção, mas não foram promovidas nos
   últimos 2 anos? Esse gap é maior em algum grupo demográfico?"

   DEFINIÇÃO
   - "Última avaliação" = a mais recente de cada pessoa, de qualquer
   ano (ROW_NUMBER, sem filtro de data, porque restringir a um ano excluiria
   pessoas que a última avaliação foi realizada no ano anterior.
   - LEFT JOIN (não INNER) entre funcionários e última avaliação, para
   não perder do total quem nunca foi avaliado.
   - "Não promovido nos últimos 2 anos" = sem promoção desde 2023-12-31
  (data fixa, considerando 2025-12-31 como referência de "hoje").
   - Quem nunca foi promovido só conta como elegível se também tiver
   tempo de casa suficiente (admitido até 2023-12-31).
   ===================================================================== */

-- -----------------------------------------------------------------------
-- H1: Existe um número relevante de "elegíveis não promovidos"
--     (nota >= 8,0 na última avaliação, sem promoção há 2+ anos).
-- -----------------------------------------------------------------------
WITH UltimaAvaliacao AS (
    SELECT
        id_funcionario,
        nota,
        ROW_NUMBER() OVER (
            PARTITION BY id_funcionario
            ORDER BY data_avaliacao DESC
        ) AS posicao
    FROM avaliacoes
)
SELECT
    d.nome_departamento,
    COUNT(DISTINCT f.id_funcionario) AS Total_Funcionarios,
    COUNT(CASE
        WHEN u.nota >= 8.0 AND (
            p.data_promocao <= '2023-12-31'
            OR (p.data_promocao IS NULL AND f.data_admissao <= '2023-12-31')
        ) THEN 1
    END) AS Qtd_Elegiveis_Nao_Promovidos,
    ROUND(COUNT(CASE
            WHEN u.nota >= 8.0 AND (
                p.data_promocao <= '2023-12-31'
                OR (p.data_promocao IS NULL AND f.data_admissao <= '2023-12-31')
            ) THEN 1
        END) * 100.0 / NULLIF(COUNT(DISTINCT f.id_funcionario), 0), 2
    ) AS Pct_Represamento
FROM funcionarios f
LEFT JOIN UltimaAvaliacao u
    ON f.id_funcionario = u.id_funcionario AND u.posicao = 1
LEFT JOIN departamentos d
    ON f.id_departamento = d.id_departamento
LEFT JOIN promocoes p
    ON f.id_funcionario = p.id_funcionario
WHERE f.data_desligamento IS NULL
GROUP BY d.nome_departamento
ORDER BY Qtd_Elegiveis_Nao_Promovidos DESC;

/* RESULTADO (A soma bate com o total de 836 ativos):
   Tecnologia 213 -> 55 (25,82%)
   Operações  191 -> 46 (24,08%)
   Marketing   79 -> 18 (22,78%)
   Comercial  177 -> 40 (22,60%)
   RH          60 -> 13 (21,67%)
   Financeiro 116 -> 24 (20,69%)
*/

-- -----------------------------------------------------------------------
-- H2: Esse grupo é desproporcionalmente composto por mulheres e/ou
--     pessoas pretas/pardas (dimensões separadas via UNION ALL).
-- -----------------------------------------------------------------------
WITH UltimaAvaliacao AS (
    SELECT id_funcionario, nota,
        ROW_NUMBER() OVER (PARTITION BY id_funcionario ORDER BY data_avaliacao DESC) AS posicao
    FROM avaliacoes
),
BaseElegiveis AS (
    SELECT
        f.id_funcionario, f.genero, f.raca_etnia,
        CASE
            WHEN u.nota >= 8.0 AND (
                p.data_promocao <= '2023-12-31'
                OR (p.data_promocao IS NULL AND f.data_admissao <= '2023-12-31')
            ) THEN 1 ELSE 0
        END AS is_elegivel
    FROM funcionarios f
    LEFT JOIN UltimaAvaliacao u ON f.id_funcionario = u.id_funcionario AND u.posicao = 1
    LEFT JOIN promocoes p ON f.id_funcionario = p.id_funcionario
    WHERE f.data_desligamento IS NULL
)
SELECT 'Gênero' AS Dimensao, genero AS Categoria, COUNT(*) AS Total_Ativos,
       SUM(is_elegivel) AS Total_Elegiveis,
       ROUND(SUM(is_elegivel) * 100.0 / COUNT(*), 2) AS Pct_Elegivel
FROM BaseElegiveis
WHERE genero IN ('Feminino', 'Masculino')
GROUP BY genero

UNION ALL

SELECT 'Raça/Etnia' AS Dimensao, raca_etnia AS Categoria, COUNT(*) AS Total_Ativos,
       SUM(is_elegivel) AS Total_Elegiveis,
       ROUND(SUM(is_elegivel) * 100.0 / COUNT(*), 2) AS Pct_Elegivel
FROM BaseElegiveis
GROUP BY raca_etnia

ORDER BY Dimensao, Pct_Elegivel DESC;

/* RESULTADO:
   Genero      Feminino       404 / 101 -> 25,00%
   Genero      Masculino      407 / 89  -> 21,87%
   Raça/Etnia  Amarela         51 / 15  -> 29,41%
   Raça/Etnia  Parda          252 / 68  -> 26,98%
   Raça/Etnia  Não informado   16 / 4   -> 25,00%
   Raça/Etnia  Preta          137 / 31  -> 22,63%
   Raça/Etnia  Branca         370 / 77  -> 20,81%
   Raça/Etnia  Indígena        10 / 1   -> 10,00%
*/

/* -----------------------------------------------------------------------
   INSIGHT
   H1 confirma: 20,7% a 25,8% dos ativos em cada departamento
   possuem pessoas elegíveis não promovidas.  Padrão homogêncio, 
   sugerindo problema de política de promoção, não de área.
   H2 Não confirma por gênero (diferença de só 3pp), mas
   confirma por raça: Amarela e Parda 6-9pp acima de Branca.

   RECOMENDAÇÃO
   Comitê de calibração de promoções com critérios objetivos, priorizando
   revisão de pessoas pardas e amarelas elegíveis não promovidas.
   ----------------------------------------------------------------------- */
