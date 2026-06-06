# Modelagem de dados — Clientes e pessoas

Este documento descreve as tabelas do SICS relacionadas ao cadastro de **clientes e pessoas** da corretora. O núcleo é a tabela `clientes`, identificada por `cd_cliente`, que concentra dados cadastrais de pessoas físicas e jurídicas (segurados, proponentes e contatos). Em torno dela orbitam tabelas satélite que detalham endereços (`enderecos`, `cliente_end_cobranca`), telefones (`telefones`), contas bancárias (`clientes_bancos`), imagens/documentos digitalizados (`cliente_imagem`), vínculos familiares (`clientes_parentes`), histórico de atendimento (`clientes_historico`), além de estruturas auxiliares de proposta (`proponente`), detecção de duplicidade (`clientes_parecidos`) e integração externa (`clientes_supersics`). Todas se ligam à entidade central por `cd_cliente`, e por sua vez `clientes` é referenciada pelas apólices em `seguros`. Os tipos vêm do banco Access original (`REAL`, `INTEGER`, `varchar`, `DateTime`, `TEXT`); muitos `cd_*`/`flg*` são na prática chaves ou flags inteiras armazenadas como `REAL`.

## clientes

665 linhas, 53 colunas. Tabela central de cadastro de pessoas (físicas e jurídicas): dados de identificação, documentos, contato, endereço principal e atributos comerciais/regulatórios.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| email | varchar | E-mail principal do cliente |
| religiao | varchar | Religião (campo cadastral livre) |
| cd_cliente | REAL | **PK** — código identificador do cliente |
| nm_cliente | varchar | Nome / razão social |
| cd_cgc_cpf | varchar | CPF (pessoa física) ou CNPJ/CGC (pessoa jurídica) |
| ds_endereco | varchar | Logradouro do endereço principal |
| sg_estado | varchar | Sigla da UF |
| cd_cep | varchar | CEP |
| cd_telefone_1 | varchar | Telefone 1 |
| cd_fax | varchar | Fax |
| dt_nascimento | DateTime | Data de nascimento (ou fundação) |
| sg_sexo | varchar | Sexo (M/F) |
| fl_pessoa | varchar | Tipo de pessoa (física/jurídica) |
| sg_estado_civil | varchar | Estado civil |
| ds_profissao | varchar | Profissão |
| dh_inclusao | DateTime | Data/hora de inclusão do registro |
| dh_alteracao | DateTime | Data/hora da última alteração |
| tx_observacao | TEXT | Observações livres |
| dt_flag_rede | DateTime | Marca de sincronização/replicação em rede |
| dt_venc_cnh | DateTime | Data de vencimento da CNH |
| cd_rg | varchar | Número do RG |
| cd_cartao | varchar | Número de cartão (cobrança) |
| cd_cartao_venci | DateTime | Vencimento do cartão |
| cd_telefone_2 | varchar | Telefone 2 |
| cd_telefone_3 | varchar | Telefone 3 |
| sgrnumdig | REAL | Dígito/sequencial do RG |
| cd_telefone_4 | varchar | Telefone 4 |
| FLGEMAIL | INTEGER | Flag de e-mail (envio/validade) |
| cnhnum | varchar | Número da CNH |
| flgcnhnum | INTEGER | Flag indicativo de CNH cadastrada |
| flgmigrar | INTEGER | Flag de migração de dados |
| cnhctg | varchar | Categoria da CNH |
| contato | varchar | Nome da pessoa de contato |
| tipdoc | INTEGER | Tipo de documento de identificação |
| orgexp | varchar | Órgão expedidor do documento |
| dtaexp | DateTime | Data de expedição do documento |
| codatvprof | REAL | Código da atividade profissional |
| codatvemp | REAL | Código da atividade da empresa |
| codclicor | INTEGER | Código/flag de cliente do corretor |
| flgenvcartas | INTEGER | Flag de envio de cartas |
| flgagregado | INTEGER | Flag de cliente agregado (dependente) |
| salvlr | REAL | Valor do salário/renda |
| vinculo | varchar | Vínculo (empregatício/relacionamento) |
| ds_bairro | varchar | Bairro do endereço principal |
| ds_cidade | varchar | Cidade do endereço principal |
| flgenvioemail | INTEGER | Flag de autorização de envio de e-mail |
| faixa_renda | INTEGER | Faixa de renda |
| pespolexp | INTEGER | Flag de pessoa politicamente exposta (PEP) |
| nmpespolexp | varchar | Nome da pessoa politicamente exposta relacionada |
| resbr | varchar | Residente no Brasil (S/N) |
| flgalerta | INTEGER | Flag de alerta no cadastro |
| grrlpespol | INTEGER | Grau de relacionamento com a PEP |
| cpfpespolexp | varchar | CPF da pessoa politicamente exposta relacionada |

## enderecos

356 linhas, 25 colunas. Endereços adicionais do cliente (vários por cliente, controlados por `endfld`), com campos detalhados de logradouro e até cinco telefones por endereço.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| endfld | INTEGER | Folha/sequência do endereço (ordem do registro) |
| endlgdtip | varchar | Tipo de logradouro (Rua, Av., etc.) |
| endlgd | varchar | Nome do logradouro |
| endnum | REAL | Número |
| endcmp | varchar | Complemento |
| endufd | varchar | UF |
| endbrr | varchar | Bairro |
| endcid | varchar | Cidade |
| endcep | varchar | CEP |
| telddd1 | varchar | DDD do telefone 1 |
| teltxt1 | varchar | Número do telefone 1 |
| telddd2 | varchar | DDD do telefone 2 |
| teltxt2 | varchar | Número do telefone 2 |
| telddd3 | varchar | DDD do telefone 3 |
| teltxt3 | varchar | Número do telefone 3 |
| telddd4 | varchar | DDD do telefone 4 |
| teltxt4 | varchar | Número do telefone 4 |
| email | varchar | E-mail vinculado ao endereço |
| cd_fax | varchar | Número do fax |
| teltext4bip | varchar | Bip/pager associado ao telefone 4 |
| cd_faxddd | varchar | DDD do fax |
| telddd5 | varchar | DDD do telefone 5 |
| teltxt5 | varchar | Número do telefone 5 |
| empresa | varchar | Empresa/local do endereço |

## telefones

111 linhas, 7 colunas. Telefones do cliente normalizados em registros individuais, com tipo de cadastro e recado.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| tipcad | INTEGER | Tipo de cadastro do telefone |
| flgtip | INTEGER | Flag de tipo (residencial/comercial/celular) |
| dddnum | INTEGER | DDD |
| teltxt | varchar | Número do telefone |
| ramal | varchar | Ramal |
| recado | varchar | Observação/recado |

## cliente_end_cobranca

19 linhas, 15 colunas. Endereço específico de cobrança do cliente, distinto do endereço principal, com até quatro telefones e fax.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| ds_endereco | varchar | Logradouro de cobrança |
| sg_estado | varchar | UF |
| cd_cep | varchar | CEP |
| cd_telefone_1 | varchar | Telefone 1 |
| cd_telefone_2 | varchar | Telefone 2 |
| cd_telefone_3 | varchar | Telefone 3 |
| cd_telefone_4 | varchar | Telefone 4 |
| cd_fax | varchar | Fax |
| dh_inclusao | DateTime | Data/hora de inclusão |
| dh_alteracao | DateTime | Data/hora de alteração |
| dt_flag_rede | DateTime | Marca de sincronização em rede |
| flgmigrar | INTEGER | Flag de migração de dados |
| ds_bairro | varchar | Bairro |
| ds_cidade | varchar | Cidade |

## cliente_imagem

0 linhas, 6 colunas. Imagens/documentos digitalizados associados ao cliente (caminho de arquivo). Atualmente sem registros.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_imagem | REAL | **PK** — código da imagem |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| path_imagem | varchar | Caminho do arquivo de imagem |
| dt_imagem | DateTime | Data da imagem |
| ds_nome_imagem | varchar | Nome/descrição da imagem |
| path_original | varchar | Caminho do arquivo original |

## clientes_bancos

75 linhas, 5 colunas. Contas bancárias do cliente (uma ou mais por cliente, sequenciadas por `seqcod`).

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| seqcod | INTEGER | Sequencial da conta dentro do cliente |
| banco | REAL | Código do banco |
| agencia | varchar | Número da agência |
| ccorrente | varchar | Número da conta corrente |

## clientes_parentes

64 linhas, 3 colunas. Relação de parentesco/dependência entre clientes (auto-relacionamento de `clientes`).

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` (titular) |
| cd_cliente_parente | REAL | **FK** → `clientes.cd_cliente` (parente/dependente) |
| flgagregado | INTEGER | Flag indicando se o parente é agregado/dependente |

## clientes_parecidos

2 linhas, 2 colunas. Tabela auxiliar para detecção de clientes duplicados/semelhantes por nome.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| codigo | REAL | **FK** → `clientes.cd_cliente` (cliente candidato a duplicidade) |
| nome | varchar | Nome usado na comparação |

## clientes_historico

0 linhas, 7 colunas. Histórico de atendimento/anotações do cliente, com suporte a exclusão lógica. Atualmente sem registros.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| cd_seq | INTEGER | Sequencial do registro de histórico |
| dt_historico | DateTime | Data do histórico |
| ds_historico | TEXT | Descrição/anotação |
| ds_apolice | varchar | Apólice relacionada (referência a `seguros`) |
| flg_delete | INTEGER | Flag de exclusão lógica |
| log_delete | varchar | Registro de quem/quando excluiu |

## clientes_supersics

0 linhas, 10 colunas. Tabela de integração com o serviço externo "SuperSICS" (consulta/parcelamento por ramo), com mensagens de retorno e valores de parcela. Atualmente sem registros.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_cliente | REAL | **FK** → `clientes.cd_cliente` |
| cd_ramo | INTEGER | **FK** → ramo de seguro (referencia tabela de ramos) |
| dataems | DateTime | Data de emissão/consulta |
| rmemdlcod | INTEGER | Código de modalidade do ramo |
| sequencia | INTEGER | Sequencial do registro |
| retmsg | TEXT | Mensagem de retorno da integração |
| parprivlr | REAL | Valor da parcela (privada) |
| pardemvlr | REAL | Valor da parcela (demais) |
| jurvlr | REAL | Valor de juros |
| prodnom | varchar | Nome do produto |

## proponente

23 linhas, 16 colunas. Dados de proponente (candidato a segurado em proposta), incluindo informações financeiras e de PEP. Liga-se a `clientes` por `cd_cliente`.

| coluna | tipo | descrição inferida |
| --- | --- | --- |
| cd_proponente | INTEGER | **PK** — código do proponente |
| cd_cliente | INTEGER | **FK** → `clientes.cd_cliente` |
| nm_cliente | varchar | Nome / razão social do proponente |
| cd_cgc_cpf | varchar | CPF ou CNPJ/CGC |
| vl_prliq | REAL | Valor do prêmio líquido (ou patrimônio líquido) |
| vl_cap_circ_liq | REAL | Valor do capital circulante líquido |
| fl_pessoa | varchar | Tipo de pessoa (física/jurídica) |
| tp_proponente | varchar | Tipo de proponente |
| pespolexp | INTEGER | Flag de pessoa politicamente exposta (PEP) |
| nmpespolexp | varchar | Nome da PEP relacionada |
| existcontrol | varchar | Indica existência de controlador |
| tpempresa | INTEGER | Tipo de empresa |
| faixa_prliq | INTEGER | Faixa do prêmio/patrimônio líquido |
| faixa_cap_circ_liq | INTEGER | Faixa do capital circulante líquido |
| grrlpespol | INTEGER | Grau de relacionamento com a PEP |
| cpfpespolexp | varchar | CPF da PEP relacionada |

## Relacionamentos

- **`clientes` é a entidade central**, identificada por `cd_cliente`. Praticamente todas as demais tabelas deste contexto referenciam essa coluna como chave estrangeira.
- **Endereços e contatos (1:N):** `enderecos` (por `endfld`), `telefones` e `clientes_bancos` (por `seqcod`) guardam, cada uma, vários registros por cliente. `cliente_end_cobranca` armazena o endereço de cobrança específico, distinto do endereço principal embutido em `clientes`.
- **Documentos (1:N):** `cliente_imagem` liga imagens/documentos digitalizados ao cliente por `cd_cliente`.
- **Auto-relacionamento:** `clientes_parentes` conecta dois clientes (`cd_cliente` ↔ `cd_cliente_parente`), modelando parentesco e agregados/dependentes; o flag `flgagregado` também aparece em `clientes`.
- **Histórico e duplicidade:** `clientes_historico` registra anotações por cliente (e referencia apólices via `ds_apolice`); `clientes_parecidos` (`codigo` → `cd_cliente`) apoia a deduplicação por nome.
- **Proposta:** `proponente` representa o candidato a segurado na fase de proposta e aponta para `clientes` por `cd_cliente`, repetindo dados cadastrais e financeiros antes da emissão da apólice.
- **Integração externa:** `clientes_supersics` vincula o cliente (`cd_cliente`) a um ramo de seguro (`cd_ramo`) para consultas/parcelamentos no serviço SuperSICS.
- **Ligação com apólices (`seguros`):** a tabela `seguros` referencia `clientes.cd_cliente` como segurado/contratante (1 cliente : N apólices). Assim, o cadastro de pessoas deste contexto é o lado "pessoa" do relacionamento com apólices, sinistros e cobranças; `clientes_historico.ds_apolice` e `clientes_supersics.cd_ramo` fornecem amarrações adicionais a esse domínio.
