# Modelagem — Vida e Saúde (versão posterior)

> ⚠️ **AVISO — NÃO USADO / VERSÃO POSTERIOR.** As tabelas de **Vida** e **Saúde**
> descritas abaixo estão praticamente **VAZIAS** no inventário do banco legado: quase
> todos os objetos têm 0 linhas (apenas `seguro_vida` tem 1 registro e o catálogo
> `questionario_vida` tem 15 linhas de domínio). A estrutura existe, mas o recurso é
> pouco ou nada utilizado. **Este documento fica reservado para uma versão posterior**
> do SicsOpen; o uso efetivo atual concentra-se nos Ramos Elementares (RE), descritos
> em `../ramos-elementares.md`.

## Visão geral

No SICS, a tabela núcleo `seguros` guarda os dados comuns a **qualquer** apólice/proposta
(cliente, seguradora, ramo, prêmio, endosso, vigência etc.), identificada pela chave
`cd_controle_proposta` + `cd_sequencia_endosso`.

As tabelas deste documento **estendem** `seguros` conforme o **ramo** do seguro,
acrescentando os campos específicos que `seguros` não comporta:

- **Vida:** `seguro_vida` e suas filhas (`seguro_vida_benef2`, `seguro_vida_cob2`,
  `seguro_vida_quest`), além do auxiliar `questionario_vida`.
- **Saúde:** `seguro_saude` e suas filhas (`seguro_saude_cob`, `seguro_saude_dep`).

O vínculo de **todas** elas com o núcleo é sempre o par
`cd_controle_proposta` + `cd_sequencia_endosso` (FK lógica → `seguros`).
Nas tabelas que detalham itens, acrescenta-se `cd_item` (e `cd_ramo`) para identificar
o item/risco dentro da apólice.

> Observação: o banco legado (Access) **não declara** PK/FK formalmente. As chaves
> abaixo são **inferidas** a partir dos nomes de coluna, cardinalidade e uso no SICS.

> Estado dos dados (inventário): vários objetos de Vida e Saúde estão **VAZIOS**
> (0 linhas) — a estrutura existe, mas o recurso é pouco ou nada utilizado. Indicado
> em cada seção.

---

## seguro_vida

- **Linhas:** 1 — **Colunas:** 71 — Praticamente vazia (1 registro).
- **Propósito inferido:** extensão de Vida de `seguros`. Dados do proponente principal,
  cônjuge e menor (data de nascimento, dados antropométricos/pressão), capitais por
  cobertura (morte natural, morte acidental, invalidez, DMH, DIT), além de
  estipulante/empresa e prêmios.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros** (parte 1 da chave da proposta) |
| cd_sequencia_endosso | INTEGER | **FK → seguros** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| estipulante | varchar | Estipulante |
| proponente | varchar | Nome do proponente/segurado principal |
| nasdat | DateTime | Data de nascimento do proponente |
| empresa | varchar | Empresa do proponente |
| admissao | DateTime | Data de admissão |
| salario | REAL | Salário |
| endereco | varchar | Endereço |
| cep | varchar | CEP |
| cidade | varchar | Cidade |
| principal_altura | REAL | Altura do segurado principal |
| principal_peso | INTEGER | Peso do segurado principal |
| principal_pressao_max | INTEGER | Pressão arterial máxima (principal) |
| principal_pressao_min | INTEGER | Pressão arterial mínima (principal) |
| principal_data | DateTime | Data da medição (principal) |
| nome_conjuge | varchar | Nome do cônjuge |
| conjuge_nasdat | DateTime | Data de nascimento do cônjuge |
| conjuge_altura | REAL | Altura do cônjuge |
| conjuge_peso | INTEGER | Peso do cônjuge |
| conjuge_pressao_max | INTEGER | Pressão máxima do cônjuge |
| conjuge_pressao_min | INTEGER | Pressão mínima do cônjuge |
| conjuge_data | DateTime | Data da medição (cônjuge) |
| beneficiarios | TEXT | Beneficiários (texto livre) |
| principal_mortenat | REAL | Capital morte natural (principal) |
| principal_morteaci | REAL | Capital morte acidental (principal) |
| principal_invalaci | REAL | Capital invalidez por acidente (principal) |
| principal_invaldoe | REAL | Capital invalidez por doença (principal) |
| principal_dmh | REAL | Capital despesas médico-hospitalares (principal) |
| principal_dit | REAL | Capital diária por incapacidade temporária (principal) |
| conjuge_mortenat | REAL | Capital morte natural (cônjuge) |
| conjuge_morteaci | REAL | Capital morte acidental (cônjuge) |
| conjuge_invalaci | REAL | Capital invalidez por acidente (cônjuge) |
| conjuge_invaldoe | REAL | Capital invalidez por doença (cônjuge) |
| conjuge_dmh | REAL | Capital DMH (cônjuge) |
| prm_mensal | REAL | Prêmio mensal |
| majoracao | INTEGER | Majoração |
| parto | INTEGER | Flag/cobertura parto |
| agendes | varchar | Agência/descrição |
| vlrparto | REAL | Valor da cobertura de parto |
| flgtmp | INTEGER | Flag de cobertura temporária |
| vlrtmp | REAL | Valor da cobertura temporária |
| capseg | INTEGER | Capital segurado |
| tipctr | INTEGER | Tipo de contrato |
| tipctrdados | REAL | Tipo de contrato (dados) |
| tipctrvidas | REAL | Tipo de contrato (vidas) |
| flgassfuneral | INTEGER | Flag de assistência funeral |
| vlrassfuneral | REAL | Valor da assistência funeral |
| vlrprm | REAL | Valor do prêmio |
| flgbenf | INTEGER | Flag: possui beneficiários (→ seguro_vida_benef2) |
| cpfnum | varchar | CPF do segurado |
| sexcod | varchar | Sexo |
| estcvlcod | INTEGER | Estado civil |
| status | varchar | Situação do registro |
| menor_mortenat | REAL | Capital morte natural (menor) |
| menor_morteaci | REAL | Capital morte acidental (menor) |
| menor_invalaci | REAL | Capital invalidez por acidente (menor) |
| menor_invaldoe | REAL | Capital invalidez por doença (menor) |
| menor_dmh | REAL | Capital DMH (menor) |
| flgassseg | INTEGER | Flag de assistência ao segurado |
| dt_demissao | DateTime | Data de demissão |
| flgvidtip | INTEGER | Flag de tipo de vida |
| vlr_iof | REAL | Valor de IOF |
| principal_can | REAL | Capital/valor (principal) — cancelamento/CAN |
| principal_maj | REAL | Majoração (principal) |
| flg_vidanova | INTEGER | Flag: produto Vida Nova |
| cd_rg | varchar | RG do segurado |
| orgexp | varchar | Órgão expedidor do RG |
| dtaexp | DateTime | Data de expedição do RG |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item`.

---

## seguro_vida_benef2

- **Linhas:** 0 — **Colunas:** 30 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** beneficiários do seguro de Vida (versão 2, normalizada), com
  dados pessoais, grau de parentesco, percentual e endereço. Ativada por `flgbenf`.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_vida** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_vida** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| cd_seq | INTEGER | Sequência do beneficiário |
| nomebenef | varchar | Nome do beneficiário |
| graubenef | INTEGER | Grau de parentesco |
| perbenef | REAL | Percentual de participação |
| cpfnum | varchar | CPF do beneficiário |
| dt_nasc | DateTime | Data de nascimento |
| sexcod | varchar | Sexo |
| estcvlcod | INTEGER | Estado civil |
| status | varchar | Situação do registro |
| flgimpcert | varchar | Flag de impressão de certificado |
| codatvprof | REAL | Código de atividade profissional |
| salvlr | REAL | Valor do salário |
| cd_rg | varchar | RG |
| orgexp | varchar | Órgão expedidor do RG |
| dtaexp | DateTime | Data de expedição do RG |
| finend | INTEGER | Finalidade do endereço |
| tplgd | varchar | Tipo de logradouro |
| desclgd | varchar | Descrição do logradouro |
| numlgd | INTEGER | Número |
| cmplgd | varchar | Complemento |
| brrlgd | varchar | Bairro |
| cidlgd | varchar | Cidade |
| uflgd | varchar | UF |
| ceplgd | varchar | CEP |
| telddd | varchar | DDD do telefone |
| telnum | varchar | Número do telefone |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `cd_seq`.

---

## seguro_vida_cob2

- **Linhas:** 0 — **Colunas:** 9 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** coberturas do seguro de Vida (versão 2, normalizada — uma
  linha por cobertura/plano).

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_vida** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_vida** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| tipseg | INTEGER | Tipo de segurado (principal/cônjuge/menor) |
| tipcob | INTEGER | Tipo de cobertura |
| plancod | INTEGER | Código do plano |
| vlrcob | REAL | Valor/capital da cobertura |
| flgassfuneral | INTEGER | Flag de assistência funeral |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `tipseg` + `tipcob`.

---

## seguro_vida_quest

- **Linhas:** 0 — **Colunas:** 8 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** respostas do questionário (declaração de saúde) do seguro de
  Vida, uma linha por questão. Usa o catálogo `questionario_vida`.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_vida** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_vida** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| tipseg | INTEGER | Tipo de segurado (a quem se refere a resposta) |
| questaocod | INTEGER | Código da questão (→ questionario_vida) |
| resp | varchar | Resposta |
| respcmp | varchar | Resposta complementar |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `tipseg` + `questaocod`.

---

## questionario_vida

- **Linhas:** 15 — **Colunas:** 4 — Em uso (tabela de domínio/catálogo).
- **Propósito inferido:** catálogo das perguntas do questionário de saúde de Vida,
  por cia/ramo. Referenciada por `seguro_vida_quest.questaocod`.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cia | varchar | Código da companhia/seguradora |
| ramo | INTEGER | Código do ramo |
| codigo | INTEGER | Código da questão (PK do catálogo) |
| descricao | varchar | Texto/descrição da pergunta |

PK inferida: `cia` + `ramo` + `codigo`. Não se vincula a `seguros` (tabela de domínio).

---

## seguro_saude

- **Linhas:** 0 — **Colunas:** 22 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** extensão de Saúde de `seguros`. Dados do plano de saúde do
  titular: tipo de plano, acomodação, rede, estipulante, carências e prêmios.

| coluna | tipo | descrição (PT) |
|---|---|---|
| dt_nsc | DateTime | Data de nascimento do titular |
| cd_controle_proposta | REAL | **FK → seguros** (parte 1 da chave da proposta) |
| cd_sequencia_endosso | INTEGER | **FK → seguros** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cd_ramo | INTEGER | Código do ramo |
| plano | varchar | Plano de saúde |
| acomodacao | varchar | Tipo de acomodação (enfermaria/apartamento) |
| diarias_uti | INTEGER | Diárias de UTI |
| rede | INTEGER | Rede credenciada |
| usp | REAL | Indicador/valor USP (uso interno) |
| estipulante | varchar | Estipulante |
| sub_estipulante | varchar | Sub-estipulante |
| cvnant | varchar | Convênio anterior |
| tempo_permanecia | varchar | Tempo de permanência (carência) |
| premio_liq | REAL | Prêmio líquido |
| iof | REAL | Valor de IOF |
| prm_tot | REAL | Prêmio total |
| aplcst | REAL | Custo de apólice |
| agenciamento | REAL | Valor de agenciamento |
| certificado | REAL | Número do certificado |
| agendes | varchar | Agência/descrição |
| NROCARTAO | varchar | Número do cartão |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item`.

---

## seguro_saude_cob

- **Linhas:** 0 — **Colunas:** 5 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** coberturas/itens contratados do plano de Saúde, com data de
  início de cobertura.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cd_controle_proposta | REAL | **FK → seguros / seguro_saude** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_saude** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cobertura | varchar | Cobertura do plano |
| dt_cobertura | DateTime | Data de início da cobertura |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `cobertura`.

---

## seguro_saude_dep

- **Linhas:** 0 — **Colunas:** 10 — **VAZIA** (estrutura existe; recurso não utilizado).
- **Propósito inferido:** dependentes do plano de Saúde, com datas de inclusão/exclusão
  e número do cartão.

| coluna | tipo | descrição (PT) |
|---|---|---|
| cpfdep | varchar | CPF do dependente |
| cd_controle_proposta | REAL | **FK → seguros / seguro_saude** (parte 1 da chave) |
| cd_sequencia_endosso | INTEGER | **FK → seguros / seguro_saude** (parte 2; endosso) |
| cd_item | INTEGER | Item dentro da apólice |
| cd_seq | INTEGER | Sequência do dependente |
| nome | varchar | Nome do dependente |
| dt_nasc | DateTime | Data de nascimento |
| dt_inclusao | DateTime | Data de inclusão |
| nrocartao | varchar | Número do cartão |
| dt_exclusao | DateTime | Data de exclusão |

PK inferida: `cd_controle_proposta` + `cd_sequencia_endosso` + `cd_item` + `cd_seq`.

---

## Relacionamentos

Vínculo central — todas as tabelas de ramo ligam-se ao núcleo `seguros` pela chave
composta **`cd_controle_proposta` + `cd_sequencia_endosso`** (a apólice/endosso).

```
seguros (núcleo, 1 linha por apólice/endosso)
│  PK lógica: cd_controle_proposta + cd_sequencia_endosso
│
├── seguro_vida              (1:1 por item Vida)        + cd_item
│     ├── seguro_vida_benef2  (1:N — beneficiários)      + cd_item  [VAZIA]
│     │     (ativada por seguro_vida.flgbenf)
│     ├── seguro_vida_cob2    (1:N — coberturas)         + cd_item  [VAZIA]
│     └── seguro_vida_quest   (1:N — respostas quest.)   + cd_item  [VAZIA]
│           └── questionario_vida (catálogo de perguntas; cia+ramo+codigo)
│                 — NÃO se liga a seguros; é tabela de domínio
│
└── seguro_saude             (1:1 por item Saúde)       + cd_item   [VAZIA]
      ├── seguro_saude_cob    (1:N — coberturas)         + cd_item   [VAZIA]
      └── seguro_saude_dep    (1:N — dependentes)        + cd_item   [VAZIA]
```

Notas:
- O `cd_ramo` presente nas filhas redunda o ramo da apólice e ajuda a discriminar
  qual extensão aplicar; o roteamento real do ramo está em `seguros` (`cd_ramo`,
  `cd_susep`, `subsusep`).
- O par `cd_controle_proposta` + `cd_sequencia_endosso` modela o **versionamento por
  endosso**: cada endosso é uma nova sequência da mesma proposta.
- As FKs são **lógicas** (o Access legado não as declara); migrar para SQLite com
  PK/FK explícitas e índices nesse par é recomendado (ver `docs/ARCHITECTURE.md`).
- Tabelas **vazias** no inventário: `seguro_vida_benef2`, `seguro_vida_cob2`,
  `seguro_vida_quest`, `seguro_saude`, `seguro_saude_cob`, `seguro_saude_dep`.
  `seguro_vida` tem apenas 1 registro. A estrutura existe, mas o uso efetivo
  concentra-se nos Ramos Elementares (RE) — por isso Vida/Saúde ficam para versão
  posterior.
