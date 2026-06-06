# data/  — NÃO versionado

Esta pasta guarda os bancos e dumps de dados. Todo o conteúdo (exceto este
README) está no `.gitignore` porque contém **dados pessoais** de clientes e
logins do sistema.

## O que vai aqui

- `sicsw03.mdb` — cópia do banco Access legado (fonte da migração).
- `*.csv` — dumps por tabela gerados pelo `mdb-export`.
- `sicsopen.sqlite` — banco novo, migrado.

## Como popular (após instalar mdbtools)

A cópia do `.mdb` mais recente vem de:

```
~/Documentos/RITA/BACKUP VELHO/Backup Ricardo/SicsWin/sicsw03.mdb
```

Ver `scripts/` para a extração. Nada daqui deve ser commitado.
