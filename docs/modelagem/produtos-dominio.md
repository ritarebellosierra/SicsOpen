# Produtos, Domínio e Questionários

## Visão geral

Conjunto de tabelas de apoio/catálogo do SICS que sustentam a montagem de
apólices/propostas e dos questionários de risco. Dividem-se em:

- **Cláusulas**: catálogo de cláusulas (`tipo_clausula`) e cláusulas efetivamente
  aplicadas a uma proposta/endosso (`clausulas`).
- **Coberturas**: catálogos de coberturas de ramos RE — versão antiga
  (`tipo_cobertura_re`) e versão IRB/cia (`tipo_cobertura_re2`).
- **Endossos / produtos / registros**: catálogos de tipos de endosso
  (`tipo_endosso`), tipos de produto por ramo (`tipo_produto`) e tipos de
  registro (`tipo_registro`).
- **Questionários**: perguntas (`questao`), respostas de domínio por pergunta
  (`tipo_resp_questao`) e respostas dadas em cada proposta (`resposta_ques`).
- **Apoio diverso**: relatórios (`tipo_relatorio`, `tipo_relatorio2`), descrição
  de números por extenso (`tipo_des_num`) e layout de etiquetas (`tipo_etiqueta`).

**Tabelas vazias (0 linhas):** `tipo_produto`, `resposta_ques`.

Observação: o schema SQLite não declara PK/FK explícitas; as chaves abaixo são
inferidas pelos nomes/uso (códigos compartilhados como `cd_clausula`, `cd_ramo`,
`cd_controle_proposta`, `cd_sequencia_endosso`, `cd_item`).

---

## clausulas

585 linhas, 11 colunas. Não vazia.

Cláusulas efetivamente vinculadas a uma proposta/item/endosso (instâncias), com
texto, valor e franquia. Liga-se ao catálogo `tipo_clausula` por `cd_clausula`.

| coluna | tipo | descrição PT |
|---|---|---|
| clstxt | varchar | Texto da cláusula |
| cd_controle_proposta | REAL | Controle da proposta (FK proposta) |
| cd_sequencia_endosso | INTEGER | Sequência do endosso |
| cd_item | INTEGER | Item da proposta |
| cd_clausula | varchar | Código da cláusula (FK tipo_clausula.cd_clausula) |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora de alteração |
| dt_flag_rede | DateTime | Marca de sincronização/rede |
| clsvlr | REAL | Valor da cláusula |
| vl_is_cls | REAL | Valor de importância segurada da cláusula |
| franquia | varchar | Franquia |

PK (inferida): cd_controle_proposta + cd_sequencia_endosso + cd_item + cd_clausula.
FK: cd_clausula → tipo_clausula.cd_clausula.

## tipo_clausula

140 linhas, 5 colunas. Não vazia.

Catálogo de cláusulas disponíveis, por ramo e companhia (IRB).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_clausula | varchar | Código da cláusula (PK) |
| ds_clausula | varchar | Descrição da cláusula |
| dt_flag_rede | DateTime | Marca de sincronização/rede |
| cd_irb | varchar | Código IRB/companhia |
| cd_ramo | INTEGER | Código do ramo |

PK (inferida): cd_clausula.

## tipo_cobertura_re

200 linhas, 4 colunas. Não vazia.

Catálogo (versão antiga) de coberturas de ramos elementares (RE), por ramo.

| coluna | tipo | descrição PT |
|---|---|---|
| TIPO_CAD | INTEGER | Tipo de cadastro |
| CD_RAMO | INTEGER | Código do ramo |
| CD_COB | INTEGER | Código da cobertura |
| COB_DES | varchar | Descrição da cobertura |

PK (inferida): TIPO_CAD + CD_RAMO + CD_COB.

## tipo_cobertura_re2

10719 linhas, 7 colunas. Não vazia.

Catálogo (versão IRB/companhia) de coberturas RE, com código de cobertura da cia
e status. Substitui/amplia `tipo_cobertura_re`.

| coluna | tipo | descrição PT |
|---|---|---|
| cb_irb | varchar | Código IRB/companhia |
| tipo_cad | INTEGER | Tipo de cadastro |
| cd_ramo | INTEGER | Código do ramo |
| cd_cob | INTEGER | Código da cobertura |
| cob_des | varchar | Descrição da cobertura |
| cd_cob_cia | varchar | Código da cobertura na companhia |
| flgstt | INTEGER | Flag de status |

PK (inferida): cb_irb + tipo_cad + cd_ramo + cd_cob.

## tipo_endosso

410 linhas, 4 colunas. Não vazia.

Catálogo de tipos de endosso, por companhia (IRB).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_tipo_endosso | INTEGER | Código do tipo de endosso (PK) |
| ds_tipo_endosso | varchar | Descrição do tipo de endosso |
| cd_irb | varchar | Código IRB/companhia |
| flgativardocumento | varchar | Flag de ativação de documento |

PK (inferida): cd_tipo_endosso (+ cd_irb).

## tipo_produto

0 linhas, 4 colunas. **VAZIA.**

Catálogo de tipos de produto por ramo/companhia (sem dados).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_irb | varchar | Código IRB/companhia |
| cd_ramo | INTEGER | Código do ramo |
| cd_tipo | INTEGER | Código do tipo de produto |
| descricao | varchar | Descrição do produto |

PK (inferida): cd_irb + cd_ramo + cd_tipo.

## tipo_registro

49 linhas, 3 colunas. Não vazia.

Catálogo de tipos de registro (rótulos do sistema). No exemplo, descrições em branco.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_registro | INTEGER | Código do registro (PK) |
| nm_registro | varchar | Nome do registro |
| nm_registroaux | varchar | Nome auxiliar do registro |

PK (inferida): cd_registro.

## tipo_relatorio

37 linhas, 2 colunas. Não vazia.

Catálogo de relatórios disponíveis no sistema.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_codigo | INTEGER | Código do relatório (PK) |
| nm_relatorio | varchar | Nome do relatório |

PK (inferida): cd_codigo.

## tipo_relatorio2

39 linhas, 3 colunas. Não vazia.

Catálogo de relatórios (versão com agrupamento/ícone para a interface).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_codigo | INTEGER | Código do relatório (PK) |
| gruporel | varchar | Grupo do relatório / arquivo de ícone |
| nm_relatorio | varchar | Nome do relatório |

PK (inferida): cd_codigo.

## tipo_resp_questao

3325 linhas, 5 colunas. Não vazia.

Catálogo de respostas possíveis (domínio) para cada questão do questionário, por
companhia e ramo.

| coluna | tipo | descrição PT |
|---|---|---|
| CIA | varchar | Código da companhia |
| CD_RAMO | INTEGER | Código do ramo |
| CD_QUESTAO | INTEGER | Código da questão (FK questao.CD_QUESTAO) |
| CD_RESPOSTA | INTEGER | Código da resposta |
| DS_RESPOSTA | varchar | Descrição da resposta |

PK (inferida): CIA + CD_RAMO + CD_QUESTAO + CD_RESPOSTA.
FK: (CIA, CD_RAMO, CD_QUESTAO) → questao.

## tipo_des_num

37 linhas, 2 colunas. Não vazia.

Tabela de apoio: números por extenso (ex.: 1 = "UM").

| coluna | tipo | descrição PT |
|---|---|---|
| num | INTEGER | Número (PK) |
| des | varchar | Descrição por extenso |

PK (inferida): num.

## tipo_etiqueta

95 linhas, 15 colunas. Não vazia.

Catálogo de layouts de etiquetas para impressão (dimensões, margens, colunas).

| coluna | tipo | descrição PT |
|---|---|---|
| codnum | INTEGER | Código do layout (PK) |
| labels | varchar | Nome/modelo da etiqueta |
| units | REAL | Unidade de medida |
| sheet | REAL | Tipo de folha |
| columns | REAL | Número de colunas |
| rows | REAL | Número de linhas |
| columns_spacing | REAL | Espaçamento entre colunas |
| rows_spacing | REAL | Espaçamento entre linhas |
| top_margin | REAL | Margem superior |
| right_margin | REAL | Margem direita |
| bottom_margin | REAL | Margem inferior |
| height | REAL | Altura da etiqueta |
| width | REAL | Largura da etiqueta |
| shape | varchar | Forma da etiqueta |
| left_margin | REAL | Margem esquerda |

PK (inferida): codnum.

## questao

2431 linhas, 7 colunas. Não vazia.

Catálogo de perguntas do questionário de risco, por companhia e ramo.

| coluna | tipo | descrição PT |
|---|---|---|
| CIA | varchar | Código da companhia |
| CD_RAMO | INTEGER | Código do ramo |
| CD_QUESTAO | INTEGER | Código da questão (PK) |
| ds_questao | varchar | Texto da pergunta |
| flgtipresp | varchar | Tipo de resposta (ex.: U=lista, T=texto/data) |
| qststt | varchar | Status da questão |
| flgordem | INTEGER | Ordem de exibição |

PK (inferida): CIA + CD_RAMO + CD_QUESTAO.

## resposta_ques

0 linhas, 7 colunas. **VAZIA.**

Respostas dadas a cada questão em uma proposta/item (principal e cônjuge). Sem dados.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_controle_proposta | REAL | Controle da proposta (FK proposta) |
| cd_sequencia_endosso | INTEGER | Sequência do endosso |
| cd_ramo | INTEGER | Código do ramo |
| cd_item | INTEGER | Item da proposta |
| codigo | INTEGER | Código da questão respondida (FK questao.CD_QUESTAO) |
| resp_principal | INTEGER | Resposta do segurado principal |
| resp_conjuge | INTEGER | Resposta do cônjuge |

PK (inferida): cd_controle_proposta + cd_sequencia_endosso + cd_item + codigo.

---

## Relacionamentos

**Como alimentam as apólices/propostas**

- `tipo_clausula` é o catálogo; `clausulas` registra as cláusulas aplicadas a uma
  proposta/item/endosso (`cd_controle_proposta` + `cd_sequencia_endosso` +
  `cd_item`), referenciando `cd_clausula` do catálogo. (Tabela relacionada no
  schema: `seguro_clausulas`.)
- `tipo_cobertura_re` / `tipo_cobertura_re2` são os catálogos de coberturas por
  `cd_ramo` (e `cb_irb`/companhia em re2) usados na montagem dos itens segurados.
- `tipo_endosso` classifica os endossos (`cd_sequencia_endosso`) das propostas.
- `tipo_produto` (vazia) classificaria produtos por `cd_ramo`/`cd_irb`.
- `tipo_des_num`, `tipo_registro`, `tipo_relatorio`, `tipo_relatorio2` e
  `tipo_etiqueta` são apoio de interface/impressão (não ligam a apólice).

**Como alimentam os questionários**

- `questao` define as perguntas por `CIA` + `CD_RAMO` + `CD_QUESTAO`.
- `tipo_resp_questao` fornece o domínio de respostas para cada questão
  (`CIA` + `CD_RAMO` + `CD_QUESTAO` → `CD_RESPOSTA`/`DS_RESPOSTA`).
- `resposta_ques` (vazia) guardaria as respostas escolhidas em cada proposta/item,
  ligando `codigo` → `questao.CD_QUESTAO` e `resp_principal`/`resp_conjuge` →
  `tipo_resp_questao.CD_RESPOSTA`. (Tabela relacionada no schema: `seguro_questao`.)
