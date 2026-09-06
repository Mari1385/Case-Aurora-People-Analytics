/* =====================================================================
   DESAFIO 2 — EQUIDADE SALARIAL DE GÊNERO E RAÇA
   =====================================================================

   PANORAMA DE MERCADO
   Segundo o 5º Relatório de Transparência Salarial do MTE (RAIS), as
   mulheres recebem em média 21,3% a menos que os homens no setor
   privado brasileiro. Fonte: MTE (2026); IBGE; Diversitera/Exame (2025).

   PERGUNTA DE NEGÓCIO
   "Dentro de cada cargo da Aurora, homens e mulheres recebem o mesmo
   salário? A disparidade muda quando cruzamos com raça/etnia? Em qual
   nível hierárquico a diferença é maior?"

   DECISÕES METODOLÓGICAS
   - Escopo: apenas ativos hoje (foto do quadro atual, sem recorte de ano).
   - H1 usa comparação DIRETA Masculino x Feminino (não "vs. média do
     cargo") — alinhado à forma como o benchmark do MTE é calculado.
   - Gênero e raça/etnia são tratados em tabelas SEPARADAS — dimensões
     diferentes não devem ser comparadas na mesma tabela.
   ===================================================================== */

-- -----------------------------------------------------------------------
-- H1: Existe diferença salarial média entre gêneros dentro do mesmo
--     cargo, com mulheres recebendo menos.
-- -----------------------------------------------------------------------
SELECT
    c.nome_cargo,
    COUNT(CASE WHEN f.genero = 'Masculino' THEN 1 END) AS Qtde_Homens,
    COUNT(CASE WHEN f.genero = 'Feminino' THEN 1 END) AS Qtde_Mulheres,
    ROUND(AVG(CASE WHEN f.genero = 'Masculino' THEN f.salario END), 2) AS Media_Masculino,
    ROUND(AVG(CASE WHEN f.genero = 'Feminino' THEN f.salario END), 2) AS Media_Feminino,
    ROUND(AVG(CASE WHEN f.genero = 'Masculino' THEN f.salario END) -
          AVG(CASE WHEN f.genero = 'Feminino' THEN f.salario END), 2) AS Diferenca_Reais,
    ROUND((1 - (AVG(CASE WHEN f.genero = 'Feminino' THEN f.salario END) /
         NULLIF(AVG(CASE WHEN f.genero = 'Masculino' THEN f.salario END), 0))) * 100, 2) AS Pay_Gap_Pct
FROM funcionarios f
INNER JOIN cargos c ON f.id_cargo = c.id_cargo
WHERE f.genero IN ('Masculino', 'Feminino') AND f.data_desligamento IS NULL
GROUP BY c.nome_cargo, c.id_cargo
ORDER BY Media_Masculino DESC;

/* RESULTADO VALIDADO:
   Analista Jr      -> Gap 7,74%
   Analista Pleno   -> Gap 6,14%
   Analista Sênior  -> Gap 5,57%
   Coordenador      -> Gap 5,91%
   Gerente          -> Gap 2,94%
   Diretor          -> Gap 1,50%  (amostra pequena: só 7 mulheres)
*/

-- -----------------------------------------------------------------------
-- H2: A representatividade de mulheres cai conforme sobe o nível
--     hierárquico ("teto de vidro").
-- -----------------------------------------------------------------------
SELECT
    c.nivel_hierarquico,
    COUNT(*) AS Qtde_total,
    COUNT(CASE WHEN f.genero = 'Feminino' THEN 1 END) AS Qtde_Mulheres,
    ROUND(COUNT(CASE WHEN f.genero = 'Feminino' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS Pct_Mulheres
FROM funcionarios f
LEFT JOIN cargos c ON f.id_cargo = c.id_cargo
WHERE f.data_desligamento IS NULL
GROUP BY c.nivel_hierarquico
ORDER BY Pct_Mulheres DESC;

/* RESULTADO VALIDADO:
   Operacional  618 -> 52,91% mulheres
   Coordenação  109 -> 43,12%
   Gerência      71 -> 32,39%
   Diretoria     38 -> 18,42%
*/

-- -----------------------------------------------------------------------
-- H3: A composição racial fica mais branca conforme sobe o nível
--     hierárquico.
-- -----------------------------------------------------------------------
SELECT
    c.nivel_hierarquico,
    COUNT(CASE WHEN f.raca_etnia = 'Branca' THEN 1 END) AS Qtde_Branca,
    COUNT(CASE WHEN f.raca_etnia = 'Parda' THEN 1 END) AS Qtde_Parda,
    COUNT(CASE WHEN f.raca_etnia = 'Preta' THEN 1 END) AS Qtde_Preta,
    COUNT(CASE WHEN f.raca_etnia = 'Indígena' THEN 1 END) AS Qtde_Indigena,
    COUNT(CASE WHEN f.raca_etnia IS NULL OR f.raca_etnia = 'Não informado' THEN 1 END) AS Qtde_Nao_Informado,
    ROUND(COUNT(CASE WHEN f.raca_etnia = 'Branca' THEN 1 END) * 100.0 / NULLIF(COUNT(f.id_funcionario), 0), 2) AS Pct_Branco,
    ROUND(COUNT(CASE WHEN f.raca_etnia IN ('Preta', 'Parda') THEN 1 END) * 100.0 / NULLIF(COUNT(f.id_funcionario), 0), 2) AS Pct_Negra
FROM funcionarios f
INNER JOIN cargos c ON f.id_cargo = c.id_cargo
WHERE f.data_desligamento IS NULL
GROUP BY c.nivel_hierarquico
ORDER BY Pct_Branco DESC;

/* RESULTADO VALIDADO:
   Gerência     -> 69,01% branca | 22,54% negra
   Diretoria    -> 68,42% branca | 23,68% negra
   Coordenação  -> 58,72% branca | 33,03% negra
   Operacional  -> 37,38% branca | 53,07% negra
*/

/* -----------------------------------------------------------------------
   INSIGHT
   H1 confirma, mas o gap DIMINUI com a hierarquia (7,74% -> 1,50%) —
   padrão oposto ao esperado; possível efeito de amostra pequena no topo.
   H2 confirma com força: representatividade cai 34+ pontos percentuais
   do Operacional à Diretoria.
   H3 confirma com força: composição branca sobe de 37% para ~69% no topo.

   RECOMENDAÇÃO
   O achado que lidera a apresentação é a queda de representatividade
   (gênero e raça), não o gap salarial. Auditoria do pipeline de
   promoção com metas de representatividade por nível (ver Desafio 4).
   ----------------------------------------------------------------------- */
