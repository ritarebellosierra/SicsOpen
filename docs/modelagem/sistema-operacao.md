# Modelagem SICS — Sistema, Operação, Agenda e Sinistros

## Visão geral

Este documento descreve as tabelas do sistema legado SICS (corretora de seguros,
originalmente em Microsoft Access) relacionadas a:

- **Controle de acesso e usuários**: `usuarios`, `usuario_aplicacao`, `snh`,
  `ControleLogin`.
- **Agenda e contatos**: `agenda`, `agendatel`, `cartacor`.
- **Configuração e operação do sistema**: `parametros`, `operacao`, `sequence`,
  `sqlbanco`, `gshkshop`, `supersicsestat`.
- **Sinistros**: `sinistros`, `sinistros_historico`.

Observações importantes sobre o modelo legado:

- O schema **não declara chaves primárias nem estrangeiras** (herança do
  Access/exportação para SQLite). As PKs/FKs abaixo são **inferidas** a partir
  dos nomes de colunas e do uso do sistema; estão marcadas como (PK inferida) /
  (FK inferida).
- A chave de negócio recorrente em apólices/sinistros é a tripla
  `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item`, que liga ao
  domínio de seguros (tabela `seguros` e correlatas).
- Tabelas vazias (0 linhas no inventário) neste conjunto:
  `usuario_aplicacao`, `parametros`, `sqlbanco`, `supersicsestat`,
  `ControleLogin`.

---

## usuarios

3 linhas, 15 colunas. **Não vazia.**

Propósito: cadastro dos operadores/funcionários da corretora e suas permissões
de acesso ao sistema. (Apenas a estrutura é descrita; senhas e valores reais não
são reproduzidos.)

| coluna | tipo | descrição PT |
|---|---|---|
| `id_usuario` | varchar | Identificador (login) do usuário (PK inferida) |
| `nm_usuario` | varchar | Nome do usuário |
| `ds_cargo` | varchar | Cargo/função |
| `cd_senha` | varchar | Senha do usuário (armazenada/codificada — não documentar valores) |
| `ds_departamento` | varchar | Departamento |
| `dt_validade` | DateTime | Data de validade do acesso/senha |
| `PROCESS` | INTEGER | Flag de processo/permissão de processamento |
| `RESTREL` | varchar | Restrição de relatórios (quais relatórios o usuário pode ver) |
| `RESTRELFLG` | INTEGER | Flag indicando se a restrição de relatórios está ativa |
| `restsusep` | TEXT | Restrição por SUSEP/corretora (quais SUSEPs o usuário acessa) |
| `restsusepflg` | INTEGER | Flag indicando se a restrição por SUSEP está ativa |
| `flgcorfinan` | INTEGER | Flag de acesso ao módulo financeiro |
| `flgapagar` | INTEGER | Flag de acesso a contas a pagar |
| `flgpreposto` | INTEGER | Flag: usuário é preposto |
| `email` | varchar | E-mail do usuário |

---

## usuario_aplicacao

0 linhas, 3 colunas. **Vazia.**

Propósito: associação entre usuário e aplicação/módulo, definindo o nível de
acesso por aplicação.

| coluna | tipo | descrição PT |
|---|---|---|
| `cd_aplicacao` | varchar | Código da aplicação/módulo (PK inferida composta) |
| `id_usuario` | varchar | Usuário (PK inferida composta; FK inferida → `usuarios.id_usuario`) |
| `cd_nivel_acesso` | INTEGER | Nível de acesso do usuário naquela aplicação |

---

## snh

7 linhas, 7 colunas. **Não vazia.**

Propósito: controle de senhas/versões do sistema (registro de senha por
sequência, versão e segurança). Apenas a estrutura é descrita; valores reais não
são reproduzidos.

| coluna | tipo | descrição PT |
|---|---|---|
| `numseq` | INTEGER | Número de sequência do registro (PK inferida) |
| `dtsenha` | varchar | Data/identificação da senha |
| `snhnv` | varchar | Senha de nível/versão (não documentar valor) |
| `dtnv` | varchar | Data do nível/versão |
| `seg` | varchar | Segurança / código de segurança |
| `numver` | varchar | Número da versão |
| `verg` | varchar | Verificação/validação da versão |

---

## ControleLogin

0 linhas, 4 colunas. **Vazia.**

Propósito: registro de sessões de login (controle de quem está conectado),
identificado por processo e GUID, com horários de entrada e saída.

| coluna | tipo | descrição PT |
|---|---|---|
| `ControleLoginPid` | INTEGER | PID do processo da sessão (PK inferida) |
| `ControleLoginGUID` | varchar | GUID da sessão |
| `ControleLoginDataHoraIn` | DateTime | Data/hora de entrada (login) |
| `ControleLoginDataHoraOut` | DateTime | Data/hora de saída (logout) |

---

## agenda

297 linhas, 24 colunas. **Não vazia.**

Propósito: agenda de compromissos/lembretes por usuário (eventos, alarmes,
vencimentos, endereços do compromisso).

| coluna | tipo | descrição PT |
|---|---|---|
| `usuario` | INTEGER | Usuário dono do compromisso (FK inferida → `usuarios`) |
| `tipo` | INTEGER | Tipo de compromisso |
| `dtagenda` | DateTime | Data do compromisso |
| `seq` | INTEGER | Sequência do compromisso na data (PK inferida com `usuario`/`dtagenda`) |
| `hora` | varchar | Hora do compromisso |
| `alarme` | INTEGER | Flag de alarme ativo |
| `titulo` | varchar | Título do compromisso |
| `descom` | TEXT | Descrição/observações |
| `vctman` | INTEGER | Flag de vencimento manual |
| `vctok` | INTEGER | Flag de vencimento confirmado/baixado |
| `horalrm` | varchar | Hora do alarme |
| `minutos` | INTEGER | Antecedência do alarme (minutos) |
| `dtvigencia` | DateTime | Data de vigência |
| `FLGSTT` | INTEGER | Flag de status |
| `DS_DEL` | varchar | Marcação/usuário de exclusão |
| `DT_DEL` | DateTime | Data de exclusão |
| `DS_ENDERECO` | varchar | Endereço do compromisso |
| `DS_COMPLE` | varchar | Complemento do endereço |
| `DS_BAIRRO` | varchar | Bairro |
| `FLGTIPOHORA` | INTEGER | Flag do tipo de hora |
| `DS_GRUPO` | varchar | Grupo/categoria do compromisso |
| `DH_INCLUSAO` | DateTime | Data/hora de inclusão |
| `DS_CADASTRO` | varchar | Usuário que cadastrou |
| `email` | varchar | E-mail associado ao compromisso |

---

## agendatel

6 linhas, 6 colunas. **Não vazia.**

Propósito: agenda telefônica/de contatos por usuário.

| coluna | tipo | descrição PT |
|---|---|---|
| `usuario` | INTEGER | Usuário dono do contato (FK inferida → `usuarios`) |
| `codigo` | INTEGER | Código do contato (PK inferida com `usuario`) |
| `nome` | varchar | Nome do contato |
| `teltxt` | varchar | Telefone |
| `faxtxt` | varchar | Fax |
| `email` | varchar | E-mail do contato |

---

## cartacor

15 linhas, 6 colunas. **Não vazia.**

Propósito: modelos de cartas/correspondência (textos padrão usados em
comunicações, ex.: e-mails e cartas ao cliente).

| coluna | tipo | descrição PT |
|---|---|---|
| `cartanum` | INTEGER | Número do modelo de carta (PK inferida) |
| `cartanom` | varchar | Nome do modelo de carta |
| `dt_atuali` | DateTime | Data da última atualização |
| `cartatext` | TEXT | Texto da carta |
| `cartatext2` | BLOB | Texto/conteúdo formatado da carta (binário) |
| `flgcartemail` | INTEGER | Flag: modelo destinado a e-mail |

---

## parametros

0 linhas, 2 colunas. **Vazia.**

Propósito: parâmetros gerais/controle de sincronização do sistema.

| coluna | tipo | descrição PT |
|---|---|---|
| `cd_lixo` | INTEGER | Código de controle (lixo/placeholder) |
| `dt_flag_rede` | DateTime | Data/hora de flag de sincronização em rede |

---

## operacao

2323 linhas, 6 colunas. **Não vazia.**

Propósito: tabela de operações por ramo/modalidade, definindo percentuais de
comissão e fatores aplicáveis (parametrização comercial).

| coluna | tipo | descrição PT |
|---|---|---|
| `cd_ramo` | INTEGER | Código do ramo de seguro (PK inferida composta) |
| `cod_opr` | INTEGER | Código da operação (PK inferida composta) |
| `modalidade` | INTEGER | Modalidade da operação (PK inferida composta) |
| `pc_comissao` | REAL | Percentual de comissão |
| `dt_inclusao` | DateTime | Data de inclusão |
| `pc_fator` | REAL | Percentual de fator aplicado |

---

## sequence

5 linhas, 3 colunas. **Não vazia.**

Propósito: gerador de sequências (próximo valor por tabela) — emula
auto-incremento controlado por aplicação.

| coluna | tipo | descrição PT |
|---|---|---|
| `nm_tabela` | varchar | Nome da tabela/sequência (PK inferida) |
| `nextval` | REAL | Próximo valor a ser usado |
| `dt_flag_rede` | DateTime | Data/hora de flag de sincronização em rede |

---

## sqlbanco

0 linhas, 2 colunas. **Vazia.**

Propósito: armazenamento de comandos SQL (scripts/atualizações de banco a serem
executados, identificados por número).

| coluna | tipo | descrição PT |
|---|---|---|
| `NROSQL` | REAL | Número do comando SQL (PK inferida) |
| `COMANDOSQL` | TEXT | Texto do comando SQL |

---

## gshkshop

869 linhas, 5 colunas. **Não vazia.**

Propósito: cadastro de shoppings/lojas (tabela auxiliar de localização,
vinculada a UF e cidade).

| coluna | tipo | descrição PT |
|---|---|---|
| `shpcod` | INTEGER | Código do shopping/loja (PK inferida) |
| `shpnom` | varchar | Nome do shopping/loja |
| `shpsgl` | varchar | Sigla |
| `ufdcod` | varchar | Código da UF (FK inferida → cadastro de UF) |
| `cidcod` | INTEGER | Código da cidade (FK inferida → cadastro de cidades) |

---

## supersicsestat

0 linhas, 16 colunas. **Vazia.**

Propósito: tabela de estatística/integração "SuperSICS" — consolida dados de
cálculo/emissão por cliente e proposta (apoio a relatórios/integração).

| coluna | tipo | descrição PT |
|---|---|---|
| `cd_cliente` | REAL | Código do cliente (FK inferida → `clientes`) |
| `nm_cliente` | varchar | Nome do cliente |
| `cd_ramo` | INTEGER | Código do ramo de seguro |
| `cd_mdlcod` | INTEGER | Código de modelo/modalidade |
| `cd_edstip` | INTEGER | Tipo de endosso |
| `dt_clc` | DateTime | Data de cálculo |
| `dt_ret` | DateTime | Data de retorno |
| `tipoclc` | INTEGER | Tipo de cálculo |
| `cd_ciaant` | varchar | Código da companhia anterior |
| `dtemsapl` | DateTime | Data de emissão da apólice |
| `dtpgtcoms` | DateTime | Data de pagamento de comissão |
| `cd_proposta_ppw` | REAL | Código da proposta (sistema PPW) |
| `dttrx` | DateTime | Data da transação |
| `cgccpf` | varchar | CNPJ/CPF do cliente |
| `cd_controle_proposta` | REAL | Controle da proposta (FK inferida → `seguros`) |
| `cd_sequencia_endosso` | REAL | Sequência do endosso (FK inferida → `seguros`) |

---

## sinistros

43 linhas, 58 colunas. **Não vazia.**

Propósito: registro de sinistros (avisos, ocorrências, vistorias, indenizações)
ligados a uma apólice/item de seguro. As colunas de coberturas (incêndio, roubo,
RCF, etc.) marcam quais coberturas foram acionadas no sinistro.

| coluna | tipo | descrição PT |
|---|---|---|
| `cd_controle_proposta` | REAL | Controle da proposta/apólice (PK e FK inferida → `seguros`) |
| `cd_sequencia_endosso` | INTEGER | Sequência do endosso (PK e FK inferida → `seguros`) |
| `cd_item` | INTEGER | Item da apólice (PK e FK inferida → `seguros`) |
| `cd_sinistro` | varchar | Código do sinistro (PK inferida) |
| `dt_ocorrencia` | DateTime | Data da ocorrência |
| `dt_vistoria` | DateTime | Data da vistoria |
| `dt_indenizacao` | DateTime | Data da indenização |
| `vl_sinistro` | REAL | Valor do sinistro |
| `vl_indenizado` | REAL | Valor indenizado |
| `vl_franquia` | REAL | Valor da franquia |
| `ds_oficina` | varchar | Nome da oficina |
| `ds_endereco_oficina` | varchar | Endereço da oficina |
| `cd_telefone_oficina` | varchar | Telefone da oficina |
| `nm_contato_oficina` | varchar | Contato na oficina |
| `ds_historico` | TEXT | Histórico/descrição do sinistro |
| `fl_tipo_sinistro` | varchar | Tipo de sinistro |
| `fl_colisao` | varchar | Flag: colisão |
| `fl_terceiros` | varchar | Flag: envolvimento de terceiros |
| `fl_furto` | varchar | Flag: furto |
| `fl_toca_fitas` | varchar | Flag: toca-fitas/áudio |
| `dh_inclusao` | DateTime | Data/hora de inclusão |
| `dh_alteracao` | DateTime | Data/hora de alteração |
| `dt_flag_rede` | DateTime | Data/hora de flag de sincronização em rede |
| `cd_ramo` | INTEGER | Código do ramo de seguro |
| `incendio` | INTEGER | Cobertura acionada: incêndio |
| `danos_eletricos` | INTEGER | Cobertura acionada: danos elétricos |
| `imp_veiculos` | INTEGER | Cobertura acionada: impacto de veículos |
| `vendaval` | INTEGER | Cobertura acionada: vendaval |
| `despesas_fixas` | INTEGER | Cobertura acionada: despesas fixas |
| `pgto_aluguel` | INTEGER | Cobertura acionada: pagamento de aluguel |
| `tumulto` | INTEGER | Cobertura acionada: tumulto |
| `roubo_bens` | INTEGER | Cobertura acionada: roubo de bens |
| `roubo_vlr` | INTEGER | Cobertura acionada: roubo de valores |
| `rcf` | INTEGER | Cobertura acionada: RCF (responsabilidade civil facultativa) |
| `vidros` | INTEGER | Cobertura acionada: vidros |
| `sub_bens_comuns` | INTEGER | Cobertura acionada: subtração de bens comuns |
| `sub_bens_especiais` | INTEGER | Cobertura acionada: subtração de bens especiais |
| `rc_condominio` | INTEGER | Cobertura acionada: RC condomínio |
| `rc_sindico` | INTEGER | Cobertura acionada: RC síndico |
| `rc_veic_simples` | INTEGER | Cobertura acionada: RC veículos simples |
| `rc_veic_ampla` | INTEGER | Cobertura acionada: RC veículos ampla |
| `vida` | INTEGER | Cobertura acionada: vida |
| `documento` | REAL | Documento associado |
| `sem_franquia` | REAL | Flag: sem franquia |
| `acidente` | INTEGER | Cobertura acionada: acidente |
| `doenca` | INTEGER | Cobertura acionada: doença |
| `tipo_documento` | INTEGER | Tipo de documento |
| `vstnum` | varchar | Número da vistoria |
| `numaviso` | varchar | Número do aviso de sinistro |
| `anoaviso` | varchar | Ano do aviso de sinistro |
| `dt_aviso` | DateTime | Data do aviso de sinistro |
| `vl_avarias` | REAL | Valor das avarias |
| `vl_sinistro_aprovado` | REAL | Valor de sinistro aprovado |
| `flg_status_vistoria` | varchar | Status da vistoria |
| `nompatio` | varchar | Nome do pátio |
| `flgdoc` | INTEGER | Flag de documentação |
| `flgmigrar` | INTEGER | Flag de migração |
| `codoficina` | INTEGER | Código da oficina (FK inferida → `cadoficinas`) |

---

## sinistros_historico

7 linhas, 8 colunas. **Não vazia.**

Propósito: histórico de andamento/eventos de cada sinistro (registros de
acompanhamento ao longo do tempo).

| coluna | tipo | descrição PT |
|---|---|---|
| `cd_controle_proposta` | REAL | Controle da proposta/apólice (PK e FK inferida → `sinistros`) |
| `cd_sequencia_endosso` | INTEGER | Sequência do endosso (PK e FK inferida → `sinistros`) |
| `cd_item` | INTEGER | Item da apólice (PK e FK inferida → `sinistros`) |
| `cd_sinistro` | varchar | Código do sinistro (PK e FK inferida → `sinistros`) |
| `cd_tipo` | INTEGER | Tipo de evento/histórico |
| `cd_seq` | INTEGER | Sequência do registro de histórico (PK inferida) |
| `dt_historico` | DateTime | Data do registro de histórico |
| `ds_historico` | TEXT | Descrição do evento |

---

## Relacionamentos

Relacionamentos inferidos (o schema legado não declara FKs):

### Sinistros → Seguros

- `sinistros` (`cd_controle_proposta`, `cd_sequencia_endosso`, `cd_item`) →
  `seguros` (mesma tripla): cada sinistro pertence a uma apólice/item de seguro.
- `sinistros.codoficina` → `cadoficinas.codigo`: oficina responsável pelo
  conserto.
- `sinistros_historico` (`cd_controle_proposta`, `cd_sequencia_endosso`,
  `cd_item`, `cd_sinistro`) → `sinistros` (mesma chave + `cd_sinistro`):
  cada linha de histórico pertence a um sinistro (relação 1:N).
- `supersicsestat` (`cd_controle_proposta`, `cd_sequencia_endosso`) →
  `seguros`: consolidação estatística por apólice.

### Usuários → Controle de acesso

- `usuario_aplicacao.id_usuario` → `usuarios.id_usuario`: permissões por
  aplicação/módulo (relação 1:N — um usuário tem vários níveis por aplicação).
- `usuarios` referencia indiretamente restrições de domínio:
  `RESTREL`/`RESTRELFLG` (relatórios permitidos) e `restsusep`/`restsusepflg`
  (SUSEPs/corretoras permitidas) restringem o que cada usuário enxerga.
- `ControleLogin`: registra as sessões ativas; não há FK direta para `usuarios`
  no schema (a sessão é identificada por PID/GUID), porém representa o controle
  de presença/login dos usuários.
- `snh`: controle de senhas/versões do sistema, complementar ao login (não há FK
  declarada para `usuarios`).

### Agenda → Usuários

- `agenda.usuario` → `usuarios`: compromissos pertencem a um usuário.
- `agendatel.usuario` → `usuarios`: contatos telefônicos pertencem a um usuário.

### Operação / parametrização

- `operacao` (`cd_ramo`, `cod_opr`, `modalidade`): parametriza comissão/fator por
  ramo e modalidade, consumido pelo módulo comercial/de seguros.
- `sequence`: provê o próximo valor de chave para diversas tabelas (geração de
  códigos).
- `gshkshop` (`ufdcod`, `cidcod`): cadastro auxiliar de localização (UF/cidade).
