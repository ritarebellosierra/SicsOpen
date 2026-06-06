# Subsistema de Tarifação / Cotação e Cálculo (prefixos `tb_*` e `rg*`)

## 1. Visão geral

Este conjunto de tabelas forma um **subsistema de cálculo / tarifação à parte**
do núcleo operacional do SICS. Os prefixos `tb_` (tabelas de cálculo/seguros) e
`rg` (regras / tabelas de risco e região) indicam um **motor de tarifação e
cotação** que aparenta ter sido **importado de outra ferramenta** (a estrutura,
a nomenclatura abreviada e os campos de vigência `viginc`/`vigfnl` seguem padrão
típico de seguradora/cosseguro, distinto do restante do banco).

Na base atual de 2026, **a quase totalidade dessas tabelas está vazia** (0
linhas). Apenas um punhado contém dados — e mesmo esses parecem ser **tabelas de
domínio / parametrização** (regiões, ramos de atividade, comissão), não
movimento real.

Por esse motivo, o subsistema é **adiado para uma versão futura** do SicsOpen e
documentado aqui de forma **resumida**: a modelagem coluna a coluna só é
detalhada para as poucas tabelas populadas. As demais ficam registradas apenas
no quadro-resumo, com propósito inferido a partir do nome, contagem de colunas e
contexto. As inferências de propósito **não são definitivas**; servem como ponto
de partida para quando esse motor for retomado.

## 2. Tabela-resumo

> Legenda dos abreviativos recorrentes: `apo`=apólice, `isg`=seguro/segurado,
> `gar`=garantia, `aut`=auto, `sin`=sinistro, `rct`/`rcb`=recibo/parcela,
> `pro`=proposta, `asi`=assinatura/lançamento, `eqp`=equipamento, `frs`=fração,
> `daf`=dados financeiros, `ctr`=contrato, `rsv`=reserva, `his`=histórico,
> `ram`=ramo, `geo`/`reg`=região, `atv`=atividade, `prf`=perfil,
> `cml`/`com`=comissão, `cfc`=coeficiente. Inferências, não confirmadas.

| Tabela | Linhas | Colunas | Propósito inferido |
|---|---:|---:|---|
| `rgptregiao` | 59 992 | 10 | **(com dados)** Tabela de risco por região/cidade por ramo+modelo, com vigência. Ver §3. |
| `rgpkregiao` | 584 | 6 | **(com dados)** Cabeçalho/domínio de regiões geográficas por ramo+modelo, com vigência. Ver §3. |
| `rgptnivcom` | 399 | 8 | **(com dados)** Níveis e taxas de comissão por ramo/modelo/tipo de pessoa. Ver §3. |
| `rgakativ` | 284 | 5 | **(com dados)** Domínio de ramos de atividade e flags de obrigatoriedade. Ver §3. |
| `rgpkprfatv` | 136 | 2 | **(com dados)** Associação perfil ↔ ramo de atividade (de/para). Ver §3. |
| `rgpkgraris2` | 55 | 4 | **(com dados)** Grupos de risco por ramo+modelo. Ver §3. |
| `tb_itau` | 48 | 3 | **(com dados)** Catálogo de tabelas/versões (aparente parametrização Itaú). Ver §3. |
| `sugcfc` | 27 | 3 | **(com dados)** Sugestão de coeficiente/região por UF. Ver §3. |
| `rsdkbem` | 9 | 3 | **(com dados)** Domínio de bens (descrição e quantidade máxima). Ver §3. |
| `tb_apo` | 0 | 49 | Apólice (cabeçalho do contrato de seguro). |
| `tb_isg_apo` | 0 | 62 | Itens de seguro/segurados da apólice. |
| `tb_frs_isg_apo` | 0 | 22 | Frações (parcelamento) do seguro da apólice. |
| `tb_ctr_rsv` | 0 | 118 | Contrato / reserva — tabela mais larga do subsistema. |
| `tb_cfg_mod_ori` | 0 | 15 | Configuração de modelo/origem do cálculo. |
| `tb_dat` | 0 | 29 | Dados (genérico) — detalhe do cálculo. |
| `tb_sol_vtr` | 0 | 29 | Solicitação de vistoria. |
| `tb_pes` | 0 | 39 | Pessoas vinculadas ao cálculo. |
| `tb_par_p` | 0 | 19 | Parâmetros (p). |
| `tb_rct_par_p` | 0 | 15 | Recibos/parcelas vinculados a parâmetros. |
| `tb_dfc_p` | 0 | 15 | Definições/financeiro (p). |
| `tb_daf` | 0 | 7 | Dados financeiros. |
| `tb_mov_ett_rmu` | 0 | 22 | Movimento de estorno/remuneração. |
| `tb_lnc_asi` | 0 | 26 | Lançamentos de assinatura. |
| `tb_ite_asi` | 0 | 26 | Itens de assinatura/lançamento. |
| `tb_l` | 0 | 17 | Lançamento (genérico). |
| `tb_cc` | 0 | 11 | Conta corrente. |
| `tb_ccr` | 0 | 8 | Conta corrente (variante). |
| `tb_ccc_aut` | 0 | 5 | Conta corrente — auto. |
| `tb_cmt_ite_sin` | 0 | 12 | Comentário/item de sinistro. |
| `tb_cla` | 0 | 7 | Classe (de risco/tarifa). |
| `tb_cls_bon` | 0 | 5 | Classe de bônus. |
| `tb_cvd` | 0 | 6 | Cobertura/coberturas (cvd). |
| `tb_gar_pla_per` | 0 | 8 | Garantia por plano/período. |
| `tb_pla_pro` | 0 | 5 | Plano da proposta. |
| `tb_rmo_pro` | 0 | 5 | Ramo da proposta. |
| `tb_qst_apv_pro` | 0 | 8 | Questionário de aprovação da proposta. |
| `tb_frm_pcm_per` | 0 | 7 | Forma de pagamento por período. |
| `tb_frq` | 0 | 4 | Frequência (de pagamento). |
| `tb_fxa_cep_reg` | 0 | 8 | Faixa de CEP por região. |
| `tb_eqp` | 0 | 3 | Equipamento. |
| `tb_eqp_adl` | 0 | 4 | Equipamento adicional. |
| `tb_atv_tab` | 0 | 6 | Atividade — tabela. |
| `tb_atv_srs` | 0 | 5 | Atividade — séries. |
| `tb_atv_emp_fgt` | 0 | 8 | Atividade — empresa/frota. |
| `tb_emp_sgr` | 0 | 3 | Empresa seguradora. |
| `tb_e_cga` | 0 | 3 | Encargo (e_cga). |
| `tb_e_frs` | 0 | 4 | Encargo por fração. |
| `tb_e_pcd_aut` | 0 | 3 | Procedimento — auto. |
| `tb_sap_ava` | 0 | 3 | Avaliação (sap_ava). |
| `tb_spe_e_doc` | 0 | 5 | Especificação/documento (entrada). |
| `tb_spe_oex_doc` | 0 | 5 | Especificação/documento (saída/oex). |
| `tb_his_gar_aut` | 0 | 21 | Histórico de garantia — auto. |
| `tb_his_mtt_aut` | 0 | 19 | Histórico de manutenção/matéria — auto. |
| `tb_his_rpt_dsd` | 0 | 16 | Histórico de repartição/desdobramento. |
| `tb_his_daf_isg` | 0 | 15 | Histórico de dados financeiros do seguro. |
| `tb_his_bnf_isg` | 0 | 14 | Histórico de beneficiário do seguro. |
| `tb_his_rct_par` | 0 | 13 | Histórico de recibos/parcelas. |
| `tb_his_eqp_isg` | 0 | 12 | Histórico de equipamento do seguro. |
| `segprprecusada2` | 0 | 17 | Seguro — prêmio/preço usado (variante 2). |
| `seginadim` | 0 | 15 | Seguro — inadimplência. |

## 3. Tabelas com dados (colunas detalhadas)

Apenas as nove tabelas abaixo contêm registros. As descrições de coluna são
inferidas a partir do nome abreviado; **não foram confirmadas contra dados**.

### `rgptregiao` — 59 992 linhas (a única com volume relevante)

Tabela de risco/agravo por **cidade** dentro de uma região geográfica, segmentada
por ramo e modelo, com vigência. Provável tarifa territorial.

| Coluna | Tipo | Inferência |
|---|---|---|
| `ramcod` | INTEGER | Código do ramo |
| `rmemdlcod` | INTEGER | Código do modelo do ramo |
| `georegcod` | INTEGER | Código da região geográfica |
| `cidcod` | INTEGER | Código da cidade |
| `cidnom` | varchar | Nome da cidade |
| `lclclacod` | INTEGER | Código da classe de localidade |
| `ufdcod` | varchar | UF |
| `flgstt` | INTEGER | Flag de status |
| `viginc` | DateTime | Início de vigência |
| `vigfnl` | DateTime | Fim de vigência |

### `rgpkregiao` — 584 linhas

Cabeçalho/domínio das regiões geográficas (nome da região), por ramo+modelo, com
vigência.

| Coluna | Tipo | Inferência |
|---|---|---|
| `ramcod` | INTEGER | Código do ramo |
| `rmemdlcod` | INTEGER | Código do modelo do ramo |
| `georegcod` | INTEGER | Código da região geográfica |
| `georegnom` | varchar | Nome da região geográfica |
| `viginc` | DateTime | Início de vigência |
| `vigfnl` | DateTime | Fim de vigência |

### `rgptnivcom` — 399 linhas

Níveis e taxas de **comissão** por ramo/modelo e tipo de pessoa.

| Coluna | Tipo | Inferência |
|---|---|---|
| `ramcod` | INTEGER | Código do ramo |
| `rmemdlcod` | INTEGER | Código do modelo do ramo |
| `pestip` | varchar | Tipo de pessoa (PF/PJ) |
| `rmecmlniv` | INTEGER | Nível de comissão |
| `viginc` | DateTime | Início de vigência |
| `comtax` | REAL | Taxa de comissão |
| `rmecmlcfc` | REAL | Coeficiente de comissão |
| `cd_irb` | varchar | Código IRB |

### `rgakativ` — 284 linhas

Domínio de **ramos de atividade** e flags de obrigatoriedade (IP, frequência,
parte/PT).

| Coluna | Tipo | Inferência |
|---|---|---|
| `ramatvcod` | INTEGER | Código do ramo de atividade |
| `ramatvdes` | varchar | Descrição do ramo de atividade |
| `ipcobrflg` | varchar | Flag de obrigatoriedade (IP) |
| `frqobrflg` | varchar | Flag de obrigatoriedade (frequência) |
| `ptcobrflg` | varchar | Flag de obrigatoriedade (parte/PT) |

### `rgpkprfatv` — 136 linhas

Associação (de/para) entre **perfil** e **ramo de atividade**.

| Coluna | Tipo | Inferência |
|---|---|---|
| `prfcod` | INTEGER | Código do perfil |
| `ramatvcod` | INTEGER | Código do ramo de atividade |

### `rgpkgraris2` — 55 linhas

Domínio de **grupos de risco** por ramo+modelo.

| Coluna | Tipo | Inferência |
|---|---|---|
| `ramcod` | INTEGER | Código do ramo |
| `rmemdlcod` | INTEGER | Código do modelo do ramo |
| `rscgracod` | INTEGER | Código do grupo de risco |
| `rscgrades` | varchar | Descrição do grupo de risco |

### `tb_itau` — 48 linhas

Catálogo de tabelas e versões (o nome sugere parametrização ligada ao Itaú
Seguros).

| Coluna | Tipo | Inferência |
|---|---|---|
| `cd_tab` | INTEGER | Código da tabela |
| `nm_tab` | varchar | Nome da tabela |
| `cd_versao` | INTEGER | Código da versão |

### `sugcfc` — 27 linhas

Sugestão de **coeficiente/região por UF**.

| Coluna | Tipo | Inferência |
|---|---|---|
| `ufdcod` | varchar | UF |
| `ufdcfc` | REAL | Coeficiente da UF |
| `ufdreg` | INTEGER | Região da UF |

### `rsdkbem` — 9 linhas

Domínio de **bens** (descrição e quantidade máxima).

| Coluna | Tipo | Inferência |
|---|---|---|
| `bemcod` | INTEGER | Código do bem |
| `bemdes` | varchar | Descrição do bem |
| `bemmaxqtd` | INTEGER | Quantidade máxima do bem |
