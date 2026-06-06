# SicsOpen

Reimplementação aberta e moderna do **SICS / SicsWin** — sistema de gestão para
corretora de seguros que foi descontinuado. O objetivo é recuperar os dados
históricos (clientes, apólices, comissões, sinistros) presos no banco legado em
Microsoft Access e oferecer um aplicativo desktop leve, que rode bem em
**computadores fracos** (alvo: Intel Atom, 4 GB de RAM, Linux Mint).

## Por que existe

O SICS original era um aplicativo Windows feito em **PowerBuilder + banco
Microsoft Access (`sicsw03.mdb`)**, hoje sem suporte. Os backups exportados pelo
programa (`Sicsbkp_*.zip`) vêm **protegidos por senha que não temos**, mas o
banco Access (`.mdb`) está acessível sem criptografia. O SicsOpen lê esse banco,
migra para um formato moderno e dá vida nova ao sistema.

## Princípios de arquitetura

> Alvo é uma máquina lenta. Cada decisão favorece leveza e processamento no
> backend nativo.

- **Tauri** como casca do app desktop (binário pequeno, baixo consumo de RAM —
  usa o WebView do sistema, não embute um Chromium).
- **Todo o processamento em Rust** (backend `src-tauri`): acesso a dados,
  regras de negócio, cálculos de comissão/parcelas, geração de relatórios,
  busca e filtros. Nada de lógica pesada no JavaScript.
- **Frontend só para apresentação**: React por padrão; avaliando alternativas
  mais leves (Solid / Svelte / Preact) — ver [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
- **Dados em SQLite** (migrados do Access), acessados pelo Rust via `rusqlite`.

## Estrutura

```
SicsOpen/
├── README.md
├── CLAUDE.md            # instruções para sessões futuras do Claude
├── docs/
│   ├── ARCHITECTURE.md  # stack, decisões, performance no PC fraco
│   ├── DATA_MODEL.md    # modelo de dados do SICS (tabelas e grupos)
│   ├── LEGACY_SICS.md    # o que sabemos do sistema original / arquivos
│   └── ROADMAP.md       # fases do projeto
├── scripts/             # scripts de extração/migração do banco legado
└── data/                # bancos e dumps — NÃO versionado (.gitignore)
```

## Estado atual

Fase 0 — **levantamento e documentação**. O código (`src-tauri`, frontend) ainda
será scaffolded. Veja [docs/ROADMAP.md](docs/ROADMAP.md).

## Dados

Os bancos legados e qualquer dump migrado ficam em `data/` e **não são
commitados** (contêm dados pessoais de clientes). Veja [data/README.md](data/README.md).
