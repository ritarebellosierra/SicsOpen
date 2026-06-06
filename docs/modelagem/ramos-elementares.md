# Modelagem — Ramos Elementares (RE)

## Visão geral

No SICS, a tabela núcleo `seguros` guarda os dados comuns a **qualquer** apólice/proposta
(cliente, seguradora, ramo, prêmio, endosso, vigência etc.), identificada pela chave
`cd_controle_proposta` + `cd_sequencia_endosso`.

As tabelas deste documento **estendem** `seguros` conforme o **ramo** do seguro,
acrescentando os campos específicos que `seguros` não comporta:

- **Ramos Elementares / patrimonial (RE):** `seguro_re` e suas filhas
  (`seguro_re_bens`, `seguro_re_coberturas`, `seguro_re_cobertsin`,
  `seguro_re_clsbenef`, `seguro_re_clspartdecla`).

O vínculo de **todas** elas com o núcleo é sempre o par
`cd_controle_proposta` + `cd_sequencia_endosso` (FK lógica → `seguros`).
Nas tabelas que detalham itens, acrescenta-se `cd_item` (e `cd_ramo`) para identificar
o item/risco dentro da apólice.

> Observação: o banco legado (Access) **não declara** PK/FK formalmente. As chaves
> abaixo são **inferidas** a partir dos nomes de coluna, cardinalidade e uso no SICS.

> Estado dos dados (inventário): os Ramos Elementares (RE) são o conjunto **EM USO**,
> com dados reais. Apenas `seguro_re_cobertsin` está **VAZIA** (0 linhas) — a estrutura
> existe, mas o recurso não é utilizado. Indicado em cada seção. As tabelas de Vida e
> Saúde foram movidas para `versao-posterior/vida-saude.md`.

---

## seguro_re

- **Linhas:** 119 — **Colunas:** 89 — Em uso.
- **Propósito inferido:** extensão patrimonial/RE de `seguros`. Guarda, por item de
  risco, os dados específicos de seguro de Ramos Elementares: flags de riscos cobertos
  (incêndio, danos elétricos, vendaval etc.), taxas, importâncias seguradas (IS),
  prêmios e franquias por cobertura, além de dados do local de risco e do imóvel.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cls01 | REAL | Classe/parâmetro de classificação (uso interno) |
| obs | TEXT | Observações |
| cd_controle_proposta | REAL | **FK → seguros** (parte 1 da chave da proposta) |
| cd_sequencia_endosso | INTEGER | **FK → seguros** (parte 2; sequência do endosso) |
| cd_item | INTEGER | Item/risco dentro da apólice (compõe a PK) |
| cd_ramo | INTEGER | Código do ramo do seguro |
| rs_incendio | INTEGER | Flag: risco/cobertura de incêndio |
| rs_danos_eletricos | INTEGER | Flag: danos elétricos |
| rs_impacto_veic | INTEGER | Flag: impacto de veículos |
| rs_vendaval | INTEGER | Flag: vendaval |
| rs_despesas_fixas | INTEGER | Flag: despesas fixas |
| rs_perda_aluguel | INTEGER | Flag: perda de aluguel |
| rs_tumulto | INTEGER | Flag: tumulto |
| rs_roubo_bens | INTEGER | Flag: roubo de bens |
| rs_roubo_valores | INTEGER | Flag: roubo de valores |
| rs_respons_civil | INTEGER | Flag: responsabilidade civil |
| rs_quebra_vidros | INTEGER | Flag: quebra de vidros |
| vl_tx_incendio | REAL | Taxa de incêndio |
| vl_tx_danos_eletricos | REAL | Taxa de danos elétricos |
| vl_tx_impacto_veic | REAL | Taxa de impacto de veículos |
| vl_tx_vendaval | REAL | Taxa de vendaval |
| vl_tx_despesas_fixas | REAL | Taxa de despesas fixas |
| vl_tx_perda_aluguel | REAL | Taxa de perda de aluguel |
| vl_tx_tumulto | REAL | Taxa de tumulto |
| vl_tx_roubo_bens | REAL | Taxa de roubo de bens |
| vl_tx_roubo_valores | REAL | Taxa de roubo de valores |
| vl_tx_respons_civil | REAL | Taxa de responsabilidade civil |
| vl_tx_quebra_vidros | REAL | Taxa de quebra de vidros |
| vl_is_incendio | REAL | Importância segurada (IS) — incêndio |
| vl_is_danos_eletricos | REAL | IS — danos elétricos |
| vl_is_impacto_veic | REAL | IS — impacto de veículos |
| vl_is_vendaval | REAL | IS — vendaval |
| vl_is_despesas_fixas | REAL | IS — despesas fixas |
| vl_is_perda_aluguel | REAL | IS — perda de aluguel |
| vl_is_tumulto | REAL | IS — tumulto |
| vl_is_roubo_bens | REAL | IS — roubo de bens |
| vl_is_roubo_valores | REAL | IS — roubo de valores |
| vl_is_respons_civil | REAL | IS — responsabilidade civil |
| vl_is_quebra_vidros | REAL | IS — quebra de vidros |
| pc_incendio | REAL | Prêmio da cobertura de incêndio |
| pc_danos_eletricos | REAL | Prêmio — danos elétricos |
| pc_impacto_veic | REAL | Prêmio — impacto de veículos |
| pc_vendaval | REAL | Prêmio — vendaval |
| pc_despesas_fixas | REAL | Prêmio — despesas fixas |
| pc_perda_aluguel | REAL | Prêmio — perda de aluguel |
| pc_tumulto | REAL | Prêmio — tumulto |
| pc_roubo_bens | REAL | Prêmio — roubo de bens |
| pc_roubo_valores | REAL | Prêmio — roubo de valores |
| pc_respons_civil | REAL | Prêmio — responsabilidade civil |
| pc_quebra_vidros | REAL | Prêmio — quebra de vidros |
| pc_desconto_shopping | REAL | Percentual de desconto (shopping) |
| flg_tip | INTEGER | Flag de tipo |
| cidcod | INTEGER | Código da cidade |
| classe | INTEGER | Classe de risco |
| qtdbloco | INTEGER | Quantidade de blocos |
| qtdblocosegur | INTEGER | Quantidade de blocos segurados |
| vlrdeclarisco | REAL | Valor declarado do risco |
| desc_agrupamento | REAL | Desconto de agrupamento |
| cod_opr_dec | REAL | Código de operação (declaração) |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora de alteração |
| dt_flag_rede | DateTime | Data do flag de rede |
| ramatvcod | INTEGER | Código de ramo de atividade |
| shpcod | INTEGER | Código de shopping |
| ufdcod | varchar | UF |
| vl_frq_incendio | REAL | Franquia — incêndio |
| vl_frq_danos_eletricos | REAL | Franquia — danos elétricos |
| vl_frq_impacto_veic | REAL | Franquia — impacto de veículos |
| vl_frq_vendaval | REAL | Franquia — vendaval |
| vl_frq_despesas_fixas | REAL | Franquia — despesas fixas |
| vl_frq_perda_aluguel | REAL | Franquia — perda de aluguel |
| vl_frq_tumulto | REAL | Franquia — tumulto |
| vl_frq_roubo_bens | REAL | Franquia — roubo de bens |
| vl_frq_roubo_valores | REAL | Franquia — roubo de valores |
| vl_frq_respons_civil | REAL | Franquia — responsabilidade civil |
| vl_frq_quebra_vidros | REAL | Franquia — quebra de vidros |
| local_risco | varchar | Descrição/endereço do local de risco |
| pc_comissao | REAL | Percentual de comissão |
| flgclsbenf | INTEGER | Flag: possui cláusula beneficiária (→ seguro_re_clsbenef) |
| flgclspartdecla | INTEGER | Flag: possui cláusula particular declaratória (→ seguro_re_clspartdecla) |
| agravsinistro | REAL | Agravo por sinistro |
| nm_nome_imob | varchar | Nome da imobiliária |
| teltxt_imob | varchar | Telefone da imobiliária |
| cod_opr | REAL | Código de operação |
| cod_opr_porto | REAL | Código de operação (seguradora Porto) |
| pavqtd | INTEGER | Quantidade de pavimentos |
| aptblcqtd | INTEGER | Quantidade de apartamentos por bloco |
| dt_fundacao | varchar | Data de fundação do imóvel |
| tipo_locacao | INTEGER | Tipo de locação |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item`.

---

## seguro_re_bens

- **Linhas:** 137 — **Colunas:** 4 — Em uso.
- **Propósito inferido:** relação de bens segurados de uma apólice RE (lista item↔quantidade).

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_re** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_re** (parte 2; endosso) |
| bemcod | INTEGER | Código do bem segurado |
| bemqtd | INTEGER | Quantidade do bem |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `bemcod`.

---

## seguro_re_coberturas

- **Linhas:** 1105 — **Colunas:** 10 — Em uso.
- **Propósito inferido:** coberturas de uma apólice RE em formato normalizado (uma linha
  por cobertura), com taxa, IS, prêmio e franquia. Alternativa/detalhe às colunas fixas
  de `seguro_re`.

| coluna | tipo | descrição (PT) |
|---|---|---|
| tipo_cad | INTEGER | Tipo de cadastro |
| cd_controle_proposta | REAL | **FK → seguros / seguro_re** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_re** (parte 2; endosso) |
| cd_item | INTEGER | Item/risco dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| cd_cob | INTEGER | Código da cobertura |
| cd_taxa | REAL | Taxa da cobertura |
| cd_is | REAL | Importância segurada da cobertura |
| cd_premio | REAL | Prêmio da cobertura |
| cd_frq | REAL | Franquia da cobertura |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `cd_cob`.

---

## seguro_re_cobertsin

- **Linhas:** 0 — **Colunas:** 9 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** coberturas vinculadas a sinistro de apólice RE (espelho de
  `seguro_re_coberturas` voltado ao controle de sinistros).

| coluna | tipo | descrição (PT) |
|---|---|---|
| tipo_cad | INTEGER | Tipo de cadastro |
| cd_controle_proposta | REAL | **FK → seguros / seguro_re** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_re** (parte 2; endosso) |
| cd_item | INTEGER | Item/risco dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| cd_cob_sin | INTEGER | Código da cobertura de sinistro |
| vl_cob_sin | REAL | Valor da cobertura de sinistro |
| qt_cob_sin | varchar | Quantidade da cobertura de sinistro |
| flg_sin | INTEGER | Flag de sinistro |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `cd_cob_sin`.

---

## seguro_re_clsbenef

- **Linhas:** 8 — **Colunas:** 11 — Em uso (pouco).
- **Propósito inferido:** cláusula beneficiária de apólice RE — beneficiários/credores
  (ex.: credor hipotecário, financiamento) com rateio da importância segurada.
  Ativada pelo flag `flgclsbenf` de `seguro_re`.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_re** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_re** (parte 2; endosso) |
| cd_item | INTEGER | Item/risco dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| tipbenf | varchar | Tipo de beneficiário |
| cd_seq | INTEGER | Sequência do beneficiário |
| nombenf | varchar | Nome do beneficiário |
| pestip | varchar | Tipo de pessoa (física/jurídica) |
| cpfcgc | varchar | CPF/CNPJ do beneficiário |
| vlris | REAL | Importância segurada atribuída |
| vlrcls | REAL | Valor da cláusula |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `cd_seq`.

---

## seguro_re_clspartdecla

- **Linhas:** 18 — **Colunas:** 7 — Em uso (pouco).
- **Propósito inferido:** cláusulas particulares declaratórias (texto livre por linhas)
  da apólice RE. Ativada pelo flag `flgclspartdecla` de `seguro_re`.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_re** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_re** (parte 2; endosso) |
| cd_item | INTEGER | Item/risco dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| tiptxt | INTEGER | Tipo do texto/cláusula |
| tipseq | INTEGER | Sequência da linha do texto |
| txtlin | varchar | Linha de texto da cláusula |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `tiptxt` + `tipseq`.

---

## Relacionamentos

Vínculo central — todas as tabelas de ramo ligam-se ao núcleo `seguros` pela chave
composta **`cd_controle_proposta` + `cd_sequencia_endosso`** (a apólice/endosso).

```
seguros (núcleo, 1 linha por apólice/endosso)
│  PK lógica: cd_controle_proposta + cd_sequencia_endosso
│
└── seguro_re                (1:1 por item RE)         + cd_item
      ├── seguro_re_bens            (1:N — bens segurados)
      ├── seguro_re_coberturas      (1:N — coberturas)            + cd_item
      ├── seguro_re_cobertsin       (1:N — coberturas p/ sinistro) + cd_item   [VAZIA]
      ├── seguro_re_clsbenef        (1:N — cláusula beneficiária)  + cd_item
      │     (ativada por seguro_re.flgclsbenf)
      └── seguro_re_clspartdecla    (1:N — cláusulas declaratórias) + cd_item
            (ativada por seguro_re.flgclspartdecla)
```

Notas:
- O `cd_ramo` presente nas filhas redunda o ramo da apólice e ajuda a discriminar
  qual extensão aplicar; o roteamento real do ramo está em `seguros` (`cd_ramo`,
  `cd_susep`, `subsusep`).
- O par `cd_controle_proposta` + `cd_sequencia_endosso` modela o **versionamento por
  endosso**: cada endosso é uma nova sequência da mesma proposta.
- As FKs são **lógicas** (o Access legado não as declara); migrar para SQLite com
  PK/FK explícitas e índices nesse par é recomendado (ver `docs/ARCHITECTURE.md`).
- Tabela **vazia** no inventário: `seguro_re_cobertsin`. A estrutura existe, mas o
  uso efetivo concentra-se nas demais tabelas de Ramos Elementares (RE).
