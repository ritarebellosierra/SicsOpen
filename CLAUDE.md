# SicsOpen — instruções do projeto

Reimplementação aberta do SICS/SicsWin (gestão de corretora de seguros legado).
Leia `README.md` e `docs/` antes de mexer.

## Stack (obrigatória)
- **Tauri 2.x** como app desktop.
- **Rust** (`src-tauri`) faz **TODO** o processamento: dados, regras, cálculos,
  relatórios, busca, filtros, ordenação, paginação.
- **Frontend só apresentação** — React (padrão); pode migrar p/ Solid/Svelte se
  pesar. Nunca colocar lógica de negócio nem listas grandes no front.
- **SQLite** via `rusqlite`.

## Restrição-mestra
Alvo é **PC lento (Atom, 4 GB RAM, Linux Mint)**. Otimize RAM/CPU/binário.
Pagine no SQL, indexe colunas de busca, envie DTOs enxutos ao front.

## Dados
- Bancos legados e dumps ficam em `data/` e **nunca** são commitados.
- O `.mdb` é a fonte; ferramenta de leitura é `mdbtools`.
- O backup `Sicsbkp_*.zip` tem senha desconhecida — ignorar; usar o `.mdb`.
- Contém dados pessoais e logins legados — tratar com cuidado; não reaproveitar
  senhas legadas, criar autenticação nova.

## Docs
- `docs/ARCHITECTURE.md` — stack e performance.
- `docs/DATA_MODEL.md` — mapa de tabelas do SICS.
- `docs/LEGACY_SICS.md` — sistema original e onde estão os arquivos.
- `docs/ROADMAP.md` — fases.
