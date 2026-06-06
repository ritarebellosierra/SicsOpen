# Modelagem — Financeiro (parcelas, cheques, comissões, lançamentos)

Documentação do módulo financeiro do sistema legado **SICS** (corretora de
seguros, base Access). Cobre o controle de parcelas de prêmio, recebimentos por
cheque/cartão, comissões devidas pelas seguradoras à corretora, impostos e
lançamentos contábeis/financeiros.

> Inferido a partir do DDL (`schema_sqlite.sql`), do inventário
> (`inventario.tsv`) e de amostras de `csv/`. Tipos vêm do DDL convertido para
> SQLite (Access original). Tabelas legadas frequentemente **não têm PK/FK
> declaradas**; as chaves abaixo são **inferidas** pelos nomes de coluna e pelo
> padrão de uso do SICS.

## Visão geral

O fluxo financeiro parte da **apólice/endosso** (tabela `seguros`, identificada
por `cd_controle_proposta` + `cd_sequencia_endosso`) e se desdobra em:

1. **Parcelas do prêmio** (`parcelas`) — o prêmio da apólice é dividido em
   parcelas com vencimento, valor e a comissão correspondente (recebida e a
   receber). É o coração do contas-a-receber/conferência.
2. **Recebimentos** (`cheques`) — cada parcela pode ser quitada por cheque ou
   cartão; a tabela guarda o instrumento de pagamento (banco, agência, conta,
   número do cheque / cartão).
3. **Comissões** (`comissoes`, `comissoes_capa`) — comissão que a seguradora
   paga à corretora, processada em **lotes** por seguradora. `comissoes` é o
   detalhe (item a item, por documento/parcela) e `comissoes_capa` é a capa
   (totais do lote: bruta, IRF, ISS, INSS, líquida).
4. **Impostos** (`imposto`) — faixas/alíquotas (ISS, IRF, INSS) aplicadas sobre
   a comissão.
5. **Formas de pagamento** (`forma_pagamento`) — domínio de tipos de movimento.
6. **Contabilização** (`financeiro`, `lancamento_diario`) — lançamentos de
   caixa/livro e diário (débito/crédito). **Ambas vazias** nesta base.
7. **Pré-venda / CRM de vendas** (`vendas_*`) — apoio comercial ao atendimento.
   **Todas vazias** nesta base.

Chave de ligação recorrente: o par **`cd_controle_proposta` +
`cd_sequencia_endosso`** referencia `seguros`; o par + `cd_sequencia_parcela`
(ou `nr_parcela`) liga `cheques` → `parcelas`.

---

## parcelas

- **1.645 linhas · 13 colunas** — populada.
- **Propósito:** parcelas do prêmio de cada apólice/endosso, com vencimento,
  valor e comissão atrelada (recebida e a receber). Base do contas-a-receber.

| coluna | tipo | descrição |
|---|---|---|
| carga_anual | INTEGER | Indicador de carga/ano-base do lançamento (controle interno). |
| cd_controle_proposta | REAL | **FK → `seguros.cd_controle_proposta`**. Apólice/proposta. |
| cd_sequencia_endosso | INTEGER | **FK → `seguros.cd_sequencia_endosso`**. Endosso da apólice. |
| nr_parcela | INTEGER | **PK (parte)**. Número da parcela dentro do endosso. |
| vl_parcela | REAL | Valor da parcela do prêmio. |
| vl_comissao_recebido | REAL | Valor de comissão já recebido referente à parcela. |
| vl_comissao_a_receber | REAL | Valor de comissão ainda a receber da parcela. |
| dt_vencimento | DateTime | Data de vencimento da parcela. |
| dt_pagamento | DateTime | Data de pagamento/quitação (nulo se em aberto). |
| fl_status | varchar | Situação da parcela (ex.: `N` = não paga/aberta). |
| dh_inclusao | DateTime | Data/hora de inclusão do registro. |
| dh_alteracao | DateTime | Data/hora da última alteração. |
| dt_flag_rede | DateTime | Marca de sincronização/replicação (rede). |

> **PK inferida:** (`cd_controle_proposta`, `cd_sequencia_endosso`, `nr_parcela`).

## cheques

- **1.430 linhas · 17 colunas** — populada.
- **Propósito:** instrumentos de pagamento (cheque ou cartão) vinculados às
  parcelas — dados bancários do cheque ou identificação do cartão.

| coluna | tipo | descrição |
|---|---|---|
| cd_cartao | varchar | Identificação/código do cartão (quando pagamento por cartão). |
| cd_controle_proposta | REAL | **FK → `seguros.cd_controle_proposta`**. Apólice. |
| cd_sequencia_endosso | INTEGER | **FK → `seguros.cd_sequencia_endosso`**. Endosso. |
| cd_sequencia_parcela | INTEGER | **FK → `parcelas.nr_parcela`**. Parcela quitada. |
| cd_banco | INTEGER | Código do banco do cheque (ver `cadbancos`). |
| cd_cheque | varchar | Número do cheque. |
| dt_cheque | DateTime | Data do cheque (bom para / emissão). |
| vl_cheque | REAL | Valor do cheque/pagamento. |
| dh_inclusao | DateTime | Data/hora de inclusão. |
| dh_alteracao | DateTime | Data/hora da última alteração. |
| dt_flag_rede | DateTime | Marca de sincronização/replicação (rede). |
| cd_agencia | INTEGER | Agência bancária do cheque. |
| cd_conta | varchar | Conta-corrente do cheque. |
| vctcartao | varchar | Vencimento do cartão. |
| cgccpf | varchar | CNPJ/CPF do emitente/titular (dado pessoal). |
| flgpgt | INTEGER | Flag de pagamento (quitado/compensado). |
| parstatus | INTEGER | Status da parcela associada. |

> **PK inferida:** (`cd_controle_proposta`, `cd_sequencia_endosso`,
> `cd_sequencia_parcela`, `cd_cheque`).

## comissoes

- **1.102 linhas · 28 colunas** — populada.
- **Propósito:** detalhe (item a item) das comissões pagas pelas seguradoras à
  corretora, processadas em lotes. Inclui percentual, valor de
  crédito/débito, documento de origem e vínculo ao lançamento financeiro.

| coluna | tipo | descrição |
|---|---|---|
| edsnum | REAL | Número do endosso/apólice de origem da comissão. |
| percomiss | REAL | Percentual de comissão aplicado. |
| vlprmcomiss | REAL | Valor do prêmio base de cálculo da comissão. |
| cd_seguradora | varchar | **FK → `seguradoras`**. Seguradora pagadora. |
| cd_numero_lote | REAL | **FK → `comissoes_capa.CD_NUMERO_LOTE`**. Lote de comissão. |
| cd_item_lote | INTEGER | Item dentro do lote. |
| cd_ramo | INTEGER | **FK → `ramos`**. Ramo do seguro. |
| fl_tipo_documento | varchar | Tipo do documento de origem. |
| cd_documento | REAL | Número do documento de origem. |
| cd_item_documento | INTEGER | Item do documento. |
| nr_parcela | INTEGER | **FK → `parcelas.nr_parcela`**. Parcela referente. |
| dt_baixa | DateTime | Data de baixa/recebimento da comissão. |
| vl_comissao_credito | REAL | Valor de comissão a crédito (recebido). |
| vl_comissao_debito | REAL | Valor de comissão a débito (estorno/dedução). |
| cd_moeda_conversao | INTEGER | Moeda de conversão. |
| vl_fator_conversao | REAL | Fator de conversão da moeda. |
| dh_inclusao | DateTime | Data/hora de inclusão. |
| dh_alteracao | DateTime | Data/hora da última alteração. |
| dt_flag_rede | DateTime | Marca de sincronização/replicação (rede). |
| cd_susep | varchar | **FK → `prepostos`/`suseps`**. Código SUSEP do preposto/corretor. |
| historico | varchar | Histórico/descrição do lançamento de comissão. |
| SEGNOM | varchar | Nome da seguradora (desnormalizado). |
| flgtipoimput | INTEGER | Flag de tipo de imputação/lançamento. |
| succod | varchar | Código de sucursal/filial. |
| transacao | INTEGER | Código de transação. |
| cd_lancamento | INTEGER | **FK → `financeiro.seqlan`**. Lançamento financeiro gerado. |
| cd_movimento | INTEGER | Código do movimento. |
| vl_comissao_apo | REAL | Valor de comissão apropriado/da apólice. |

> **PK inferida:** (`cd_seguradora`, `cd_numero_lote`, `cd_item_lote`).

## comissoes_capa

- **368 linhas · 11 colunas** — populada.
- **Propósito:** capa (cabeçalho/totais) do lote de comissão por seguradora —
  consolida bruta, impostos (IRF/ISS/INSS) e líquida do lote.

| coluna | tipo | descrição |
|---|---|---|
| CD_SEGURADORA | varchar | **PK (parte) · FK → `seguradoras`**. Seguradora. |
| CD_NUMERO_LOTE | REAL | **PK (parte)**. Número do lote de comissão. |
| DT_BAIXA | DateTime | Data de baixa/processamento do lote. |
| VLRCOMISSBRUTA | REAL | Valor da comissão bruta do lote. |
| VLRIRF | REAL | Valor de IRF (Imposto de Renda na Fonte) retido. |
| VLRISS | REAL | Valor de ISS retido. |
| VLRCOMISSLIQ | REAL | Valor da comissão líquida do lote. |
| VLRDEBCRED | REAL | Saldo de débito/crédito do lote. |
| DH_INCLUSAO | DateTime | Data/hora de inclusão. |
| migrarfinan | INTEGER | Flag: lote migrado/lançado no financeiro. |
| vlrinss | REAL | Valor de INSS retido. |

> **PK inferida:** (`CD_SEGURADORA`, `CD_NUMERO_LOTE`).
> Relação 1:N com `comissoes` (capa → itens) por (`cd_seguradora`, `cd_numero_lote`).

## forma_pagamento

- **69 linhas · 2 colunas** — populada (tabela de domínio).
- **Propósito:** domínio dos tipos de forma/movimento de pagamento usados nos
  lançamentos (ex.: `0` = "SEM MOVIMENTO DE VALOR", `1` = "PREMIO A RESTITUIR").

| coluna | tipo | descrição |
|---|---|---|
| fl_forma_pagamento | INTEGER | **PK**. Código da forma de pagamento. |
| ds_forma_pagamento | varchar | Descrição da forma de pagamento. |

## imposto

- **4 linhas · 4 colunas** — populada (tabela de parâmetros).
- **Propósito:** faixas/alíquotas de impostos retidos sobre comissão (ISS, IRF,
  INSS) — valor inicial/final da faixa e percentual aplicado.

| coluna | tipo | descrição |
|---|---|---|
| imposnom | varchar | **PK (parte)**. Nome do imposto (ISS, IRF, INSS). |
| valorini | REAL | Valor inicial da faixa de incidência. |
| valorfnl | REAL | Valor final da faixa de incidência. |
| percent1 | REAL | Percentual/alíquota aplicado na faixa. |

## financeiro

- **0 linhas · 19 colunas** — **VAZIA** nesta base.
- **Propósito (inferido):** lançamentos financeiros / livro-caixa da corretora,
  com previsto x realizado, débito/crédito, parcelamento e vínculo a banco/cheque/cartão.

| coluna | tipo | descrição |
|---|---|---|
| usuario | INTEGER | **FK → `usuarios`**. Usuário do lançamento. |
| dt_lan | DateTime | Data do lançamento. |
| seqlan | INTEGER | **PK**. Sequencial do lançamento. |
| flglivrocaixa | INTEGER | Flag: pertence ao livro-caixa. |
| tiplan | INTEGER | Tipo de lançamento. |
| subtiplan | INTEGER | Subtipo de lançamento. |
| atualizaref | varchar | Referência atualizada / chave de origem. |
| vlr_prev | REAL | Valor previsto. |
| vlr_real | REAL | Valor realizado. |
| parnum | INTEGER | Número da parcela. |
| partot | INTEGER | Total de parcelas. |
| flgpgto | INTEGER | Flag de pagamento (quitado). |
| bcocod | INTEGER | **FK → `cadbancos`**. Banco. |
| chqcod | varchar | **FK → `cheques.cd_cheque`**. Número do cheque. |
| crtcod | INTEGER | Código do cartão. |
| vlr_credito | REAL | Valor a crédito. |
| vlr_debito | REAL | Valor a débito. |
| ds_cmp | varchar | Complemento/descrição do lançamento. |
| ds_nominal | varchar | Favorecido/nominal do pagamento. |

## lancamento_diario

- **0 linhas · 11 colunas** — **VAZIA** nesta base.
- **Propósito (inferido):** lançamentos do diário (partidas débito/crédito) por
  data, preposto, seguradora e lote de comissão.

| coluna | tipo | descrição |
|---|---|---|
| dt_lancamento | DateTime | Data do lançamento. |
| nroseqlan | INTEGER | **PK**. Sequencial do lançamento diário. |
| tiplan | INTEGER | Tipo de lançamento. |
| cd_preposto | INTEGER | **FK → `prepostos`**. Preposto/corretor. |
| cd_seguradora | varchar | **FK → `seguradoras`**. Seguradora. |
| cd_numero_lote | REAL | **FK → `comissoes_capa.CD_NUMERO_LOTE`**. Lote de comissão. |
| bconum | INTEGER | **FK → `cadbancos`**. Banco. |
| nrodoc | varchar | Número do documento. |
| ds_favorecido | varchar | Favorecido do lançamento. |
| vlr_debito | REAL | Valor a débito. |
| vlr_credito | REAL | Valor a crédito. |

## vendas_atendimento

- **0 linhas · 19 colunas** — **VAZIA** nesta base.
- **Propósito (inferido):** módulo de pré-venda/CRM — ficha de atendimento do
  cliente com dados de perfil para cotação (não é estritamente financeiro).

| coluna | tipo | descrição |
|---|---|---|
| cd_cliente | REAL | **FK → `clientes`**. Cliente. |
| cd_cliente_atd | REAL | Código do atendimento/cliente do atendimento. |
| nm_nome | varchar | Nome do cliente/atendido (dado pessoal). |
| dt_clientedesde | DateTime | Cliente desde (data). |
| indicacao | varchar | Origem/indicação do cliente. |
| flgsindico | INTEGER | Flag: é síndico. |
| flgssaude | INTEGER | Flag: tem seguro saúde. |
| codatvprof | REAL | Código de atividade profissional. |
| flgveiculoalienado | INTEGER | Flag: veículo alienado. |
| dt_venc_cnh | DateTime | Vencimento da CNH. |
| ocupacaocondutor | varchar | Ocupação do condutor. |
| flgimovel | INTEGER | Flag: possui imóvel. |
| flghobby | INTEGER | Flag: possui hobby. |
| dh_inclusao | DateTime | Data/hora de inclusão. |
| hobby | varchar | Descrição do hobby. |
| dt_nascimento | DateTime | Data de nascimento (dado pessoal). |
| flgresidem | INTEGER | Flag: residem juntos. |
| fl_pessoa | varchar | Tipo de pessoa (F/J). |
| contato | varchar | Contato (dado pessoal). |

## vendas_condutores

- **0 linhas · 7 colunas** — **VAZIA** nesta base.
- **Propósito (inferido):** condutores adicionais informados no atendimento de
  venda (auto).

| coluna | tipo | descrição |
|---|---|---|
| cd_cliente | REAL | **FK → `clientes`**. Cliente. |
| cd_cliente_atd | REAL | Código do atendimento. |
| cd_seq | INTEGER | **PK (parte)**. Sequencial do condutor. |
| nm_nome | varchar | Nome do condutor (dado pessoal). |
| dt_nascimento | DateTime | Data de nascimento do condutor. |
| dt_venc_cnh | DateTime | Vencimento da CNH do condutor. |
| dh_inclusao | DateTime | Data/hora de inclusão. |

## vendas_filhos

- **0 linhas · 6 colunas** — **VAZIA** nesta base.
- **Propósito (inferido):** filhos/dependentes do cliente informados no
  atendimento de venda.

| coluna | tipo | descrição |
|---|---|---|
| cd_cliente | REAL | **FK → `clientes`**. Cliente. |
| cd_cliente_atd | REAL | Código do atendimento. |
| cd_seq | INTEGER | **PK (parte)**. Sequencial do dependente. |
| nm_nome | varchar | Nome do filho/dependente (dado pessoal). |
| dt_nascimento | DateTime | Data de nascimento. |
| dh_inclusao | DateTime | Data/hora de inclusão. |

## vendas_outrosseguros

- **0 linhas · 11 colunas** — **VAZIA** nesta base.
- **Propósito (inferido):** outros seguros do cliente (concorrência/renovação)
  registrados no atendimento, para acompanhamento de vencimentos.

| coluna | tipo | descrição |
|---|---|---|
| cd_cliente | REAL | **FK → `clientes`**. Cliente. |
| cd_cliente_atd | REAL | Código do atendimento. |
| cd_seq | INTEGER | **PK (parte)**. Sequencial. |
| cia | varchar | Companhia/seguradora do outro seguro. |
| seguros | varchar | Descrição do seguro. |
| dt_vencimento | DateTime | Vencimento do outro seguro. |
| dh_inclusao | DateTime | Data/hora de inclusão. |
| cd_ramo | INTEGER | **FK → `ramos`**. Ramo do seguro. |
| flgtipo | INTEGER | Tipo/flag de classificação. |
| flgagenda | INTEGER | Flag: gerar lembrete na agenda. |
| ds_ramo | varchar | Descrição do ramo (desnormalizado). |

---

## Relacionamentos

Chaves declaradas não existem no legado; as relações abaixo são **inferidas**
pelos nomes de coluna.

```
seguros (cd_controle_proposta, cd_sequencia_endosso)   ← apólice/endosso
  │  1:N
  ├──> parcelas (cd_controle_proposta, cd_sequencia_endosso, nr_parcela)
  │       │  1:N
  │       └──> cheques (... , cd_sequencia_parcela)        ← recebimentos
  │
  └──> (via edsnum / documento)
          comissoes (cd_seguradora, cd_numero_lote, cd_item_lote, nr_parcela)
                    │  N:1
                    └──> comissoes_capa (CD_SEGURADORA, CD_NUMERO_LOTE)  ← capa do lote

seguradoras (cd_seguradora) ──< comissoes / comissoes_capa / lancamento_diario
prepostos / suseps (cd_susep) ──< comissoes
ramos (cd_ramo) ──< comissoes / vendas_outrosseguros
clientes (cd_cliente) ──< vendas_atendimento / vendas_condutores /
                           vendas_filhos / vendas_outrosseguros

imposto (ISS/IRF/INSS)  → alíquotas aplicadas em comissoes_capa (VLRIRF/VLRISS/vlrinss)
forma_pagamento         → domínio de tipos de movimento (financeiro/parcelas)

financeiro (seqlan)  ←  comissoes.cd_lancamento     [VAZIA]
financeiro / cadbancos / cheques  ← bcocod / chqcod  [financeiro VAZIA]
lancamento_diario  → prepostos, seguradoras, comissoes_capa, cadbancos  [VAZIA]
```

**Fluxo financeiro resumido:**

1. Emitida a apólice/endosso em `seguros`, geram-se as **`parcelas`** do prêmio
   (vencimento + valor + comissão prevista por parcela).
2. O cliente paga; o pagamento é registrado em **`cheques`** (cheque ou cartão),
   ligado à parcela; `dt_pagamento`/`fl_status` da parcela são atualizados.
3. A seguradora repassa a comissão em **lotes**: cada lote tem capa
   (`comissoes_capa`, com bruta/IRF/ISS/INSS/líquida) e itens (`comissoes`,
   por documento/parcela), confrontados com a comissão prevista nas parcelas.
4. Impostos retidos seguem as faixas de **`imposto`**.
5. As baixas geram lançamentos em **`financeiro`** e **`lancamento_diario`**
   (débito/crédito) — **não populados nesta base**.

> **Observação:** `financeiro`, `lancamento_diario` e todas as `vendas_*` estão
> **vazias** neste extrato — a contabilização (livro-caixa/diário) e o módulo de
> pré-venda/CRM não tinham dados no Access exportado.
