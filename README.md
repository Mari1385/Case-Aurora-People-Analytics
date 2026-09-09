# 📊 Aurora Serviços Corporativos — Case de People Analytics
![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-1F4E5F?style=flat-square)
![Power BI](https://img.shields.io/badge/Power%20BI-em%20constru%C3%A7%C3%A3o-B45309?style=flat-square)
![Status](https://img.shields.io/badge/Status-Portfólio-2E7D4F?style=flat-square)

**Um diagnóstico de People Analytics para uma empresa fictícia de 1.000 funcionários — da pergunta de negócio ao SQL validado.**

Este projeto simula o trabalho de uma Analista de Dados dentro de uma área de Gente: 5 perguntas reais de RH investigadas com hipóteses testáveis, resolvidas em SQL Server (T-SQL) e validadas contra a base real.

---

## 🧭 O problema de negócio
A **Aurora Serviços Corporativos** é uma empresa fictícia de porte médio (1.000 funcionários, 6 departamentos), representada pelo banco `sql/00_schema_banco_rh_dei_1000.sql`. A Diretoria trouxe 5 dores estratégicas — cada uma ancorada em dado de mercado real (com fonte) — para um diagnóstico baseado em dados:

| # | Desafio | Pergunta de negócio |
|---|---|---|
| 1 | **Retenção de Talentos e Turnover** | O turnover é um problema geral ou está concentrado em algum recorte? |
| 2 | **Equidade Salarial de Gênero e Raça** | Dentro do mesmo cargo, homens e mulheres ganham o mesmo? E entre raças? |
| 3 | **Employee Experience e Engajamento** | As notas de desempenho variam por área? Isso se conecta com turnover? |
| 4 | **Pipeline de Sucessão e Meritocracia** | Quem está pronto para promoção e não foi promovido? Isso é desigual? |
| 5 | **Gestão da Força Multigeracional** | Como a pirâmide etária se distribui? Existe risco de "apagão de conhecimento"? |

---

## 🔍 Metodologia

```
Panorama de mercado → Pergunta de negócio → Hipótese testável → SQL → Insight real → Recomendação
```

A hipótese é escrita **antes** de qualquer código. Todas as queries foram validadas com resultados reais sobre a base de 1.000 funcionários — inclusive decisões metodológicas explícitas sobre período de análise (ano fiscal 2025 vs. histórico acumulado), definição de headcount ativo, e tratamento de "última avaliação" via window functions.

---

## 📁 Estrutura do repositório

| Arquivo | Conteúdo |
|---|---|
| `sql/00_schema_banco_rh_dei_1000.sql` | Script de criação e carga do banco (funcionarios, departamentos, cargos, avaliacoes, promocoes). |
| `sql/desafio1_retencao_turnover.sql` | Turnover por departamento (ano fiscal 2025) e faixas de tempo de casa. |
| `sql/desafio2_equidade_salarial.sql` | Gap salarial direto por gênero, representatividade por nível, composição racial. |
| `sql/desafio3_employee_experience.sql` | Nota média x turnover, cobertura de avaliação por tipo, regularidade por gestor. |
| `sql/desafio4_sucessao_promocoes.sql` | Elegíveis não promovidos por departamento, gênero e raça (window functions + CTEs). |
| `sql/desafio5_multigeracional.sql` | Concentração etária por nível hierárquico e comparação com benchmark nacional. |

> 🚧 Dashboard Power BI e notebooks Python: em desenvolvimento — próxima etapa do roadmap abaixo.

---

## 💡 Principais achados

- **O turnover de 2025 está concentrado, não disseminado.** Varia de **0,99% (Financeiro) a 7,69% (Marketing)** — quase 8x de diferença. Marketing e Operações merecem atenção prioritária agora.
- **O teto de vidro é mais forte que o gap salarial.** O gap salarial direto (M vs. F) existe mas é modesto e menor no topo (1,50% no Diretor). O achado que pesa mais é a representatividade: mulheres caem de **52,91% para 18,42%** da base ao Diretoria; pessoas brancas sobem de **37,38% para ~69%** no mesmo caminho.
- **A régua de avaliação não é justa — e o problema é por gestor, não por área.** A nota média quase não varia entre departamentos (7,55–7,66), mas a aplicação de PDI e avaliação 360 é praticamente abandonada em toda a empresa (~66% nunca teve, mesmo na Tecnologia). Em todo departamento, o intervalo de avaliações por pessoa vai de 0 a 3 — a inconsistência depende do gestor individual.
- **A estagnação de carreira é racial, não de gênero.** Entre elegíveis a promoção não promovidos, a diferença por gênero é pequena (25,00% × 21,87%), mas por raça é real: **29,41% (Amarela) e 26,98% (Parda)**, contra 20,81% (Branca).
- **A Aurora está descapitalizada em experiência.** Apenas **6,22%** do quadro tem 50+ anos, contra ~27% da população brasileira — e a Geração Z já é 46,28% do Operacional, mas 0% em Gerência e Diretoria.

---

## ✅ Recomendações prioritárias

1. Investigação de clima e liderança em Marketing e Operações (turnover concentrado).
2. Auditoria do pipeline de promoção com metas de representatividade por nível (gênero e raça).
3. Tornar PDI e avaliação 360 obrigatórios e padronizados, com acompanhamento por gestor.
4. Comitê de calibração de promoções, priorizando pessoas pardas e amarelas elegíveis não promovidas.
5. Programa de mentoria estruturada e plano de atração de profissionais 50+.

---

## 🛠️ Tecnologias

- **SQL Server (T-SQL)** — filtros, agregações, JOINs, subqueries correlacionadas, CTEs, window functions (`ROW_NUMBER() OVER PARTITION BY`)
- **Metodologia** — análise orientada a hipótese (Pergunta → Hipótese → SQL → Insight → Recomendação)
- **Em desenvolvimento:** Power BI/DAX, Python (pandas)

## 🗺️ Roadmap

- [x] SQL: 5 desafios, 13 hipóteses testadas e validadas
- [ ] Dashboard Power BI (modelo de dados e medidas já planejados)
- [ ] Notebook Python com análise exploratória
- [ ] README com prints do dashboard

---

## 👩‍💼 Sobre mim

Administradora, com MBA em Gestão Estratégica de Compras e pós-graduação em Gerenciamento de Projetos. Mais de 6 anos como Compradora e experiência como Analista de Diversidade, Equidade e Inclusão — a bagagem de negócio que sustenta as recomendações deste case. Em transição para Análise de Dados com foco em People Analytics.

📫 [https://www.linkedin.com/in/mariana-sil/] · [mariana.silvams13@gmail.com]

---

*Dados fictícios. Números de mercado citados nas queries possuem fonte (MTE, IBGE, SHRM, Caged/MTE, Wellhub, Evermonte Institute, Matchbox Brasil, entre outros).*
