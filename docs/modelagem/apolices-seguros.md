# Modelagem de Dados — Apólices / Seguros (núcleo) e Automóvel

> Documentação do sistema legado **SICS** (corretora de seguros, base MS Access).
> Tipos indicados conforme o DDL exportado pelo `mdbtools` (SQLite): `REAL`,
> `INTEGER`, `varchar`, `TEXT`, `DateTime`. As descrições são **inferidas** a
> partir dos nomes de coluna, dos volumes e das amostras de CSV — não há
> constraints declaradas no Access, então PKs/FKs são marcadas por convenção.

## Visão geral do contexto

A **apólice** é o núcleo do sistema. Toda venda de seguro gera um registro em
`seguros`, identificado pela chave de negócio
`cd_controle_proposta` + `cd_sequencia_endosso` (a "proposta/apólice" e o número
sequencial do endosso — `0` é a emissão original; valores maiores são endossos).

A partir dessa chave-mestre o modelo se ramifica em:

- **Extensões por ramo** (1:1 / 1:N por item): `seguro_auto` (automóvel),
  `seguro_re` (riscos diversos/empresarial — fora deste contexto), `seguro_vida`,
  `seguro_saude` etc. Cada ramo guarda coberturas, importâncias seguradas (IS),
  prêmios e taxas específicas.
- **Detalhes do auto**: `acessorios_auto` (+ `tipo_acessorio`),
  `seguro_condutor`, `seguro_clausulas`, `seguro_questao` (+ respostas em
  `seguro_rsp`), `seguro_suseps`, `seguro_desc`, `seguro_outros`.
- **Renovação / repasse**: `aplnotrenov` (apólices não renovadas),
  `seguro_preposto` (repasse de comissão a prepostos), `seguro_locatario`
  (fiança locatícia).
- **Anexos**: `seguros_imagem` (imagens/documentos digitalizados da apólice).

Convenções de prefixo recorrentes: `cd_` = código, `vl_` = valor monetário,
`pc_` = percentual, `dt_`/`dh_` = data/data-hora, `fl_`/`flg` = flag/indicador,
`qt_` = quantidade, `ds_`/`tx_`/`nm_` = descrição/texto/nome, `is` = importância
segurada.

---

## seguros

**690 linhas · 79 colunas.** Cabeçalho da apólice/proposta — registro central do
sistema. Guarda identificação (proposta, apólice atual/anterior, endosso),
vínculo com cliente e seguradora, ramo SUSEP, vigência, condições financeiras
(IOF, descontos, forma de pagamento, parcelas) e dados de cobrança.

| coluna | tipo | descrição inferida |
|---|---|---|
| flgpoe | INTEGER | flag de pendência/processamento (POE) |
| obsrecibo | varchar | observação impressa no recibo |
| prmliq | REAL | prêmio líquido |
| segciaok | INTEGER | flag: dados confirmados junto à seguradora |
| subsusep | varchar | sub-ramo SUSEP |
| **cd_controle_proposta** | REAL | **PK (parte 1)** — código de controle da proposta/apólice |
| **cd_sequencia_endosso** | INTEGER | **PK (parte 2)** — sequência do endosso (0 = emissão) |
| cd_apolice_atual | REAL | número da apólice vigente (num_apolice) |
| cd_apolice_anterior | REAL | número da apólice anterior (renovação) |
| cd_cliente | REAL | **FK → clientes** (segurado) |
| cd_seguradora_atual | varchar | **FK → seguradoras** (cia atual) |
| cd_seguradora_anterior | varchar | **FK → seguradoras** (cia anterior) |
| fl_tipo_seguro | varchar | tipo de seguro (novo/renovação/endosso) |
| cd_ramo | INTEGER | **FK → ramos** (ramo do seguro: auto, RE, vida…) |
| cd_susep | varchar | **FK → suseps/seguro_suseps** (código SUSEP do corretor) |
| cd_proposta | REAL | número da proposta na seguradora |
| cd_endosso | REAL | número do endosso |
| cd_tipo_endosso | INTEGER | **FK → tipo_endosso** |
| dt_emissao_apolice | DateTime | data de emissão da apólice |
| cd_moeda_conversao | INTEGER | moeda de conversão (índice/moeda) |
| vl_fator_conversao | REAL | fator de conversão da moeda |
| vl_custo_apolice | REAL | custo de apólice (taxa fixa) |
| vl_adicional_fracionamento | REAL | adicional por pagamento fracionado |
| pc_iof | REAL | percentual de IOF |
| pc_desconto_especial | REAL | percentual de desconto especial |
| pc_desconto_corretora | REAL | percentual de desconto da corretora |
| fl_forma_pagamento | INTEGER | **FK → forma_pagamento** |
| qt_parcelas | INTEGER | quantidade de parcelas |
| dt_inicio_vigencia | DateTime | início da vigência |
| dt_termino_vigencia | DateTime | término da vigência |
| cd_pev | REAL | código PEV (proposta eletrônica de venda) |
| dh_inclusao | DateTime | data-hora de inclusão do registro |
| dh_alteracao | DateTime | data-hora da última alteração |
| dt_flag_rede | DateTime | marca de sincronização em rede |
| cd_ppw | INTEGER | código de integração PPW |
| prporgpcp | INTEGER | flag prêmio próprio/origem PCP |
| tipend | INTEGER | tipo de endosso (legado) |
| cd_proposta_ppw | REAL | número de proposta no PPW |
| aplstt | INTEGER | situação/status da apólice |
| vlrencargos | REAL | valor de encargos |
| vlrco_cocorretagem | REAL | valor de cocorretagem |
| flgjuroscomiss | INTEGER | flag: juros entram na comissão |
| clcautomatico | INTEGER | flag: cálculo automático |
| tipo_comiss | INTEGER | tipo de comissão |
| flgcomissqtd | INTEGER | flag de comissão por quantidade |
| flgsuseps | INTEGER | flag: rateio entre múltiplos SUSEPs |
| repassecia | REAL | percentual/valor de repasse à cia |
| dt_envio | DateTime | data de envio à seguradora |
| dt_saida | DateTime | data de saída/baixa |
| flgclctipsics | INTEGER | flag de cálculo tipo SICS |
| tipo_comiss_esgo | INTEGER | tipo de comissão de esgotamento |
| flgcustoapl | INTEGER | flag: cobra custo de apólice |
| flgtipodesconto | INTEGER | flag de tipo de desconto |
| pacnum | varchar | número do pacote/PAC |
| qt_parcelas_pagto | INTEGER | quantidade de parcelas de pagamento |
| codigo_produto | INTEGER | **FK → tipo_produto** (produto da cia) |
| succod | varchar | código da sucursal da seguradora |
| numci | varchar | número da CI (comunicação interna) |
| numcor | REAL | número do corretor |
| cd_endosso_anterior | REAL | endosso anterior |
| inicio_contrato | DateTime | início do contrato (apólices plurianuais) |
| final_contrato | DateTime | fim do contrato |
| dt_notacmp | DateTime | data da nota de cobrança complementar |
| parnum_notacmp | INTEGER | parcela da nota complementar |
| vlr_notacmp | REAL | valor da nota complementar |
| flg_notacmp | INTEGER | flag de nota complementar |
| nr_cartao_credito | REAL | número do cartão de crédito (pgto) |
| vencto_cartao_credito | DateTime | vencimento do cartão |
| id_cartao_credito | REAL | identificador do cartão |
| nr_cpf_titular | REAL | CPF do titular do cartão |
| flgmaisgentil | INTEGER | flag de campanha/programa "Mais Gentil" |
| cnhnum | varchar | número da CNH (segurado) |
| FLGSEGCORRETOR | INTEGER | flag: segurado é o próprio corretor |
| RELSEGCORRETOR | INTEGER | relação segurado-corretor |
| CPFSEGCORRETOR | varchar | CPF do segurado-corretor |
| DIGSEGCORRETOR | varchar | dígito do CPF do segurado-corretor |
| NOMSEGCORRETOR | varchar | nome do segurado-corretor |
| premioliquido | REAL | prêmio líquido (campo redundante/novo) |
| premiototal | REAL | prêmio total (líquido + IOF + custos) |

---

## seguro_auto

**575 linhas · 92 colunas.** Extensão da apólice para o **ramo automóvel**.
Liga-se a `seguros` por `cd_controle_proposta` + `cd_sequencia_endosso`, com
`cd_item` para múltiplos veículos. Guarda dados do veículo, coberturas (casco,
RCF-DM/DP, APP), importâncias seguradas, prêmios, franquias e comissões.

| coluna | tipo | descrição inferida |
|---|---|---|
| flgmdl | INTEGER | flag de modelo (origem da tabela FIPE) |
| tipo_franquia | INTEGER | tipo de franquia (normal/reduzida/majorada) |
| vclcod | varchar | código interno do veículo |
| vlrvclass | REAL | valor do veículo conforme classificação |
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK → seguros** (parte 2) |
| **cd_item** | INTEGER | **PK (parte 3)** — item/veículo dentro da apólice |
| cd_cliente | REAL | **FK → clientes** |
| cd_proposta | REAL | número da proposta |
| cd_modelo_veiculo | REAL | **FK → modelo_veiculo / ciaveiculos** |
| cd_marca_veiculo | INTEGER | código da marca |
| cd_tipo_cobertura | REAL | **FK → tipo_cobertura** (compreensiva/incêndio+roubo…) |
| cd_chassi_veiculo | varchar | número do chassi |
| cd_placa_veiculo | varchar | placa do veículo |
| ds_cor_veiculo | varchar | cor do veículo |
| dt_ano_fabricacao | INTEGER | ano de fabricação |
| dt_ano_modelo | INTEGER | ano do modelo |
| qt_passageiros | INTEGER | quantidade de passageiros |
| fl_combustivel | varchar | tipo de combustível |
| ds_cidade_habitual | varchar | cidade habitual de circulação |
| tx_observacao | TEXT | observações |
| vl_is_casco | REAL | IS de casco |
| vl_total_is_acessorios | REAL | IS total de acessórios |
| vl_is_carroceria | REAL | IS de carroceria |
| vl_is_rcfdm | REAL | IS RCF danos materiais |
| vl_is_rcfdp | REAL | IS RCF danos pessoais |
| vl_is_app_inv | REAL | IS APP invalidez |
| vl_premio_casco | REAL | prêmio de casco |
| vl_premio_acessorios | REAL | prêmio de acessórios |
| vl_premio_rcfdm | REAL | prêmio RCF-DM |
| vl_premio_rcfdp | REAL | prêmio RCF-DP |
| vl_premio_app | REAL | prêmio APP |
| vl_premio_casco_e | REAL | prêmio de casco do endosso |
| vl_premio_acessorios_e | REAL | prêmio de acessórios do endosso |
| vl_premio_rcfdm_e | REAL | prêmio RCF-DM do endosso |
| vl_premio_rcfdp_e | REAL | prêmio RCF-DP do endosso |
| vl_premio_app_e | REAL | prêmio APP do endosso |
| vl_franquia_obrigatoria | REAL | valor da franquia obrigatória |
| vl_franquia_acessorios | REAL | franquia de acessórios |
| vl_franquia_facultativa | REAL | franquia facultativa |
| pc_bonus | REAL | percentual de bônus |
| pc_comissao_casco | REAL | % comissão sobre casco |
| pc_comissao_rcf | REAL | % comissão sobre RCF |
| pc_comissao_app | REAL | % comissão sobre APP |
| pc_taxa_is_casco | REAL | taxa aplicada sobre IS de casco |
| cd_nivel_dm | INTEGER | nível de cobertura DM |
| cd_nivel_dp | INTEGER | nível de cobertura DP |
| dh_inclusao | DateTime | data-hora de inclusão |
| dh_alteracao | DateTime | data-hora de alteração |
| dt_flag_rede | DateTime | marca de sincronização em rede |
| vl_is_app_dmh | REAL | IS APP despesas médico-hospitalares |
| vl_is_app_mor | REAL | IS APP morte |
| CLASSE_BONUS | REAL | classe de bônus |
| VIDA_MORTE | REAL | IS vida/morte (acoplada ao auto) |
| VIDA_INV | REAL | IS vida invalidez |
| PRPVID | REAL | prêmio do seguro de vida acoplado |
| ORGVID | REAL | origem/organização do vida |
| itmstt | INTEGER | status do item |
| codapleds | varchar | código de apólice (texto, legado) |
| vl_premio_ass24hs | REAL | prêmio assistência 24h |
| vl_premio_vidros | REAL | prêmio cobertura de vidros |
| cd_lclnum | INTEGER | código do local de risco |
| vl_is_rcfdmo | REAL | IS RCF danos morais |
| vl_premio_rcfdmo | REAL | prêmio RCF danos morais |
| vl_premio_rcfdmo_e | REAL | prêmio RCF danos morais (endosso) |
| vl_premio_cls | REAL | prêmio de cláusulas adicionais |
| flgchassrem | INTEGER | flag chassi remarcado |
| flgblindado | INTEGER | flag veículo blindado |
| qtdportas | INTEGER | quantidade de portas |
| flgcombustivel | INTEGER | flag/código de combustível |
| codopr | REAL | código da operação |
| lclcod | INTEGER | código do local |
| percas | REAL | percentual/taxa de casco |
| vlrnfs | REAL | valor da nota fiscal |
| vlrblindagem | REAL | valor da blindagem |
| insipi | INTEGER | flag inclusão de IPI |
| vstespecial | INTEGER | flag vistoria especial |
| flg0km | INTEGER | flag veículo 0 km |
| vclcia | varchar | código do veículo na cia |
| fl_uso_veiculo | varchar | uso do veículo (particular/comercial) |
| flgkitgas | INTEGER | flag kit gás |
| flgcambio | INTEGER | flag câmbio (automático/manual) |
| numci | varchar | número da CI |
| agendes | varchar | descrição/agenciamento |
| renavam | REAL | número do RENAVAM |
| flgfinaciamento | varchar | flag/dados de financiamento |
| notafiscal | REAL | número da nota fiscal |
| dt_emssaida | DateTime | data de emissão/saída |
| dt_vclsaida | DateTime | data de saída do veículo (0 km) |
| nomeloja | varchar | nome da loja/concessionária |
| vl_premio_cls_e | REAL | prêmio de cláusulas do endosso |
| UF_PLACA | varchar | **FK → placa_uf** (UF da placa) |

---

## acessorios_auto

**17 linhas · 12 colunas.** Acessórios cobertos de cada veículo (item) da apólice
de auto. Liga-se a `seguro_auto` pela chave proposta+endosso+item.

| coluna | tipo | descrição inferida |
|---|---|---|
| asstxt | varchar | descrição livre do acessório |
| **cd_controle_proposta** | REAL | **PK/FK → seguros/seguro_auto** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **PK/FK → seguro_auto** (item/veículo) |
| **cd_tipo_acessorio** | INTEGER | **FK → tipo_acessorio** (tipo) |
| cd_acessorio | REAL | **FK → tipo_acessorio** (código do acessório) |
| vl_is_acessorio | REAL | importância segurada do acessório |
| dh_inclusao | DateTime | data-hora de inclusão |
| dh_alteracao | DateTime | data-hora de alteração |
| dt_flag_rede | DateTime | marca de sincronização |
| franquia | REAL | franquia do acessório |
| premio | REAL | prêmio do acessório |

---

## tipo_acessorio

**153 linhas · 4 colunas.** Tabela de domínio: catálogo de acessórios de veículo.

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_tipo_acessorio** | INTEGER | **PK (parte 1)** — categoria do acessório |
| **cd_acessorio** | REAL | **PK (parte 2)** — código do acessório |
| ds_acessorio | varchar | descrição do acessório (ex.: "RÁDIO AM/FM") |
| cd_irb | varchar | código IRB correspondente |

---

## seguro_condutor

**9 linhas · 11 colunas.** Condutores declarados do veículo segurado (perfil).

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **FK → seguro_auto** (veículo) |
| **cd_seq** | INTEGER | **PK** — sequência do condutor |
| nome | varchar | nome do condutor |
| cpfnum | varchar | CPF |
| rgnum | varchar | RG |
| cnhnum | varchar | número da CNH |
| ctgcnhnum | varchar | categoria da CNH |
| codigo | INTEGER | código interno do condutor |
| dt_nascimento | DateTime | data de nascimento |

---

## seguro_clausulas

**19 linhas · 12 colunas.** Cláusulas adicionais/particulares aplicadas ao item
da apólice (qualquer ramo, mas usado no auto).

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **FK** — item da apólice |
| cd_ramo | INTEGER | **FK → ramos** |
| **cd_clausula** | varchar | **FK → clausulas** (código da cláusula) |
| dh_inclusao | DateTime | data-hora de inclusão |
| dh_alteracao | DateTime | data-hora de alteração |
| dt_flag_rede | DateTime | marca de sincronização |
| clsvlr | REAL | valor associado à cláusula |
| vl_is_cls | REAL | importância segurada da cláusula |
| franquia | varchar | franquia (texto) |
| clstxt | varchar | texto da cláusula |

---

## seguro_questao

**3.347 linhas · 8 colunas.** Respostas ao questionário de avaliação de risco
(perfil) por item da apólice. Pareia com `seguro_rsp`/`questao`.

| coluna | tipo | descrição inferida |
|---|---|---|
| cd_resp | INTEGER | código da resposta escolhida |
| qsttxt | varchar | texto da questão (desnormalizado) |
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **FK** — item da apólice |
| **cd_questao** | INTEGER | **FK → questao** (código da questão) |
| ds_resposta | varchar | resposta (texto livre) |
| flgtipresp | varchar | tipo de resposta (S/N/numérica…) |

---

## seguro_rsp

**0 linhas · 7 colunas.** Respostas do questionário de risco (estrutura
alternativa/legada a `seguro_questao`). Atualmente vazia.

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **FK** — item da apólice |
| **qstcod** | INTEGER | **FK → questao** (código da questão) |
| rspcod | INTEGER | código da resposta |
| rspdat | DateTime | data da resposta |
| rsplnhdes | varchar | descrição/linha da resposta |

---

## seguro_suseps

**128 linhas · 5 colunas.** Rateio da apólice entre múltiplos registros SUSEP
(corretores) quando há cocorretagem. Detalha o flag `flgsuseps` de `seguros`.

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_susep** | varchar | **FK → suseps** (código SUSEP) |
| lidflg | varchar | flag de líder/principal |
| ptcper | REAL | percentual de participação |

---

## aplnotrenov

**61 linhas · 6 colunas.** Apólices marcadas como **não renovadas** (controle de
renovações perdidas/recusadas).

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| cd_ramo | REAL | **FK → ramos** |
| apolice | REAL | número da apólice (num_apolice) |
| cd_seguradora | varchar | **FK → seguradoras** |
| CD_ENDOSSO | REAL | número do endosso |

---

## seguros_imagem

**0 linhas · 12 colunas.** Imagens/documentos digitalizados anexados à apólice
(metadados de BLOB/arquivo). Atualmente vazia.

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| dt_imagem | DateTime | data da imagem |
| ds_nome_imagem | varchar | nome da imagem |
| ds_path_imagem | varchar | caminho do arquivo |
| bitmapname | varchar | nome do bitmap (legado OLE) |
| icontext | varchar | texto do ícone |
| iconid | REAL | id do ícone |
| objectname | varchar | nome do objeto OLE |
| objecttype | varchar | tipo do objeto OLE |
| postortrigger | varchar | flag/trigger pós-inserção |
| path_original | varchar | caminho original do arquivo |

---

## seguro_outros

**19 linhas · 18 colunas.** Extensão genérica para **ramos diversos** sem tabela
específica (ex.: equipamentos estacionários). Guarda prêmio, IOF, custo e dados
do bem/risco.

| coluna | tipo | descrição inferida |
|---|---|---|
| agendes | varchar | descrição/agenciamento |
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **PK** — item da apólice |
| cd_ramo | INTEGER | **FK → ramos** |
| ds_ramo | TEXT | descrição do ramo/objeto segurado |
| premio_liq | REAL | prêmio líquido |
| iof | REAL | valor de IOF |
| prm_tot | REAL | prêmio total |
| aplcst | REAL | custo de apólice |
| imsvlr | REAL | importância segurada |
| localrisco | varchar | local de risco |
| codopr | REAL | código da operação |
| rentip | INTEGER | tipo de renda/benefício |
| vlrbenf | REAL | valor do benefício |
| iddsai | INTEGER | id de saída/baixa |
| prazobenef | INTEGER | prazo do benefício |
| status | varchar | status do registro |

---

## seguro_desc

**0 linhas · 6 colunas.** Descontos aplicados ao item da apólice (por código).
Atualmente vazia.

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **FK** — item da apólice |
| cd_ramo | INTEGER | **FK → ramos** |
| **descod** | INTEGER | **PK** — código do desconto |
| desper | REAL | percentual do desconto |

---

## seguro_locatario

**0 linhas · 10 colunas.** Dados do **locatário** em seguro fiança locatícia
(ramo aluguel). Atualmente vazia.

| coluna | tipo | descrição inferida |
|---|---|---|
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_item** | INTEGER | **FK** — item da apólice |
| cd_ramo | INTEGER | **FK → ramos** |
| cd_cliente | REAL | **FK → clientes** (locatário) |
| cd_cliente_parente | REAL | **FK → clientes_parentes** (fiador/agregado) |
| flgagregado | INTEGER | flag de agregado |
| faixa_renda | INTEGER | faixa de renda |
| pespolexp | INTEGER | flag pessoa politicamente exposta (PEP) |
| nmpespolexp | varchar | nome da pessoa politicamente exposta |

---

## seguro_preposto

**0 linhas · 22 colunas.** Repasse de **comissão a prepostos** (sub-corretores)
por apólice/ramo. Atualmente vazia.

| coluna | tipo | descrição inferida |
|---|---|---|
| agendes | varchar | descrição/agenciamento |
| cd_cliente | REAL | **FK → clientes** |
| **cd_controle_proposta** | REAL | **PK/FK → seguros** (parte 1) |
| **cd_sequencia_endosso** | INTEGER | **PK/FK** (parte 2) |
| **cd_preposto** | INTEGER | **FK → prepostos** (preposto/sub-corretor) |
| cd_ramo | INTEGER | **FK → ramos** |
| pc_comissao_preposto | REAL | % de comissão do preposto |
| pc_imposto | REAL | % de imposto sobre a comissão |
| vl_comissao_preposto | REAL | valor da comissão do preposto |
| dh_inclusao | DateTime | data-hora de inclusão |
| dh_alteracao | DateTime | data-hora de alteração |
| dt_flag_rede | DateTime | marca de sincronização |
| pc_comissaoincentivo | REAL | % de comissão de incentivo |
| vlr_comissaoincentivo | REAL | valor da comissão de incentivo |
| flgrepassarincentivo | REAL | flag: repassar incentivo |
| flgformarepasseincentivo | REAL | forma de repasse do incentivo |
| flgpgtorecebe | INTEGER | flag pagamento/recebimento |
| flgtipopagtocomiss | INTEGER | tipo de pagamento da comissão |
| pc_comissaonotacompl | REAL | % de comissão da nota complementar |
| vlr_comissaonotacompl | REAL | valor da comissão da nota complementar |
| flgrepassarnotacompl | REAL | flag: repassar nota complementar |
| flgformarepassenotacompl | REAL | forma de repasse da nota complementar |

---

## Relacionamentos

Chave-mestre de todo o módulo: **`cd_controle_proposta` + `cd_sequencia_endosso`**
(proposta/apólice + endosso). Praticamente todas as tabelas deste contexto a
carregam, e as de nível de cobertura acrescentam **`cd_item`** (item/veículo/bem).

### `seguros` (cabeçalho) → entidades de cadastro
- **Clientes**: `seguros.cd_cliente → clientes` (segurado). Também presente em
  `seguro_auto`, `seguro_locatario`, `seguro_preposto`.
- **Seguradoras**: `seguros.cd_seguradora_atual` / `cd_seguradora_anterior →
  seguradoras`; idem `aplnotrenov.cd_seguradora`.
- **Ramos**: `seguros.cd_ramo → ramos`; sub-ramo em `cd_susep`/`subsusep`
  (ver `ramo_susep`, `suseps`).
- **Produto / endosso / pagamento**: `codigo_produto → tipo_produto`,
  `cd_tipo_endosso → tipo_endosso`, `fl_forma_pagamento → forma_pagamento`.

### `seguros` → financeiro (fora deste contexto, citado p/ ligação)
- **Parcelas**: `parcelas` referencia a apólice pela mesma chave
  proposta+endosso (cobrança das `qt_parcelas`).
- **Comissões**: `comissoes` / `comissoes_capa` referenciam a apólice por
  proposta+endosso; repasse a prepostos via `seguro_preposto` →
  `parcelas_preposto`.

### `seguros` → sinistros
- `sinistros` (+ `sinistros_historico`) referenciam a apólice por
  proposta+endosso/ramo. O cabeçalho da apólice é a origem do sinistro.

### `seguros` → extensões por ramo (1:1 / 1:N por `cd_item`)
- **Auto**: `seguro_auto` (este contexto). Filhas do auto:
  `acessorios_auto` (→ `tipo_acessorio`), `seguro_condutor`,
  `seguro_clausulas` (→ `clausulas`), `seguro_questao` (→ `questao`),
  `seguro_rsp`, `seguro_desc`, `seguro_suseps`.
- **RE / patrimonial**: `seguro_re` (+ `seguro_re_*`) — outro contexto.
- **Vida / saúde / outros**: `seguro_vida`, `seguro_saude`, `seguro_outros`,
  `seguro_locatario` (fiança locatícia).

### Tabelas de domínio referenciadas
- `tipo_acessorio` (catálogo de acessórios) ← `acessorios_auto`.
- `clausulas` / `tipo_clausula` ← `seguro_clausulas`.
- `questao` / `tipo_resp_questao` ← `seguro_questao` / `seguro_rsp`.
- `suseps` ← `seguro_suseps`; `placa_uf` ← `seguro_auto.UF_PLACA`;
  `ciaveiculos`/`modelo_veiculo` ← `seguro_auto.cd_modelo_veiculo`.

### Controles de ciclo de vida
- **Renovação**: `seguros.cd_apolice_anterior` / `cd_seguradora_anterior` /
  `cd_endosso_anterior` apontam para a apólice anterior; `aplnotrenov` registra
  as não renovadas.
- **Anexos**: `seguros_imagem` guarda imagens/documentos da apólice.

> Observação: o Access legado não declara PK/FK. As marcações acima são
> convenções inferidas dos nomes e dos volumes; devem ser validadas e
> formalizadas como `PRIMARY KEY` / `FOREIGN KEY` + índices na migração para
> SQLite (rusqlite), indexando ao menos `(cd_controle_proposta,
> cd_sequencia_endosso)`, `cd_cliente`, `cd_seguradora_atual` e `cd_ramo`.
