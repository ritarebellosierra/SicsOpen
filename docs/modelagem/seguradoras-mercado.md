# Seguradoras, Ramos SUSEP e Tabelas de Mercado

## Visão geral

Este documento descreve as tabelas do SICS relacionadas a **seguradoras (companhias)**, **ramos de seguro e classificação SUSEP**, **tabelas de veículos (FIPE/mercado)** e **dados de mercado/configuração** (oficinas, bancos, layouts de arquivos das cias, etiquetas de UF, parâmetros gerais).

Conceitos centrais:

- **Seguradora / Companhia**: identificada por `cd_irb` (código IRB da cia). Tabela `seguradoras`.
- **Corretora SUSEP**: identificada por `cd_susep` (registro SUSEP do corretor). Tabela `suseps`.
- **Ramo**: tipo de seguro (auto, vida, RE etc.), identificado por `cd_ramo`. Tabela `ramos`.
- **Veículos**: cadastro tipo FIPE por cia, em `ciaveiculos` (modelos) e `ciaveiculosfab` (ano/fabricação). São as duas maiores tabelas do conjunto (~74 mil e ~70 mil linhas).

As demais tabelas são pequenas tabelas de apoio/parametrização; várias estão **vazias** (ver indicação em cada seção).

---

## seguradoras

275 linhas, 25 colunas. **Populada.**

Cadastro das companhias seguradoras com endereço, contatos e flags de tratamento fiscal/comissão.

| coluna | tipo | descrição PT |
|---|---|---|
| clcautomatico | INTEGER | Flag de cálculo automático |
| tipo_comiss | INTEGER | Tipo de comissão |
| cd_irb | varchar | Código IRB da companhia (PK) |
| nm_companhia | varchar | Nome da companhia |
| ds_endereco | varchar | Endereço |
| ds_bairro | varchar | Bairro |
| ds_cidade | varchar | Cidade |
| sg_estado | varchar | UF (sigla do estado) |
| cd_cep | varchar | CEP |
| cd_telefone_1 | varchar | Telefone 1 |
| cd_telefone_2 | varchar | Telefone 2 |
| cd_telefone_3 | varchar | Telefone 3 |
| cd_telefone_4 | varchar | Telefone 4 |
| cd_fax | varchar | Fax |
| tx_observacao | TEXT | Observações |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora de alteração |
| FLGJUROSCOMISS | INTEGER | Flag de juros sobre comissão |
| flgcomissqtd | INTEGER | Flag de comissão por quantidade |
| flgdepto | INTEGER | Flag de uso de departamentos (ver deptos_cia) |
| tipo_comiss_esgo | INTEGER | Tipo de comissão de esgotamento |
| flgcustoapl | INTEGER | Flag de custo de apólice |
| flgcbriss | INTEGER | Flag de cobrança de ISS |
| flgcbrirf | INTEGER | Flag de cobrança de IRF |
| flgcbrinss | INTEGER | Flag de cobrança de INSS |

## deptos_cia

12 linhas, 4 colunas. **Populada.**

Departamentos/setores de contato de uma companhia.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_irb | varchar | Código IRB da companhia (FK -> seguradoras.cd_irb) |
| seq | INTEGER | Sequencial do departamento |
| nomdepto | varchar | Nome do departamento |
| teltxt | varchar | Telefone do departamento |

## ciaveiculos

73.961 linhas, 5 colunas. **Populada (tabela grande, tipo FIPE).**

Cadastro de modelos de veículos por companhia (catálogo de veículos).

| coluna | tipo | descrição PT |
|---|---|---|
| vclcia | varchar | Código da cia/tabela de veículos (FK -> seguradoras.cd_irb) |
| vclcod | varchar | Código do veículo na tabela da cia (PK composta com vclcia) |
| vcldes | varchar | Descrição do veículo (marca/modelo/versão) |
| codfipe | REAL | Código FIPE |
| categoria | INTEGER | Categoria do veículo |

## ciaveiculosfab

69.621 linhas, 8 colunas. **Populada (tabela grande, tipo FIPE).**

Detalhamento por ano-modelo/fabricação dos veículos de `ciaveiculos`.

| coluna | tipo | descrição PT |
|---|---|---|
| vclcia | varchar | Código da cia/tabela de veículos (FK -> ciaveiculos.vclcia) |
| vclcod | varchar | Código do veículo (FK -> ciaveiculos.vclcod) |
| anomdl | INTEGER | Ano-modelo |
| porqtd | INTEGER | Quantidade de portas |
| cmbcod | INTEGER | Código do câmbio |
| fipcod | INTEGER | Código FIPE |
| codcamb | INTEGER | Código de câmbio (alternativo) |
| flg3eix | INTEGER | Flag de veículo de 3 eixos |

## modelo_veiculo

0 linhas, 5 colunas. **VAZIA.**

Cadastro genérico de modelos de veículo (marca, portas, passageiros).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_modelo_veiculo | REAL | Código do modelo de veículo (PK) |
| cd_marca_veiculo | INTEGER | Código da marca do veículo |
| nm_modelo_veiculo | varchar | Nome do modelo |
| qt_portas | INTEGER | Quantidade de portas |
| qt_passageiros | INTEGER | Quantidade de passageiros |

## cadoficinas

4 linhas, 16 colunas. **Populada.**

Cadastro de oficinas (rede referenciada) com endereço e contato.

| coluna | tipo | descrição PT |
|---|---|---|
| codigo | INTEGER | Código da oficina (PK) |
| nome | varchar | Nome da oficina |
| endfld | INTEGER | Indicador de endereço preenchido |
| endlgdtip | varchar | Tipo de logradouro |
| endlgd | varchar | Logradouro |
| endnum | REAL | Número |
| endcmp | varchar | Complemento |
| endufd | varchar | UF |
| endbrr | varchar | Bairro |
| endcid | varchar | Cidade |
| endcep | varchar | CEP |
| telddd | varchar | DDD do telefone |
| teltxt | varchar | Telefone |
| contato | varchar | Nome do contato |
| horario | varchar | Horário de atendimento |
| obs | varchar | Observações |

## ramos

74 linhas, 7 colunas. **Populada.**

Cadastro de ramos de seguro (tipos de produto).

| coluna | tipo | descrição PT |
|---|---|---|
| flgagen | INTEGER | Flag de agenciamento |
| cd_ramo | INTEGER | Código do ramo (PK) |
| ds_ramo | varchar | Descrição do ramo |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora de alteração |
| flgtipopagto | INTEGER | Flag de tipo de pagamento |
| periof | REAL | Periodicidade/fator |

## ramoatividade

1.312 linhas, 6 colunas. **Populada.**

Atividades vinculadas a um ramo, com vigência (relaciona ramo a tipo de atividade/risco).

| coluna | tipo | descrição PT |
|---|---|---|
| viginc | DateTime | Início de vigência |
| vigfnl | DateTime | Fim de vigência |
| cd_irb | varchar | Código IRB da companhia (FK -> seguradoras.cd_irb) |
| cd_ramo | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| codigo | INTEGER | Código da atividade |
| descricao | varchar | Descrição da atividade |

## ramo_susep

1.073 linhas, 6 colunas. **Populada.**

Mapeamento de ramo do SICS para código SUSEP, com comissão por cia.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_ramo | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| cd_susep | varchar | Código do ramo SUSEP |
| cd_comissao | INTEGER | Código de comissão |
| pc_comissao | REAL | Percentual de comissão |
| dt_flag_rede | DateTime | Marca de sincronização de rede |
| cd_irb | varchar | Código IRB da companhia (FK -> seguradoras.cd_irb) |

## ramo_susep_agenciamento

2 linhas, 36 colunas. **Populada.**

Percentuais de agenciamento por parcela (1 a 30) para combinação ramo/SUSEP/preposto.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_ramo | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| cd_susep | varchar | Código do ramo SUSEP |
| codigo | INTEGER | Código do agenciamento |
| codigo_preposto | INTEGER | Código do preposto |
| agendes | varchar | Descrição do agenciamento |
| per_parcela_1 | REAL | Percentual da parcela 1 |
| per_parcela_2 | REAL | Percentual da parcela 2 |
| per_parcela_3 | REAL | Percentual da parcela 3 |
| per_parcela_4 | REAL | Percentual da parcela 4 |
| per_parcela_5 | REAL | Percentual da parcela 5 |
| per_parcela_6 | REAL | Percentual da parcela 6 |
| per_parcela_7 | REAL | Percentual da parcela 7 |
| per_parcela_8 | REAL | Percentual da parcela 8 |
| per_parcela_9 | REAL | Percentual da parcela 9 |
| per_parcela_10 | REAL | Percentual da parcela 10 |
| cd_irb | varchar | Código IRB da companhia (FK -> seguradoras.cd_irb) |
| per_parcela_11 | REAL | Percentual da parcela 11 |
| per_parcela_12 | REAL | Percentual da parcela 12 |
| per_parcela_13 | REAL | Percentual da parcela 13 |
| per_parcela_14 | REAL | Percentual da parcela 14 |
| per_parcela_15 | REAL | Percentual da parcela 15 |
| per_parcela_16 | REAL | Percentual da parcela 16 |
| per_parcela_17 | REAL | Percentual da parcela 17 |
| per_parcela_18 | REAL | Percentual da parcela 18 |
| per_parcela_19 | REAL | Percentual da parcela 19 |
| per_parcela_20 | REAL | Percentual da parcela 20 |
| per_parcela_21 | REAL | Percentual da parcela 21 |
| per_parcela_22 | REAL | Percentual da parcela 22 |
| per_parcela_23 | REAL | Percentual da parcela 23 |
| per_parcela_24 | REAL | Percentual da parcela 24 |
| per_parcela_25 | REAL | Percentual da parcela 25 |
| per_parcela_26 | REAL | Percentual da parcela 26 |
| per_parcela_27 | REAL | Percentual da parcela 27 |
| per_parcela_28 | REAL | Percentual da parcela 28 |
| per_parcela_29 | REAL | Percentual da parcela 29 |
| per_parcela_30 | REAL | Percentual da parcela 30 |

## RAMO_SUB_SUSEP

0 linhas, 4 colunas. **VAZIA.**

Associação de ramo a subgrupo SUSEP com percentual de comissão.

| coluna | tipo | descrição PT |
|---|---|---|
| CD_SUSEP | varchar | Código do ramo SUSEP |
| SUBSUSEP | varchar | Subgrupo SUSEP |
| CD_RAMO | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| PC_COMISSOES | REAL | Percentual de comissões |

## sub_susep

0 linhas, 13 colunas. **VAZIA.**

Subgrupos SUSEP por ramo/empresa com vigência, região e percentuais.

| coluna | tipo | descrição PT |
|---|---|---|
| cd_ramo | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| emp_cod | varchar | Código da empresa/cia |
| emp_nom | varchar | Nome da empresa/cia |
| viginc | DateTime | Início de vigência |
| vigfnl | DateTime | Fim de vigência |
| prdt_cod | INTEGER | Código do produto |
| iniregcod | INTEGER | Código da região inicial |
| fnlregcod | INTEGER | Código da região final |
| ctgcod | INTEGER | Código da categoria |
| cobramcod | INTEGER | Código da cobertura/ramo |
| cobcod | varchar | Código de cobertura |
| dscper | REAL | Percentual de desconto |
| comssper | REAL | Percentual de comissão |

## suseps

15 linhas, 15 colunas. **Populada.**

Cadastro das corretoras/registros SUSEP do escritório (corretores).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_susep | varchar | Código SUSEP da corretora (PK) |
| nm_corretora | varchar | Nome da corretora/corretor |
| ds_endereco | varchar | Endereço |
| ds_bairro | varchar | Bairro |
| ds_cidade | varchar | Cidade |
| sg_estado | varchar | UF |
| cd_cep | varchar | CEP |
| cd_telefone_corretora | varchar | Telefone da corretora |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora de alteração |
| dt_flag_rede | DateTime | Marca de sincronização de rede |
| flgco_corretagem | INTEGER | Flag de co-corretagem |
| vlrco_cocorretagem | REAL | Valor/percentual de co-corretagem |
| repassecia | REAL | Percentual de repasse à cia |
| cd_irb | varchar | Código IRB da companhia (FK -> seguradoras.cd_irb) |

## cadsusep

0 linhas, 13 colunas. **VAZIA.**

Cadastro/credenciais SUSEP para integração (chave, e-mail, vigência, cias habilitadas).

| coluna | tipo | descrição PT |
|---|---|---|
| susep | varchar | Código SUSEP |
| ds_chave | varchar | Chave de acesso |
| ds_email | varchar | E-mail |
| ds_corretor | varchar | Nome do corretor |
| ds_corretora | varchar | Nome da corretora |
| ds_instrutor | varchar | Nome do instrutor |
| ds_produtor | varchar | Nome do produtor |
| ds_versao | varchar | Versão |
| cd_status | INTEGER | Código de status |
| dt_vigini | DateTime | Início de vigência |
| dt_vigfim | DateTime | Fim de vigência |
| fl_aceita | varchar | Flag de aceite |
| ds_cias | varchar | Companhias habilitadas |

## cadgerais

2.656 linhas, 5 colunas. **Populada.**

Tabela genérica de parâmetros/listas de domínio (chave-valor), ex.: profissões, coberturas.

| coluna | tipo | descrição PT |
|---|---|---|
| cadgeraischv | varchar | Chave do grupo de parâmetro (ex.: PROFISSOES) |
| cadgeraisvlr | REAL | Valor numérico |
| cadgeraisstr | varchar | Valor texto/descrição |
| cadgeraisatrb | INTEGER | Atributo auxiliar |
| cobstr | varchar | Texto de cobertura |

## cadestat

119 linhas, 3 colunas. **Populada.**

Estatísticas mensais (contadores por chave e ano/mês).

| coluna | tipo | descrição PT |
|---|---|---|
| anomes | INTEGER | Ano e mês (AAAAMM) |
| cadgeraischv | varchar | Chave da estatística (FK lógica -> cadgerais.cadgeraischv) |
| cadgeraisvlr | REAL | Valor/contador |

## cadlayoutcias

660 linhas, 15 colunas. **Populada.**

Definição de layout dos arquivos importados das companhias (posições, tamanhos, de/para de campos).

| coluna | tipo | descrição PT |
|---|---|---|
| cd_cia | varchar | Código da companhia (FK -> seguradoras.cd_irb) |
| tipoarquivo | INTEGER | Tipo de arquivo |
| cd_ramo | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| tipocarga | INTEGER | Tipo de carga |
| tiporeg | INTEGER | Tipo de registro |
| nomecampo | INTEGER | Identificador do campo |
| tipovariavel | INTEGER | Tipo da variável |
| tipocad | INTEGER | Tipo de cadastro |
| cd_inicio | INTEGER | Posição inicial no arquivo |
| cd_tamanho | INTEGER | Tamanho do campo |
| decimais | INTEGER | Casas decimais |
| numtagpcp | INTEGER | Número da tag PCP |
| numtagsub | INTEGER | Número da subtag |
| numtagsubnom | varchar | Nome da subtag |
| deparacampos | varchar | Mapeamento de/para de campos |

## cadbancos

0 linhas, 2 colunas. **VAZIA.**

Cadastro de bancos (código/descrição).

| coluna | tipo | descrição PT |
|---|---|---|
| bconum | INTEGER | Código do banco (PK) |
| bcodes | varchar | Descrição do banco |

## ArquivoCia

7 linhas, 5 colunas. **Populada.**

Registro de arquivos baixados das companhias (cobrança/retorno) por SUSEP.

| coluna | tipo | descrição PT |
|---|---|---|
| codigo | REAL | Código do arquivo (PK) |
| arquivo | varchar | Nome do arquivo |
| DataDownload | DateTime | Data/hora do download |
| susep | varchar | Código SUSEP (FK -> suseps.cd_susep) |
| produto | varchar | Tipo/produto do arquivo (ex.: Cobranca) |

## pdfcia

0 linhas, 14 colunas. **VAZIA.**

Controle de PDFs de apólices/endossos das companhias.

| coluna | tipo | descrição PT |
|---|---|---|
| ciairb | varchar | Código IRB da companhia (FK -> seguradoras.cd_irb) |
| ramo | INTEGER | Código do ramo (FK -> ramos.cd_ramo) |
| sucursal | INTEGER | Sucursal |
| apolice | REAL | Número da apólice |
| endosso | REAL | Número do endosso |
| item | INTEGER | Item |
| dtemissao | DateTime | Data de emissão |
| vigini | DateTime | Início de vigência |
| segurado | varchar | Nome do segurado |
| dtbaixa | DateTime | Data de baixa |
| flgbaixa | INTEGER | Flag de baixa |
| paramentros | TEXT | Parâmetros (texto) |
| arquivo | varchar | Nome do arquivo PDF |
| flgstt | INTEGER | Flag de status |

## placa_uf

42 linhas, 8 colunas. **Populada.**

Faixas de placas por UF (de/para de identificação de estado pela placa).

| coluna | tipo | descrição PT |
|---|---|---|
| uf | varchar | UF (sigla do estado) |
| placa_ini | varchar | Placa inicial da faixa |
| placa_fim | varchar | Placa final da faixa |
| flg_ativo | varchar | Flag de ativo (S/N) |
| dt_vigencia | DateTime | Data de vigência |
| nr_ini | REAL | Número inicial da faixa |
| nr_fim | REAL | Número final da faixa |
| obs | varchar | Observação (nome do estado) |

## licenciamento_uf

4.040 linhas, 9 colunas. **Populada.**

Mês de licenciamento por UF / final de placa / categoria.

| coluna | tipo | descrição PT |
|---|---|---|
| uf | varchar | UF (sigla do estado) |
| cd_ano | REAL | Ano |
| cd_mes | REAL | Mês |
| id_placa | REAL | Final de placa |
| cd_categoria | REAL | Categoria do veículo |
| flg_ativo | varchar | Flag de ativo (S/N) |
| dt_inicio | DateTime | Data de início |
| dt_termino | DateTime | Data de término |
| obs | varchar | Observação |

## deparacid

0 linhas, 5 colunas. **VAZIA.**

De/para de códigos de cidade entre ramo/modelo (conversão de códigos).

| coluna | tipo | descrição PT |
|---|---|---|
| ramcod | INTEGER | Código do ramo |
| rmemdlcod | INTEGER | Código do modelo do ramo |
| georegcod | INTEGER | Código da região geográfica |
| cidcodn | INTEGER | Código de cidade (novo/numérico) |
| cidcodv | INTEGER | Código de cidade (antigo/vinculado) |

## Empresa

0 linhas, 25 colunas. **VAZIA.**

Cadastro da empresa/licença do próprio escritório (dados de contrato, SUSEP principal, status, recursos contratados).

| coluna | tipo | descrição PT |
|---|---|---|
| Codigo | INTEGER | Código da empresa (PK) |
| Nome | varchar | Nome |
| CNPJ | varchar | CNPJ |
| TipoPessoa | varchar | Tipo de pessoa (F/J) |
| contato | varchar | Contato |
| Endereco | varchar | Endereço |
| Telefone | varchar | Telefone |
| FormaPagamento | varchar | Forma de pagamento |
| susepprincipal | varchar | SUSEP principal (FK lógica -> suseps.cd_susep) |
| suseppfavorecida | varchar | SUSEP favorecida |
| datapagto | DateTime | Data de pagamento |
| DiaPagto | INTEGER | Dia de pagamento |
| VigenciaInicial | DateTime | Início de vigência do contrato |
| VigenciaFinal | DateTime | Fim de vigência do contrato |
| EmpresaGUID | varchar | GUID da empresa |
| hash | varchar | Hash |
| UserSimultaneo | INTEGER | Usuários simultâneos permitidos |
| StatusCliente | varchar | Status do cliente |
| TemSMS | INTEGER | Flag de recurso SMS |
| TemRobo | INTEGER | Flag de recurso robô |
| codigosc | INTEGER | Código (SC) |
| guidsc | varchar | GUID (SC) |
| usersc | varchar | Usuário (SC) |
| liberarRel | INTEGER | Flag de liberação de relatórios |
| produto | INTEGER | Código do produto/plano |

---

## Relacionamentos

- **seguradoras (cd_irb)** é a chave central das companhias. Referenciada por:
  - `deptos_cia.cd_irb`
  - `ciaveiculos.vclcia` (código da tabela de veículos = cia)
  - `ramoatividade.cd_irb`, `ramo_susep.cd_irb`, `ramo_susep_agenciamento.cd_irb`
  - `suseps.cd_irb` (cia padrão da corretora)
  - `cadlayoutcias.cd_cia`, `pdfcia.ciairb`
- **ciaveiculos (vclcia, vclcod)** -> detalhada por **ciaveiculosfab (vclcia, vclcod)** por ano-modelo. Ambas tipo FIPE.
- **ramos (cd_ramo)** é a chave dos ramos de seguro. Referenciada por:
  - `ramoatividade.cd_ramo`, `ramo_susep.cd_ramo`, `ramo_susep_agenciamento.cd_ramo`
  - `RAMO_SUB_SUSEP.CD_RAMO`, `sub_susep.cd_ramo`, `cadlayoutcias.cd_ramo`, `pdfcia.ramo`
- **ramo_susep / RAMO_SUB_SUSEP / sub_susep** ligam o ramo interno à classificação **SUSEP** (`cd_susep` / `SUBSUSEP`) e definem comissões.
- **suseps (cd_susep)** identifica a corretora SICS. Referenciada por:
  - `ArquivoCia.susep` (arquivos baixados por SUSEP)
  - `Empresa.susepprincipal` / `suseppfavorecida` (FK lógica)
  - `cadsusep.susep` (credenciais de integração; vazia)
- **cadgerais (cadgeraischv)** fornece domínios; `cadestat.cadgeraischv` referencia essas chaves para estatísticas mensais.
- **placa_uf / licenciamento_uf / deparacid** são tabelas de apoio a veículos/UF (identificação de estado por placa, mês de licenciamento e de/para de cidades).
- **modelo_veiculo**, **cadbancos**, **deparacid**, **pdfcia**, **cadsusep**, **sub_susep**, **RAMO_SUB_SUSEP**, **Empresa** estão **vazias** no dump atual.

> Observação: o esquema SQLite legado não declara PKs/FKs físicas; os relacionamentos acima são lógicos, inferidos por convenção de nomes (cd_irb, cd_ramo, cd_susep, vclcia/vclcod).
