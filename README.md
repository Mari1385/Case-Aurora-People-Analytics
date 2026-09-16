# Aurora Serviços Corporativos | Case de People Analytics

![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-1F4E5F?style=flat-square)
![Power BI](https://img.shields.io/badge/Power%20BI-em%20constru%C3%A7%C3%A3o-B45309?style=flat-square)
![Status](https://img.shields.io/badge/Status-Portfólio-2E7D4F?style=flat-square)

**Case de People Analytics com uma empresa fictícia de 1.000 funcionários.**

O projeto parte de 5 perguntas de RH e usa SQL Server para analisar os dados e encontrar padrões que apoiem decisões.

---

## O problema de negócio

A **Aurora Serviços Corporativos** é uma empresa fictícia com 1.000 funcionários e 6 departamentos.
A Diretoria trouxe 5 perguntas para análise:

| # | Desafio | Pergunta de negócio |
|---|---|---|
| 1 | **Retenção de Talentos e Turnover** | O turnover está concentrado em algum departamento? |
| 2 | **Equidade Salarial de Gênero e Raça** | Homens e mulheres ganham o mesmo no mesmo cargo? E entre raças? |
| 3 | **Employee Experience e Engajamento** | As notas de desempenho variam entre as áreas? Existe relação com turnover? |
| 4 | **Pipeline de Sucessão e Meritocracia** | Quem está elegível para promoção e ainda não foi promovido? |
| 5 | **Gestão da Força Multigeracional** | Como as diferentes faixas etárias estão distribuídas na empresa? |

---

## Como a análise foi feita

```
Panorama de mercado → Pergunta de negócio → Hipótese → SQL → Insight → Recomendação
```
As hipóteses foram definidas antes da análise dos dados.

Os 5 desafios foram analisados usando a base fictícia da Aurora e considerando o período de 2025 quando aplicável.

---
## Estrutura do repositório

| Arquivo | Conteúdo |
|---|---|
| `sql/00_schema_banco_rh_dei_1000.sql` | Criação e carga do banco de dados. |
| `sql/desafio1_retencao_turnover.sql` | Turnover por departamento e tempo de casa. |
| `sql/desafio2_equidade_salarial.sql` | Diferenças salariais, gênero, raça e nível hierárquico. |
| `sql/desafio3_employee_experience.sql` | Desempenho, avaliações e turnover. |
| `sql/desafio4_sucessao_promocoes.sql` | Pessoas elegíveis para promoção que não foram promovidas. |
| `sql/desafio5_multigeracional.sql` | Distribuição etária por nível hierárquico. |

> Dashboard Power BI e notebook Python estão em desenvolvimento.

---

## Principais achados

- **Turnover:** O turnover de 2025 variou entre **0,99% (Financeiro) a 7,69% (Marketing).** A diferença entre os departamentos é de quase 8 vezes.
- **Equidade Salarial:** Existe diferença salarial entre homens e mulheres, mas ela é menor entre os cargos de maior nível.
    No cargo de Diretor, a diferença média foi de **1,50%**.
    A representatividade muda de forma mais significativa conforme o nível hierárquico. Mulheres representam **52,91% da base e 18,42% da Diretoria**.
    Pessoas brancas representam **37,38% da base e cerca de 69% da Diretoria**.
- **Avaliação e desempenho:** As notas médias dos departamentos são próximas, variando entre **7,55 e 7,66**.
    Por outro lado, cerca de **66% dos funcionários nunca tiveram PDI ou avaliação 360**.
    A quantidade de avaliações também varia entre os funcionários, de 0 a 3 avaliações.
- **Promoções:** Entre as pessoas elegíveis que não foram promovidas, a diferença por gênero é pequena:
    **25,00% mulheres e 21,87% homens**.
    Por raça, os percentuais foram:
        Amarela: **29,41%**
        Parda: **26,98%**
        Branca: **20,81%**
- **Força multigeracional:** Pessoas 50+ representam **6,22%** da empresa.
    A Geração Z representa **46,28% do quadro Operacional**, mas não aparece nos níveis de Gerência e Diretoria.

---
## Recomendações

1. Investigar turnover e liderança em Marketing e Operações.
2. Analisar o processo de promoção por gênero e raça.
3. Padronizar PDI e avaliação 360.
4. Acompanhar a distribuição das promoções entre os diferentes grupos.
5. Criar ações para troca de conhecimento entre diferentes gerações.

---

## Tecnologias

- **SQL Server:** filtros, agregações, JOINs, subqueries, CTEs e window functions.
- **Em desenvolvimento:** Power BI/DAX e Python com pandas.

## Roadmap

- [x] SQL: 5 desafios, 13 hipóteses analisadas
- [ ] Dashboard Power BI
- [ ] Notebook Python
- [ ] Inclusão dos prints do dashboard no README

---

## Sobre mim

Sou bacharel em Administração pela PUC Minas, com pós-graduações em Gestão Estratégica de Compras e Gerenciamento de Projetos. Minha experiência reúne visão de negócio, análise de dados e governança.
Tenho experiência com KPIs, dashboards, análises e diagnósticos para apoiar decisões.
Atualmente, direciono minha carreira para Análise de Dados, aprofundando meus conhecimentos em SQL e Power BI, além de Excel Avançado.
Neste projeto, uso dados de RH como contexto para praticar análise de dados e SQL.

[https://www.linkedin.com/in/mariana-sil/] · [mariana.silvams13@gmail.com]

---

*Dados fictícios. Números de mercado citados nas queries possuem fonte (MTE, IBGE, SHRM, Caged/MTE, Wellhub, Evermonte Institute, Matchbox Brasil, entre outros).*
