#!/usr/bin/env bash
# Extrai esquema e dados do banco Access legado do SICS para data/.
# Requer: mdbtools (mdb-tables, mdb-schema, mdb-export).
#
# Uso:
#   ./scripts/mdb_dump.sh [caminho_do_mdb]
#
# Sem argumento, usa o sicsw03.mdb mais recente do backup conhecido.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATA="$ROOT/data"
# Fonte preferida: instalação ATUAL no HD externo (mais recente/completa).
# Fallback: cópia antiga (2017) no "Backup Ricardo".
MDB_ATUAL="/media/rita/B04E3F304E3EEF2A/SICSWIN/sicsw03.mdb"
MDB_BACKUP="$HOME/Documentos/RITA/BACKUP VELHO/Backup Ricardo/SicsWin/sicsw03.mdb"
if [ -n "${1:-}" ]; then MDB="$1"; elif [ -f "$MDB_ATUAL" ]; then MDB="$MDB_ATUAL"; else MDB="$MDB_BACKUP"; fi
echo ">> Fonte: $MDB"

command -v mdb-tables >/dev/null 2>&1 || { echo "ERRO: mdbtools não instalado (sudo apt install -y mdbtools)"; exit 1; }
[ -f "$MDB" ] || { echo "ERRO: mdb não encontrado: $MDB"; exit 1; }

mkdir -p "$DATA/schema" "$DATA/csv"

echo ">> Tabelas:"
mdb-tables -1 "$MDB" | tee "$DATA/tables.txt"

echo ">> Esquema completo -> data/schema/sicsw03.sql"
mdb-schema "$MDB" sqlite > "$DATA/schema/sicsw03.sql"

echo ">> Exportando cada tabela para CSV em data/csv/"
while IFS= read -r t; do
  [ -z "$t" ] && continue
  echo "   - $t"
  mdb-export "$MDB" "$t" > "$DATA/csv/${t}.csv"
done < "$DATA/tables.txt"

echo ">> Pronto. Conteúdo em data/ (não versionado)."
