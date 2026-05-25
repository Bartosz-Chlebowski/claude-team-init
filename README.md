# team-init — generator struktury wirtualnej firmy w projekcie

Tworzy w katalogu dowolnego projektu kompletną strukturę zarządzania pracą zespołem
wirtualnych agentów koordynowanych przez Project Managera (PM). Pasuje do dowolnego
typu projektu — software, content, research, marketing, operations, inne.

Cały pakiet to **jeden folder**: `~/.claude/skills/team-init/`. W środku zarówno
skill dla Claude Code (`SKILL.md`), jak i bash skrypt (`setup-team.sh`) który jest
wywoływany przez skill lub bezpośrednio z linii poleceń.

## Instalacja (jedna komenda)

```bash
curl -fsSL https://raw.githubusercontent.com/Bartosz-Chlebowski/claude-team-init/main/install.sh | bash
```

Co robi: klonuje repo do `~/.claude/skills/team-init/`, ustawia uprawnienia
wykonywalne na skryptach. Jeśli skill już jest zainstalowany — robi `git pull`
(aktualizacja).

**Wymagania:** `git`, `bash` ≥ 4, `perl` (standardowo na macOS/Linux).

Po instalacji **zrestartuj Claude Code** (zamknij i odpal `claude` ponownie),
żeby skill został wczytany. Następnie wpisz `/team-init` w dowolnym projekcie.

### Alternatywnie — git clone (bez curl|bash)

```bash
git clone https://github.com/Bartosz-Chlebowski/claude-team-init.git ~/.claude/skills/team-init
chmod +x ~/.claude/skills/team-init/setup-team.sh
```

### Aktualizacja

```bash
cd ~/.claude/skills/team-init && git pull
```

lub uruchom `install.sh` ponownie.

## Co generuje

```
twój-projekt/
├── CLAUDE.md                          # instrukcje projektu (czytane na starcie czatu)
├── ARCHITECTURE.md                    # opcjonalne — pliki kierunkowe wg wyboru
├── FEATURES.md
├── DECISIONS.md
├── DATABASE_SCHEMA.md
├── PRICING.md
└── team/
    ├── README.md                      # przegląd dla właściciela
    ├── PROJECT_MANAGER.md             # playbook PM
    ├── HIRING.md                      # proces zatrudniania
    ├── WORKFLOW.md                    # cykl życia zadań, izolacja, peer review, DoD
    ├── STANDARDS.md                   # standard pracy (techniczny lub generic)
    ├── REPORTING.md                   # formaty raportów
    ├── ROSTER.md                      # rejestr aktywnych agentów
    ├── TASKS.md                       # kolejka zadań
    ├── templates/
    │   └── AGENT_TEMPLATE.md          # szablon nowego agenta
    └── agents/                        # pusty na start; PM tu dodaje agentów
```

## Filozofia

1. **Project Manager** to jedyny rozmówca właściciela. Deleguje, nadzoruje, raportuje.
2. **Bramka akceptacji** — PM nie zatrudnia, nie podejmuje istotnych decyzji bez zgody właściciela.
3. **Izolacja folderów** — każdy agent pisze tylko w swoim `team/agents/<slug>/`,
   wielu może pracować równolegle bez konfliktów.
4. **Dwa tryby delegacji** — PM wciela się w rolę (małe zadania) lub uruchamia subagenta
   z czystym kontekstem (duże/równoległe).
5. **Dobór modelu** — Opus dla strategicznych, Sonnet default, Haiku dla mechanicznych. PM zawsze Opus.
6. **Peer review** — wynik kierunkowy nie idzie do odbioru PM bez recenzji innego agenta.
7. **Uczenie się** — agenci zbierają `LESSONS.md`, ale **nie edytują** własnych skryptów;
   propozycje zmian idą do PM, ten do właściciela.
8. **Żywa struktura** — PM proponuje nowe pliki kierunkowe / szablony / procesy gdy
   projekt tego naprawdę potrzebuje (za akceptacją właściciela).

## Użycie

### Wariant A — Claude Code (rekomendowany)

W katalogu projektu odpal Claude Code i napisz:

```
/team-init
```

albo:

```
zainicjuj wirtualną firmę w tym projekcie
```

**Flow czterofazowy** (Claude wykonuje sekwencyjnie):

1. **Discovery** — Claude **samodzielnie** zapoznaje się z projektem: czyta
   `package.json`, `pyproject.toml`, `Cargo.toml`, `prisma/`, `README.md`,
   istniejący `CLAUDE.md`, `team/` (jeśli jest), git log. Z tego wyciąga: nazwę,
   stack, multi-tenant (z modeli), RODO (z keywordów), branżę, opis.
2. **Synteza + pytania uzupełniające** — raportuje co znalazł i pyta **tylko o to,
   czego nie wie** (zwykle: owner, confirmacja typu projektu, ewentualne korekty).
3. **Potwierdzenie konfiguracji** — pokazuje pełen config (wszystkie flagi) i czeka
   na wyraźne "tak" zanim cokolwiek zapisze.
4. **Setup** — wywołuje `setup-team.sh` z zebranymi flagami.

Dzięki temu na projekcie z istniejącym kodem Claude zadaje **1-3 pytania** zamiast
kilkunastu; w pustym katalogu — pełny kwestionariusz.

### Wariant B — bash bezpośrednio (bez Claude Code)

Wejdź do katalogu projektu i odpal skrypt podając pełną ścieżkę:

```bash
cd /ścieżka/do/projektu
bash ~/.claude/skills/team-init/setup-team.sh
```

Skrypt sam przeprowadzi kwestionariusz przez stdin (7-15 pytań po polsku zależnie
od typu projektu). Bez discovery — pyta o wszystko, defaultami sugeruje rozsądne wartości.

Można też podać wszystko jako flagi:

```bash
bash ~/.claude/skills/team-init/setup-team.sh \
  --name "Mój CRM" --owner "Anna" --project-type software \
  --description "CRM dla branży X" --industry "edukacja" \
  --stack-frontend "Next.js" --stack-backend "Next.js API" \
  --stack-database "PostgreSQL" --stack-auth "NextAuth" \
  --multitenant yes
```

Pełna lista flag: `bash ~/.claude/skills/team-init/setup-team.sh --help`

**Wygodny alias** w `~/.zshrc` / `~/.bashrc`:

```bash
alias setup-team='bash ~/.claude/skills/team-init/setup-team.sh'
```

Wtedy `setup-team --help` z dowolnego katalogu.

## Typy projektów

Skrypt dostosowuje wygenerowaną zawartość do typu projektu:

| Typ | STANDARDS.md | CLAUDE.md | Default doc files |
|-----|--------------|-----------|-------------------|
| `software`   | Techniczny (kod, baza, multi-tenant, RODO) | Stack technologiczny | ARCHITECTURE, FEATURES, DECISIONS |
| `content`    | Generic (jakość, źródła, struktura, brand) | Bez stacku | FEATURES, DECISIONS |
| `research`   | Generic | Bez stacku | FEATURES, DECISIONS |
| `marketing`  | Generic | Bez stacku | FEATURES, DECISIONS |
| `operations` | Generic | Bez stacku | FEATURES, DECISIONS |
| `other`      | Generic | Bez stacku | DECISIONS |

## Udostępnianie innym

Wystarczy wskazać link do repo:

```
https://github.com/Bartosz-Chlebowski/claude-team-init
```

albo komendę instalacji:

```bash
curl -fsSL https://raw.githubusercontent.com/Bartosz-Chlebowski/claude-team-init/main/install.sh | bash
```

## Modyfikacja szablonów

Wszystkie szablony są w `~/.claude/skills/team-init/templates/` jako `.tpl` (markdown
z placeholderami `{{X}}` i warunkowymi blokami `<!-- IF_X --> ... <!-- /IF_X -->`).
Możesz je dowolnie edytować — dodawać sekcje, zmieniać formuły, dorzucać własne
szablony pod konkretne potrzeby.

**Placeholdery** dostępne w szablonach:
- `{{PROJECT_NAME}}`, `{{OWNER_NAME}}`, `{{PROJECT_DESCRIPTION}}`
- `{{PROJECT_TYPE}}`, `{{PRODUCT_TYPE}}`, `{{INDUSTRY}}`
- `{{STACK_FRONTEND}}`, `{{STACK_BACKEND}}`, `{{STACK_DATABASE}}`, `{{STACK_AUTH}}`, `{{STACK_OTHER}}`
- `{{DATA_LOCATION}}`, `{{DATE}}`, `{{LANGUAGE}}`
- `{{DOC_FILES_TABLE}}`, `{{DOC_FILES_INLINE}}`

**Warunkowe bloki** (włącz w skrypcie przez odpowiednie flagi):
- `IF_IS_TECHNICAL` / `IF_IS_NONTECHNICAL` — wg `--project-type`
- `IF_MULTITENANT` — wg `--multitenant`
- `IF_RODO` — wg `--rodo`
- `IF_HAS_DB` — wg obecności `--stack-database` (≠ "none")
- `IF_STACK_OTHER` — gdy `--stack-other` niepuste

Żeby dodać nowy warunek: dorzuć zmienną do listy `for var in IS_TECHNICAL ...` w
funkcji `render_template` w `setup-team.sh`.

## Licencja

Wolno używać, modyfikować, udostępniać. Bez warranty — używasz na własną odpowiedzialność.
