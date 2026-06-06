# Prepostos e comissões

## Visão geral

Este documento descreve a modelagem dos **prepostos** (sub-corretores / vendedores
da corretora) e do cálculo/pagamento de suas **comissões** no sistema legado SICS.

O cadastro central é `prepostos`. A partir dele, três tabelas auxiliares definem e
liquidam comissões:

- `preposto_comissao` — percentuais de comissão por ramo (regra/tabela de comissão).
- `preposto_deflator` — fator redutor (deflator) por faixa de parcelas.
- `parcelas_preposto` — comissão efetivamente paga, parcela a parcela.

A ligação entre um preposto e uma apólice/endosso específico é feita pela tabela
`seguro_preposto` (documentada à parte; resumida em **Relacionamentos**).

> **Atenção:** todas as quatro tabelas estão **vazias** no dump atual (0 linhas).
> Os tipos e a finalidade abaixo derivam do DDL e dos nomes de coluna.

---

## prepostos

- **Linhas:** 0 (vazia) — **Colunas:** 32

Cadastro de cada preposto (sub-corretor/vendedor): identificação, endereço,
contato, dados bancários e parâmetros de repasse/pagamento de comissão.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_preposto | INTEGER | Código do preposto. **PK** |
| nm_preposto | varchar | Nome do preposto |
| ds_endereco | varchar | Endereço (logradouro) |
| ds_bairro | varchar | Bairro |
| ds_cidade | varchar | Cidade |
| sg_estado | varchar | Sigla do estado (UF) |
| cd_cep | varchar | CEP |
| cd_cgc_cpf | varchar | CNPJ ou CPF |
| cd_telefone_1 | varchar | Telefone 1 |
| cd_telefone_2 | varchar | Telefone 2 |
| cd_telefone_3 | varchar | Telefone 3 |
| cd_telefone_4 | varchar | Telefone 4 |
| fl_pessoa | varchar | Tipo de pessoa (física/jurídica) |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora da última alteração |
| dt_flag_rede | DateTime | Marca de sincronização em rede |
| cd_prepcia | varchar | Código do preposto na seguradora/companhia |
| repassecia | REAL | Percentual/valor de repasse à companhia |
| dscpartpcor | REAL | Desconto/participação da corretora |
| flgpgto | INTEGER | Flag de forma de pagamento |
| flgpgtorecebe | INTEGER | Flag paga/recebe comissão |
| banco | INTEGER | Código do banco |
| agencia | varchar | Agência bancária |
| contacorrente | varchar | Conta corrente |
| pc_imposto | REAL | Percentual de imposto retido |
| flgtipopagtocomiss | INTEGER | Flag do tipo de pagamento da comissão |
| email | varchar | E-mail |
| cd_susep | varchar | Código SUSEP do preposto |
| flgrepassarincentivo | INTEGER | Flag de repasse de comissão de incentivo |
| flgformarepasseincentivo | INTEGER | Forma de repasse do incentivo |
| flgrepassarnotacompl | INTEGER | Flag de repasse de nota complementar |
| flgformarepassenotacompl | INTEGER | Forma de repasse da nota complementar |

---

## preposto_comissao

- **Linhas:** 0 (vazia) — **Colunas:** 8

Tabela de **percentuais de comissão** do preposto por ramo de seguro
(regra usada para calcular a comissão devida).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_preposto | INTEGER | Código do preposto. **FK → prepostos.cd_preposto** |
| cd_ramo | INTEGER | Código do ramo de seguro. **FK → ramos** |
| pc_comissao | REAL | Percentual de comissão |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora da última alteração |
| dt_flag_rede | DateTime | Marca de sincronização em rede |
| pc_comissaoincentivo | REAL | Percentual de comissão de incentivo |
| pc_comissaonotacompl | REAL | Percentual de comissão sobre nota complementar |

PK lógica: (cd_preposto, cd_ramo).

---

## preposto_deflator

- **Linhas:** 0 (vazia) — **Colunas:** 4

Fator **deflator** (redutor) aplicado à comissão por faixa de número de parcelas.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_preposto | REAL | Código do preposto. **FK → prepostos.cd_preposto** |
| qtdparini | INTEGER | Quantidade inicial de parcelas da faixa |
| qtdparfnl | INTEGER | Quantidade final de parcelas da faixa |
| perdeflator | REAL | Percentual do deflator (redutor) |

PK lógica: (cd_preposto, qtdparini, qtdparfnl).

---

## parcelas_preposto

- **Linhas:** 0 (vazia) — **Colunas:** 11

Comissão do preposto **liquidada por parcela** de uma apólice/endosso
(valores efetivamente pagos).

| coluna | tipo | descrição PT |
|---|---|---|
| CD_CONTROLE_PROPOSTA | REAL | Controle da proposta/apólice. **FK → seguros.cd_controle_proposta** |
| CD_SEQUENCIA_ENDOSSO | INTEGER | Sequência do endosso. **FK → seguros.cd_sequencia_endosso** |
| NR_PARCELA | INTEGER | Número da parcela |
| CD_PREPOSTO | INTEGER | Código do preposto. **FK → prepostos.cd_preposto** |
| VL_PARCELA | REAL | Valor da parcela |
| VL_COMISSAO_PAGO | REAL | Valor da comissão paga ao preposto |
| DT_PAGTO | DateTime | Data do pagamento |
| fl_status | varchar | Status da parcela/pagamento |
| dt_pgtimp | DateTime | Data de pagamento do imposto |
| vlr_comissaoincentivo | REAL | Valor da comissão de incentivo |
| vlr_comissaonotacompl | REAL | Valor da comissão sobre nota complementar |

PK lógica: (CD_CONTROLE_PROPOSTA, CD_SEQUENCIA_ENDOSSO, NR_PARCELA, CD_PREPOSTO).

---

## Relacionamentos

- `prepostos` (1) → (N) `preposto_comissao` via `cd_preposto` — percentuais por ramo.
- `prepostos` (1) → (N) `preposto_deflator` via `cd_preposto` — redutor por faixa de parcelas.
- `prepostos` (1) → (N) `parcelas_preposto` via `cd_preposto` — comissões pagas por parcela.
- `preposto_comissao.cd_ramo` → `ramos` — define o ramo do percentual de comissão.
- `parcelas_preposto.(CD_CONTROLE_PROPOSTA, CD_SEQUENCIA_ENDOSSO)` →
  `seguros.(cd_controle_proposta, cd_sequencia_endosso)` — apólice/endosso da parcela.
- `seguro_preposto` (22 col, **0 linhas**) é a tabela de associação entre um preposto
  e uma apólice/endosso (`cd_preposto` + `cd_controle_proposta` + `cd_sequencia_endosso`
  + `cd_ramo`), guardando o percentual e o valor de comissão calculados por apólice;
  é a origem dos lançamentos depois pagos em `parcelas_preposto`.

> Observação: o SICS (Access/SQLite) não declara FKs físicas; os vínculos acima são
> lógicos, inferidos pelos nomes de coluna.
