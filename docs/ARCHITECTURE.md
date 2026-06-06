# Arquitetura

## Restrição que guia tudo: máquina lenta

Alvo de hardware: **Intel Atom, 4 GB de RAM, Linux Mint**. Toda decisão é tomada
para minimizar uso de RAM, de CPU e tamanho do binário.

## Stack

| Camada | Escolha | Motivo |
|---|---|---|
| Casca desktop | **Tauri 2.x** | Usa o WebView do SO (sem embutir Chromium); binário pequeno, RAM baixa |
| Backend / lógica | **Rust** (`src-tauri`) | Nativo, rápido, baixo consumo; faz **todo** o processamento |
| Banco de dados | **SQLite** via `rusqlite` | Arquivo único, sem servidor, leve; migrado do Access |
| Frontend | **React** (padrão) — avaliando Solid/Svelte/Preact | Só apresentação; o mais leve viável |

## Regra de ouro: processamento no Rust, não no front

O frontend **não** carrega listas grandes, não faz filtros/ordenção pesados, não
calcula comissões nem monta relatórios. Ele pede ao Rust (via comandos Tauri) já
o resultado pronto e paginado.

```
┌─────────────────────────────┐         invoke()          ┌──────────────────────────┐
│  Frontend (WebView)          │ ───────────────────────►  │  Backend Rust (src-tauri) │
│  React/Solid — só UI         │                           │                            │
│  - renderiza telas           │   ◄───── JSON enxuto ───── │  - acesso SQLite (rusqlite)│
│  - dispara comandos          │     (página de N itens,   │  - regras de negócio       │
│  - mostra resultado          │      total já calculado)  │  - cálculos / relatórios   │
└─────────────────────────────┘                           │  - busca, filtros, ordenação│
                                                           └──────────────────────────┘
```

### Diretrizes de performance
- **Paginação no SQL** (`LIMIT`/`OFFSET` ou keyset) — nunca trazer a tabela toda
  pro front. Ex.: `clientes`, `seguros`, `comissoes` têm muitos registros.
- **Filtros e busca em SQL**, com índices nas colunas usadas (nome do cliente,
  nº da apólice, CPF, placa, vencimento de parcela).
- **Cálculos no Rust** (comissões, totais de parcelas, vencimentos, relatórios).
- **Sem estado pesado no JS**: o front guarda só a página atual.
- **Lazy load** das tabelas grandes (`ciaveiculos`, `tipo_cobertura_re2`).
- DTOs enxutos: enviar só os campos que a tela mostra.

## Sobre o frontend (React vs. mais leve)

React é o pedido padrão e está documentado como aceitável. Para o alvo Atom/4 GB,
alternativas mais leves valem avaliação na Fase 1:

- **Solid** — API parecida com React (JSX), runtime muito menor, sem virtual DOM.
- **Svelte** — compila pra JS mínimo, ótimo footprint.
- **Preact** — drop-in quase React, ~3 KB.

Decisão: começar com **React** para velocidade de desenvolvimento; medir RAM/CPU
na máquina alvo e migrar para Solid/Svelte se o WebView sofrer. O contrato
front↔Rust (comandos Tauri) é o mesmo independentemente do framework, então a
troca fica barata. Ver [ROADMAP.md](ROADMAP.md).

## Estrutura de código (planejada)

```
src-tauri/
├── Cargo.toml
├── tauri.conf.json
└── src/
    ├── main.rs           # bootstrap Tauri, registro de comandos
    ├── db/               # conexão SQLite, migrations, queries
    ├── domain/           # entidades: cliente, seguro, parcela, comissão...
    ├── services/         # regras de negócio, cálculos, relatórios
    └── commands/         # comandos expostos ao front (#[tauri::command])
frontend/
├── package.json
└── src/                  # só telas e componentes de apresentação
```

## Migração de dados (Access → SQLite)

Pipeline em `scripts/`:
1. `mdb-tables` / `mdb-schema` → ler esquema do `sicsw03.mdb`.
2. `mdb-export` → CSV por tabela.
3. Importar para SQLite com tipos e índices definidos.
4. Validar contagens por tabela contra o legado.

Os artefatos desse processo (mdb, csv, sqlite) ficam em `data/` e não são
versionados.
