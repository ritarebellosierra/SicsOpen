# data/  — NÃO versionado

Esta pasta guarda os bancos, dumps e a cópia integral do SICS. Todo o conteúdo
(exceto este README) está no `.gitignore` porque contém **dados pessoais** de
clientes e logins do sistema.

## Estrutura

```
data/
├── atual_2026/              # fonte de verdade (banco vivo, mai/2026)
│   ├── sicsw03.mdb          #   banco Access completo (84 MB, 189 tabelas)
│   ├── csv/                 #   1 CSV por tabela (189)
│   ├── schema_sqlite.sql    #   DDL de todas as tabelas (mdb-schema)
│   └── inventario.tsv       #   tabela <TAB> nº colunas <TAB> nº linhas
├── backups/                 # versões históricas (preservam apólices apagadas)
│   ├── 2017-05-15/{sicsw03.mdb, csv/, schema_sqlite.sql}
│   ├── 2012-08-06/{...}
│   └── 2011-06-03/{...}
└── SICSWIN_completo/        # cópia 100% da pasta de instalação do SICS
                             #   (701 MB: app, imagens, PDFs de apólices, XML, modelos)
```

## Como repopular

```bash
./scripts/mdb_dump.sh          # usa o HD externo se montado, senão o backup
```

Fonte preferida (HD externo, atual):
`/media/rita/B04E3F304E3EEF2A/SICSWIN/sicsw03.mdb`

Nada daqui deve ser commitado. Ver modelagem em [../docs/modelagem/](../docs/modelagem/).
