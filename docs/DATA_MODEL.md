# Modelo de dados do SICS

Mapa das tabelas do sistema legado, reconstruído a partir do backup
`Sicsbkp_1111200113_001.zip` (export XML de 11/11/2020, uma tabela por arquivo)
e do banco `sicsw03.mdb`. Os tamanhos vêm do export XML e dão uma noção do
volume de cada tabela.

> Este documento descreve **estrutura/esquema**, não dados reais. Nenhum dado
> pessoal de cliente é versionado.

## Grupos funcionais

### 1. Clientes e pessoas
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `clientes` | 261 KB | Cadastro central de clientes (segurados) |
| `enderecos` | 196 KB | Endereços dos clientes |
| `telefones` | 17 KB | Telefones |
| `cliente_end_cobranca` | 8.6 KB | Endereço de cobrança |
| `clientes_bancos` | 9.5 KB | Dados bancários do cliente |
| `clientes_parentes` | 7.4 KB | Vínculos familiares (beneficiários etc.) |
| `clientes_parecidos` | 151 B | Apoio à deduplicação de cadastros |
| `proponente` | 10 KB | Proponentes (pré-cliente em proposta) |

### 2. Apólices / seguros
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `seguros` | 1.8 MB | Apólices (núcleo do sistema) |
| `seguro_auto` | 1.6 MB | Dados específicos de seguro automóvel |
| `acessorios_auto` | 7 KB | Acessórios do veículo segurado |
| `seguro_condutor` | 2.9 KB | Condutores |
| `seguro_re` | 374 KB | Ramos elementares / patrimonial (RE) |
| `seguro_re_bens` | 20 KB | Bens cobertos no RE |
| `seguro_re_coberturas` | 308 KB | Coberturas do RE |
| `seguro_re_clsbenef` | 2.8 KB | Cláusulas beneficiárias |
| `seguro_re_clspartdecla` | 4.6 KB | Participação/declarações |
| `seguro_vida` | 2.1 KB | Seguro de vida |
| `questionario_vida` | 2.5 KB | Questionário de vida |
| `seguro_outros` | 7.5 KB | Outros ramos |
| `seguro_clausulas` | 7.9 KB | Cláusulas da apólice |
| `seguro_questao` | 841 KB | Respostas de questionário por apólice |
| `seguro_suseps` | 22 KB | Vínculo apólice × código SUSEP |
| `aplnotrenov` | 13 KB | Apólices não renovadas |

### 3. Cláusulas, coberturas e tipos (tabelas de domínio)
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `clausulas` | 218 KB | Catálogo de cláusulas |
| `tipo_clausula` | 26 KB | Tipos de cláusula |
| `tipo_cobertura_re` | 25 KB | Tipos de cobertura RE |
| `tipo_cobertura_re2` | 2.1 MB | Catálogo extenso de coberturas RE |
| `tipo_endosso` | 76 KB | Tipos de endosso |
| `tipo_etiqueta` / `temp_etiqueta` | 39 KB / 485 B | Etiquetas (mala direta) |
| `tipo_registro` | 5.3 KB | Tipos de registro |
| `tipo_relatorio` | 3.7 KB | Tipos de relatório |
| `tipo_resp_questao` | 481 KB | Respostas possíveis de questionário |
| `questao` | 488 KB | Banco de questões |

### 4. Financeiro
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `parcelas` | 858 KB | Parcelamento dos prêmios |
| `cheques` | 769 KB | Controle de cheques |
| `comissoes` | 1.1 MB | Comissões (movimento) |
| `comissoes_capa` | 133 KB | Capa/agrupamento de comissões |
| `forma_pagamento` | 8.6 KB | Formas de pagamento |
| `imposto` | 434 B | Tabela de impostos |

### 5. Sinistros
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `sinistros` | 28 KB | Sinistros |
| `sinistros_historico` | 2 KB | Histórico/andamento do sinistro |

### 6. Seguradoras e tabelas de mercado
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `seguradoras` | 185 KB | Companhias seguradoras |
| `deptos_cia` | 1.4 KB | Departamentos das cias |
| `ciaveiculos` | **11 MB** | Tabela de veículos por cia (tipo FIPE) — maior tabela |
| `cadoficinas` | 1.5 KB | Oficinas credenciadas |
| `ramos` | 15 KB | Ramos de seguro |
| `ramo_susep` | 185 KB | Ramos SUSEP |
| `ramo_susep_agenciamento` | 2.3 KB | Agenciamento por ramo SUSEP |
| `suseps` | 7.4 KB | Códigos SUSEP do corretor |
| `cadgerais` | 513 KB | Cadastros gerais / parâmetros |
| `cartacor` | 2 KB | Cartas/correspondência (modelos) |

### 7. Sistema e operação
| Tabela | Tam. XML | Papel provável |
|---|---:|---|
| `usuarios` | 1.3 KB | **Usuários do programa (login/senha/permissão)** |
| `snh` | 1.1 KB | Senhas / controle de acesso |
| `agenda` | 87 KB | Agenda/compromissos |
| `agendatel` | 1.2 KB | Agenda telefônica |

## Observações de migração

- `ciaveiculos` (11 MB) e `tipo_cobertura_re2` (2.1 MB) são as tabelas mais
  pesadas — candidatas a índices e carregamento sob demanda no SQLite.
- `usuarios` é minúscula (poucos registros) — a extração via `mdbtools` deve
  retornar a lista completa de operadores do sistema rapidamente.
- O export XML de 2020 e o `sicsw03.mdb` de 2017 podem divergir; a migração
  deve usar a fonte mais completa/recente disponível em `data/`.

## A confirmar (após `mdbtools` instalado)
- [ ] Lista real de tabelas no `sicsw03.mdb` (`mdb-tables`)
- [ ] Esquema de colunas de cada tabela (`mdb-schema`)
- [ ] Conteúdo da tabela `usuarios` e `snh`
- [ ] Chaves/relacionamentos entre `clientes` × `seguros` × `parcelas` × `comissoes`
