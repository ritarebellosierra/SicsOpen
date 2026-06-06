# Modelagem de dados do SICS

Modelagem **real** reconstruída a partir do banco vivo `sicsw03.mdb` (mai/2026,
189 tabelas, 83 com dados). Colunas e tipos vêm do DDL extraído com `mdb-schema`;
contagens, do inventário (`data/atual_2026/inventario.tsv`).

> Descreve **estrutura** (colunas, tipos, relações). Nenhum dado pessoal ou
> senha é versionado.

## Dois grupos

### 🟢 Em uso (V1) — `docs/modelagem/`
Contextos com dados reais, alvo da primeira versão do SicsOpen:

| Contexto | Doc | Destaque |
|---|---|---|
| Clientes e pessoas | [clientes.md](clientes.md) | `clientes` (665), endereços, telefones |
| Apólices / Auto | [apolices-seguros.md](apolices-seguros.md) | `seguros` (690, núcleo), `seguro_auto` (575) |
| Ramos elementares (RE/patrimonial) | [ramos-elementares.md](ramos-elementares.md) | `seguro_re`, coberturas (1105) |
| Financeiro | [financeiro.md](financeiro.md) | `parcelas` (1645), `cheques` (1430), `comissoes` (1102) |
| Prepostos | [prepostos.md](prepostos.md) | sub-corretores e comissões |
| Domínio (cláusulas/tipos/questões) | [produtos-dominio.md](produtos-dominio.md) | `clausulas`, `questao`, `tipo_*` |
| Seguradoras e mercado | [seguradoras-mercado.md](seguradoras-mercado.md) | `seguradoras`, `ciaveiculos` (74k, FIPE), SUSEP |
| Sistema / operação / sinistros | [sistema-operacao.md](sistema-operacao.md) | `usuarios`, `agenda`, `sinistros` |

### 🟡 Versão posterior — `docs/modelagem/versao-posterior/`
Estrutura existe mas está **vazia/não usada**; fica para depois:

| Contexto | Doc |
|---|---|
| Vida e Saúde (tabelas vazias) | [versao-posterior/vida-saude.md](versao-posterior/vida-saude.md) |
| Subsistema de tarifação/cálculo (`tb_*`, `rg*`) | [versao-posterior/tarifacao-subsistema.md](versao-posterior/tarifacao-subsistema.md) |

## Chave-mestra do sistema

A apólice é identificada por **`cd_controle_proposta` + `cd_sequencia_endosso`**
(+ `cd_item` em alguns casos). Essa chave composta liga `seguros` às extensões
por ramo (`seguro_auto`, `seguro_re`, ...), a `parcelas`, `comissoes`,
`seguro_questao`, `seguro_clausulas` etc. É o eixo do modelo relacional.

## Tabelas ignoradas (não modeladas)

- **`pbcatcol`, `pbcatedt`, `pbcatfmt`, `pbcattbl`, `pbcatvld`** — catálogo
  interno do PowerBuilder (metadados de formatação), não são dados de negócio.
- **`temp`, `temp1`–`temp9`, `temparquivodiff`, `temp_carga`, `tempemail`,
  `tempveiculo`, `temp_etiqueta`** — tabelas temporárias de processamento.
- **`sequence`, `sqlbanco`** — controle interno (documentadas em sistema).

## Histórico / preservação

Além do banco de 2026, foram extraídos backups de 2017, 2012 e 2011
(`data/backups/`), porque apólices antigas foram apagadas ao longo do tempo —
alguns backups têm **mais** registros de `seguros` que o atual. A migração deve
considerar a união para não perder histórico. Ver [../LEGACY_SICS.md](../LEGACY_SICS.md).
