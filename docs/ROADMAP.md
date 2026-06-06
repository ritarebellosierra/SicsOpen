# Roadmap

## Fase 0 — Levantamento e documentação  *(atual)*
- [x] Localizar a instalação do SICS e os bancos `.mdb`
- [x] Reconstruir o mapa de tabelas (via export XML) → [DATA_MODEL.md](DATA_MODEL.md)
- [x] Documentar arquitetura e stack → [ARCHITECTURE.md](ARCHITECTURE.md)
- [x] Documentar o sistema legado → [LEGACY_SICS.md](LEGACY_SICS.md)
- [x] Instalar `mdbtools` e extrair esquema real + tabela `usuarios`
- [x] Iniciar repositório git e primeiro commit (docs) — repo público no GitHub
- [x] Extrair 100% dos dados (banco 2026 + backups 2017/2012/2011 + pasta SICSWIN)
- [x] Modelagem real por contexto em [modelagem/](modelagem/) (em uso + versão posterior)

## Fase 1 — Migração de dados
- [ ] Script `scripts/mdb_dump.sh`: `mdb-schema` + `mdb-export` por tabela
- [ ] Definir esquema SQLite (tipos, PKs, FKs, índices)
- [ ] Importar `.mdb` → `data/sicsopen.sqlite`
- [ ] Validar contagens por tabela vs. legado
- [ ] Decidir framework de frontend medindo na máquina alvo (React vs Solid/Svelte)

## Fase 2 — Esqueleto do app
- [ ] Scaffold Tauri 2.x (`src-tauri` + frontend)
- [ ] Conexão Rust ↔ SQLite (`rusqlite`)
- [ ] Primeiro comando: listar clientes paginado
- [ ] Tela de login (autenticação nova, não a legada)

## Fase 3 — Módulos (na ordem de valor)
- [ ] Clientes (cadastro, busca, endereços, telefones)
- [ ] Apólices / seguros (auto, RE, vida)
- [ ] Financeiro (parcelas, cheques, comissões)
- [ ] Sinistros
- [ ] Relatórios e mala direta (etiquetas, cartas)

## Fase 4 — Polimento
- [ ] Otimização de RAM/CPU na máquina alvo
- [ ] Empacotamento/instalador Linux
- [ ] Backup/restauração do SQLite
