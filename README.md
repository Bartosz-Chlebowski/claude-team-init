# team-init

Skill dla Claude Code, który w jednym poleceniu stawia w projekcie **wirtualną firmę**
— Project Managera + workflow agentów, z kompletną dokumentacją zarządzania pracą.

Pasuje do każdego typu projektu: **software, content, research, marketing, operations**.

## Czym się wyróżnia

To **nie jest** „lepszy CLAUDE.md". To system zarządzania zespołem AI z regułami
zapożyczonymi z prawdziwych firm.

- **Project Manager jako jedyny rozmówca.** Ty mówisz PM-owi co zrobić, on dzieli,
  deleguje, nadzoruje, raportuje. Agenci raportują do PM, nie do Ciebie.
- **Bramka akceptacji.** PM nigdy nie zatrudnia agenta, nie zmienia założeń, nie
  startuje większego zadania bez Twojego wyraźnego „tak". Żadnych niespodzianek.
- **Izolacja folderów.** Każdy agent ma swój `team/agents/<slug>/`. Wielu agentów może
  pracować równolegle — żadnych konfliktów merge w tych samych plikach.
- **Self-learning bez chaosu.** Agenci zbierają obserwacje w `LESSONS.md`, **ale nie
  edytują własnych skryptów**. PM widzi `LESSONS`, ocenia, proponuje zmianę skryptu
  Tobie, dopiero po Twojej zgodzie zapisuje. Firma się uczy, ale kontrolowanie.
- **Peer review.** Kod / dokumenty kierunkowe / materiały publikowane przechodzą
  recenzję innego agenta zanim trafią do odbioru PM. Autor nie recenzuje własnej pracy.
- **Dwa tryby delegacji.** PM wciela się w rolę agenta (małe zadania) lub odpala
  subagenta w izolowanym kontekście (duże, równoległe). Dobiera model do wagi
  zadania — Opus dla strategicznych, Sonnet default, Haiku dla mechanicznych.
- **Żywa struktura.** PM proponuje nowe pliki kierunkowe, szablony, procesy gdy
  projekt tego naprawdę potrzebuje — za Twoją akceptacją. Firma rośnie z projektem.
- **Discovery przed setupem.** Skill najpierw sam zapoznaje się z projektem
  (`package.json`, `prisma/`, `README`, git log) i pyta Cię o **1-3 brakujące rzeczy**
  zamiast zalewać kilkunastoma pytaniami.

## Instalacja

```bash
curl -fsSL https://raw.githubusercontent.com/Bartosz-Chlebowski/claude-team-init/main/install.sh | bash
```

Klonuje do `~/.claude/skills/team-init/`. Jeśli skill już jest — robi `git pull`.

**Po instalacji zrestartuj Claude Code**, żeby skill został wczytany.

Alternatywnie bez `curl | bash`:

```bash
git clone https://github.com/Bartosz-Chlebowski/claude-team-init.git ~/.claude/skills/team-init
chmod +x ~/.claude/skills/team-init/setup-team.sh
```

Aktualizacja: `cd ~/.claude/skills/team-init && git pull`.

## Użycie

W katalogu projektu odpal Claude Code i napisz:

```
/team-init
```

Albo opisowo: „zainicjuj wirtualną firmę w tym projekcie".

Claude przejdzie przez 4 fazy: **discovery** (czyta projekt) → **synteza i pytania
uzupełniające** → **potwierdzenie konfiguracji** → **setup**. Niczego nie zapisuje
bez Twojego „tak".

Można też ominąć Claude Code i odpalić bash bezpośrednio:

```bash
bash ~/.claude/skills/team-init/setup-team.sh --help
```

## Co generuje

```
twój-projekt/
├── CLAUDE.md                 # instrukcje projektu (czytane na starcie czatu)
├── ARCHITECTURE.md           # opcjonalne pliki kierunkowe (wg typu projektu)
├── FEATURES.md
├── DECISIONS.md
└── team/
    ├── README.md             # przegląd dla właściciela
    ├── PROJECT_MANAGER.md    # playbook PM
    ├── HIRING.md             # proces zatrudniania
    ├── WORKFLOW.md           # cykl życia zadań, izolacja, peer review, DoD
    ├── STANDARDS.md          # standard pracy (techniczny lub generic)
    ├── REPORTING.md          # formaty raportów
    ├── ROSTER.md             # rejestr aktywnych agentów (start: PM solo)
    ├── TASKS.md              # kolejka zadań
    ├── templates/AGENT_TEMPLATE.md
    └── agents/               # tu PM dodaje agentów gdy realnie potrzebni
```

Wygenerowana zawartość dostosowuje się do typu projektu:

| Typ projektu | STANDARDS.md | CLAUDE.md | Domyślne pliki kierunkowe |
|---|---|---|---|
| `software`   | Techniczny (kod, baza, multi-tenant, RODO) | Z sekcją Stack | ARCHITECTURE, FEATURES, DECISIONS |
| `content`    | Generic (jakość, źródła, struktura, brand) | Bez stacku | FEATURES, DECISIONS |
| `research`   | Generic | Bez stacku | FEATURES, DECISIONS |
| `marketing`  | Generic | Bez stacku | FEATURES, DECISIONS |
| `operations` | Generic | Bez stacku | FEATURES, DECISIONS |
| `other`      | Generic | Bez stacku | DECISIONS |

## Wymagania

`git`, `bash` ≥ 4, `perl` — wszystko standardowe na macOS/Linux. Na Windows: WSL lub Git Bash.

## Licencja

Open source, wolno używać i modyfikować. Bez gwarancji.
