# O sistema legado (SICS / SicsWin)

Notas de engenharia reversa sobre o software original, para orientar a migração.

## O que é

SICS / **SicsWin** — sistema de gestão para corretora de seguros (clientes,
apólices, parcelas, comissões, sinistros, mala direta). Descontinuado.

## Tecnologia original

- **PowerBuilder** (Sybase). Indícios: muitos arquivos `.pbd` (PowerBuilder
  Dynamic libraries), `pbvm125.dll`, `pbodb125.dll`, runtime PB 12.5.
- **Banco Microsoft Access** — arquivo principal `sicsw03.mdb` (formato Jet/MDB,
  acessado via ODBC).
- Componentes Sybase SQL Anywhere também presentes (`dblib7.dll`, `dbodbc7.dll`,
  `dbserv7.dll`) — possível uso em algum módulo/versão.
- Executáveis: `sics_finanmx.exe`, `xmlmigradorsicswin.exe` (migrador XML do
  próprio sistema), entre outros.
- Configuração em `SICSWIN.INI` e `sicscampos.ini`.

## Onde estão os arquivos (backup do HD Windows antigo)

> Caminhos no HD atual (Linux). **Não** versionados — referência apenas.

```
~/Documentos/RITA/BACKUP VELHO/Backup Ricardo/SicsWin/
```

Bancos Access encontrados (cópias em datas diferentes):

| Arquivo | Tam. | Data | Observação |
|---|---:|---|---|
| `/media/rita/B04E3F304E3EEF2A/SICSWIN/sicsw03.mdb` | **87 MB** | **mai/2026** | **FONTE DE VERDADE** — instalação atual/viva (HD externo), 189 tabelas |
| `/media/.../SICSWIN/Suporte/sicsw03.mdb` | 58 MB | abr/2016 | cópia de suporte (HD externo) |
| `Backup Ricardo/SicsWin/sicsw03.mdb` | 54 MB | mai/2017 | cópia antiga |
| `Backup Ricardo/SicsWin/Salva/8-6-2012.../sicsw03.mdb` | 46 MB | ago/2012 | backup interno |
| `Backup Ricardo/SicsWin/Suporte/sicsw03.mdb` | 39 MB | jan/2011 | cópia de suporte |
| `Sicscep.mdb` | 4 MB | — | base de CEPs |

> A instalação **atual** está no HD externo montado em
> `/media/rita/B04E3F304E3EEF2A/SICSWIN/` (banco de mai/2026, 189 tabelas) — bem
> mais recente/completa que a cópia em "Backup Ricardo" (2017, 185 tabelas).
> Migrar a partir dela. Atenção: caminho de montagem do HD externo pode mudar.

Backup exportado pelo programa (na Área de trabalho):

```
~/Área de trabalho/Sicsbkp_1111200113_001.zip   (export XML de 11/11/2020)
```

- **Protegido por senha desconhecida** → inutilizável diretamente.
- Porém o conteúdo (1 XML por tabela) já nos deu o **mapa completo de tabelas** —
  ver [DATA_MODEL.md](DATA_MODEL.md). A migração real usa o `.mdb`, que está
  **aberto, sem criptografia**.

Outros arquivos de apoio na Área de trabalho:
- `CARGAS SEGURADORAS WEBSICS.rtf`, `ConsistenciasWebSics.xls` — material do
  módulo WebSics (versão web do sistema).

## Estratégia de leitura

- O `.mdb` aberto é a fonte de verdade. Ferramenta: **mdbtools**
  (`mdb-tables`, `mdb-schema`, `mdb-export`).
- O `.zip` com senha **não** é necessário; ignorá-lo.
- Preferir o `sicsw03.mdb` de 2017 (maior/mais recente); comparar contagens com
  as cópias antigas para detectar perda/corrupção.

## Cuidados

- O `.mdb` contém **dados pessoais** (clientes, CPF, endereços, dados bancários)
  e provavelmente **logins/senhas** dos operadores (`usuarios`, `snh`). Tudo isso
  fica em `data/` e nunca é commitado.
- Senhas legadas, se em texto/hash fraco, **não** devem ser reaproveitadas: o
  SicsOpen define seu próprio esquema de autenticação.
