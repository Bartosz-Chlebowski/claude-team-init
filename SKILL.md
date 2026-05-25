---
name: team-init
description: Inicjalizuje strukturę "wirtualnej firmy" w bieżącym projekcie — Project Manager + workflow agentów koordynowany przez PM, z pełną dokumentacją (CLAUDE.md, team/* playbooki, opcjonalne pliki kierunkowe). Pasuje do dowolnego typu projektu (software, content, research, marketing, operations). Przed setupem zapoznaje się z istniejącą zawartością projektu i proponuje sensowne defaulty. Użyj, gdy użytkownik prosi o "wirtualną firmę", "strukturę zespołu", "team init", "setup PM", "zainicjuj zespół", "/team-init", "skopiuj strukturę zespołu", lub podobnie.
---

# team-init — inicjalizacja wirtualnej firmy w projekcie

## Cel

Tworzysz w katalogu projektu kompletną strukturę zarządzania pracą zespołem
wirtualnych agentów koordynowanych przez Project Managera (PM). Skrypt bash
robi mechaniczną pracę generowania plików; **Twoim zadaniem** jest zebrać pełny
kontekst projektu, dobrać sensowne defaulty i potwierdzić wszystko z użytkownikiem
**zanim** wywołasz skrypt.

## Flow — cztery fazy

Wykonujesz je **sekwencyjnie**. Nie pytaj użytkownika o nic, dopóki nie zakończysz
fazy 1 (discovery). Nie wywołuj skryptu, dopóki nie zakończysz fazy 3 (potwierdzenie).

---

### FAZA 1 — Discovery (Ty sam, bez pytania użytkownika)

Cel: dowiedzieć się **jak najwięcej** o projekcie z istniejących plików, żeby zadać
użytkownikowi minimalną liczbę pytań i podać sensowne defaulty.

**Sprawdź obecność (LS bieżącego katalogu):**

```bash
ls -la
```

Następnie **odczytaj zawartość** każdego z poniższych plików, **jeśli istnieje**:

| Plik / folder | Co z niego wyciągniesz |
|---|---|
| `team/` | Czy struktura jest już zainicjowana? Jeśli tak — przeczytaj `team/ROSTER.md` i `team/TASKS.md` żeby zrozumieć stan |
| `CLAUDE.md` | Bazowe instrukcje projektu — nazwa, opis, stack, założenia, owner |
| `README.md` | Opis projektu, cele, technologie, kontekst biznesowy |
| `package.json` | Node/JS — nazwa, dependencies → frontend/backend stack |
| `pyproject.toml` / `requirements.txt` | Python — stack |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `Gemfile` | Ruby |
| `composer.json` | PHP |
| `pom.xml` / `build.gradle` | Java/Kotlin |
| `prisma/schema.prisma` | ORM Prisma → PostgreSQL/MySQL/SQLite, schemat |
| `migrations/` lub `db/migrate/` | Istnieje baza, jest migracjami zarządzana |
| `next.config.*` / `nuxt.config.*` / `vite.config.*` | Frontend framework |
| `.env.example` lub `.env.template` | Sugestia o sekretach, integracjach |
| `docker-compose.yml` / `Dockerfile` | Serwisy, baza, infrastruktura |
| `.github/workflows/` | CI/CD, automatyzacja |
| Inne `*.md` w root (np. `ARCHITECTURE.md`, `FEATURES.md`, `DECISIONS.md`, `RESEARCH_*.md`) | Wcześniejsze ustalenia, plany, raporty |

**Sprawdź repo git** (jeśli `.git/` istnieje):

```bash
git log --oneline -20    # ostatnie commity → o czym jest projekt
git remote -v            # gdzie host (sugestia: github → nazwa repo/org)
```

**Wyciągnij imię właściciela z pamięci Claude'a:**

Claude trzyma user memory w `~/.claude/projects/<encoded-pwd>/memory/`. Sprawdź dwie
lokalizacje (per-project i dla katalogu home — tam zwykle jest najpełniejszy profil):

```bash
# Konwencja: PWD z "/" zamienionym na "-"
HOME_MEM="$HOME/.claude/projects/-Users-$(whoami)/memory"
PROJ_MEM="$HOME/.claude/projects/$(pwd | sed 's|/|-|g')/memory"

# Sprawdź user_profile.md (najczęściej zawiera imię w 'description' lub treści)
cat "$HOME_MEM/user_profile.md" 2>/dev/null
cat "$PROJ_MEM/user_profile.md" 2>/dev/null

# Index pamięci może wskazać dodatkowe pliki
cat "$HOME_MEM/MEMORY.md" 2>/dev/null
```

Jeśli znajdziesz imię (z frontmattera `name:`, z `description`, lub z treści typu
"User profile — basic info about X") — użyj jako **default dla `--owner`**.
W fazie 2 nie pytaj o imię — potwierdź: "Wykryłem cię jako: X. OK?".

Jeśli **nie znajdziesz** — wtedy w fazie 2 zapytaj normalnie.

**Zbuduj proponowaną konfigurację** na podstawie discovery:

- `--owner`: z user memory (patrz wyżej) → fallback: zapytaj
- `--name`: z `package.json#name`, `pyproject#name`, `Cargo.toml#name`, nazwy katalogu, `<h1>` z README, lub `CLAUDE.md`
- `--project-type`:
  - jest `package.json` / `Cargo.toml` / `pyproject.toml` / `go.mod` / framework config → `software`
  - jest tylko `*.md`, `content/`, `posts/`, `articles/` → `content`
  - jest tylko `*.md` z research/badania w nazwie → `research`
  - inne → zapytaj
- `--stack-frontend`: z `next.config.*`/`vite.config.*`/`nuxt.config.*` + `package.json` dependencies
- `--stack-backend`: z `package.json` (express, fastify, hono, nest), `pyproject` (fastapi, django, flask), itp.
- `--stack-database`: z obecności `prisma/`, `migrations/`, dependencies (`prisma`, `pg`, `sqlalchemy`, `mongoose`, `mongodb`)
- `--stack-auth`: z dependencies (`next-auth`, `clerk`, `auth0`, `passport`, `devise`)
- `--multitenant`: szukaj `tenant_id`, `tenantId`, `Tenant` w schemat/kodzie → silny sygnał yes
- `--rodo`: szukaj słów "RODO", "GDPR" w README/CLAUDE.md → yes; jeśli infra w EU lub PL → prawdopodobnie yes
- `--industry`, `--description`: z README / CLAUDE.md

**Jeśli projekt jest pusty** (tylko `.git/` lub kompletnie pusty katalog) — startujesz od zera, masz tylko nazwę katalogu jako sugestię.

**Specjalny przypadek — `team/` już istnieje:**
- Przeczytaj `team/ROSTER.md` i `team/TASKS.md` żeby zrozumieć stan
- W fazie 2 zapytaj **wprost**: "team/ jest już zainicjowane. Co chcesz zrobić?" — opcje:
  - `Nadpisać całość` (czysty restart — destruktywne)
  - `Pozostawić bez zmian` (przerwij setup)
  - `Pokaż mi obecny stan struktury` (przeczytaj i opisz, nie modyfikuj)

---

### FAZA 2 — Synteza i pytania uzupełniające

Po fazie 1 **zaprezentuj użytkownikowi** to, co odkryłeś, **w jednej wiadomości**.
Forma: krótka, zwięzła, w punktach.

**Szablon raportu discovery:**

```
Zapoznałem się z projektem. Oto co znalazłem:

📂 Katalog: <pwd>
👤 Właściciel: <wyciągnięty z user memory lub "do potwierdzenia">
📝 Plików konfiguracyjnych: <lista>
🏗️  Wykryty stack: <co rozpoznałem>
📚 Istniejąca dokumentacja: <pliki MD, jeśli są>
🎯 Wstępna klasyfikacja: <project-type>
⚠️  team/ status: <"nie ma" | "już istnieje — N agentów aktywnych" | "częściowo zainicjowane">

Proponowane defaulty:
- Właściciel: <wartość z memory lub "?">
- Nazwa: <wartość>
- Typ projektu: <wartość>
- Stack: <wartość>
- Multi-tenant: <yes/no — z uzasadnieniem>
- RODO: <yes/no — z uzasadnieniem>

Brakuje mi info o:
- <lista rzeczy do dopytania — owner tylko jeśli nie znaleziono w memory>
```

**Następnie zadaj pytania** przez AskUserQuestion — **tylko o to, czego nie wiesz**.
Nie pytaj o rzeczy, które już ustaliłeś z discovery — pokaż je jako defaulty
i zapytaj o **confirmację / korekty**.

**Zasady pytania:**
- Max 3-4 pytania na raz (AskUserQuestion przyjmuje do 4)
- Pytaj o **najważniejsze brakujące informacje** najpierw:
  1. Imię właściciela / decydenta — **tylko jeśli nie wyciągnąłeś z user memory**.
     Jeśli wyciągnąłeś — potwierdź: "Wykryłem cię jako: X. OK?" (1 pytanie tak/nie)
  2. Confirmacja `project-type` jeśli wieloznaczne
  3. Krótki opis (1 zdanie) — często wykryjesz z README, ale potwierdź
  4. Akceptacja defaultów stacku albo korekty
- Dla projektów software: zapytaj o multi-tenant, RODO jeśli nie udało się wywnioskować
- Zapytaj o pliki kierunkowe — które wygenerować poza domyślnymi

**Reaguj iteracyjnie**: jeśli odpowiedzi użytkownika zmienią coś fundamentalnego
(np. zmiana project-type), wróć z aktualizacją defaultów i kolejnymi pytaniami.

---

### FAZA 3 — Pełna konfiguracja do potwierdzenia

Po zebraniu wszystkich odpowiedzi **pokaż użytkownikowi pełny config** w jednej
wiadomości i **poproś o ostateczne tak/nie**:

```
Konfiguracja do zatwierdzenia:

Projekt:
  Nazwa:            <name>
  Właściciel:       <owner>
  Opis:             <description>
  Typ:              <project-type>
  Branża:           <industry>

[Jeśli software:]
Stack:
  Frontend:         <stack-frontend>
  Backend:          <stack-backend>
  Baza danych:      <stack-database>
  Auth:             <stack-auth>
  Inne:             <stack-other lub "—">

Założenia:
  Multi-tenant:     <yes/no>
  RODO:             <yes/no>
  Lokalizacja danych: <data-location lub "—">

Pliki kierunkowe do wygenerowania:
  <lista>

Docelowy katalog:   <pwd>

[Jeśli team/ istnieje:]
⚠️  team/ już istnieje — zostanie nadpisane / pozostawione bez zmian

Akceptujesz? (tak/nie/zmień <co>)
```

**Czekaj na potwierdzenie.** Nie wywołuj skryptu na podstawie domysłu, że user
powiedział "ok" gdzieś wcześniej — wymagaj jawnego "tak" na ten konkretny plan.

---

### FAZA 4 — Setup (dopiero teraz)

Znajdź ścieżkę do skryptu:

```bash
SCRIPT="$HOME/.claude/skills/team-init/setup-team.sh"
```

Jeśli `$HOME/.claude/skills/team-init/setup-team.sh` nie istnieje, sprawdź też
`$HOME/Documents/team-template/setup-team.sh` (alternatywna standalone lokalizacja).
Jeśli żaden nie istnieje — zatrzymaj się i poproś użytkownika o weryfikację instalacji.

Wywołaj przez **Bash tool**:

```bash
bash "$SCRIPT" \
  --name "<nazwa>" \
  --owner "<imię>" \
  --description "<opis>" \
  --project-type "<typ>" \
  --industry "<branża>" \
  [flagi stack jeśli software] \
  [--multitenant yes/no] \
  [--rodo yes/no] \
  [--data-location "..."] \
  --doc-files "<lista>" \
  --target-dir "<pwd>" \
  --non-interactive \
  [--force jeśli user zgodził się nadpisać]
```

**Ważne flagi:**
- `--target-dir` — zawsze absolutna ścieżka PWD
- `--non-interactive` — wyłącza pytania bash-a przez stdin (Ty już zebrałeś dane)
- `--force` — tylko po wyraźnej zgodzie usera na nadpisanie

---

### FAZA 5 — Raport końcowy

Po wywołaniu skryptu:

1. **Pokaż output** bash-a (lista utworzonych plików)
2. **Sugeruj następny krok**:
   ```
   Następny krok:
   @team/PROJECT_MANAGER.md — działaj jako Project Manager. Zadanie: <pierwsze zadanie>
   ```
   Sugestia pierwszego zadania zależy od typu projektu:
   - software: "ustal MVP scope, ARCHITECTURE, FEATURES"
   - content: "ustal strategię contentową, persony, kalendarz publikacji"
   - research: "ustal cele badania, hipotezy, metodologię"
   - inne: dopasuj wg kontekstu
3. **Przypomnij krótko o filozofii**: PM ma bramkę akceptacji (nie robi nic istotnego bez Twojej zgody), struktura jest żywa (PM rozbudowuje ją w miarę realnych potrzeb).

---

## Co generuje skrypt — przegląd

| Plik | Treść |
|------|-------|
| `CLAUDE.md` | Bazowe instrukcje projektu — czytany na starcie każdego czatu |
| `team/README.md` | Jak działa wirtualna firma — przegląd dla właściciela |
| `team/PROJECT_MANAGER.md` | Playbook PM: pętla pracy, delegacja, bramki akceptacji, rozbudowa struktury, uczenie się |
| `team/HIRING.md` | Kiedy/jak zatrudniać agentów + karta rekrutacji |
| `team/WORKFLOW.md` | Cykl życia zadania, izolacja folderów, handoffy, peer review, DoD, uczenie się |
| `team/STANDARDS.md` | Standard pracy (technical/generic wg typu projektu) |
| `team/REPORTING.md` | Formaty raportów PM |
| `team/ROSTER.md` | Rejestr aktywnych agentów (PM zaczyna sam) |
| `team/TASKS.md` | Kolejka zadań i log zdarzeń |
| `team/templates/AGENT_TEMPLATE.md` | Szablon skryptu nowego agenta |
| Pliki kierunkowe (opcjonalne) | `ARCHITECTURE.md`, `FEATURES.md`, `DECISIONS.md`, `DATABASE_SCHEMA.md`, `PRICING.md` — wg wyboru |

## Filozofia struktury (krótko)

1. **Project Manager** — jedyny rozmówca właściciela, deleguje/nadzoruje/raportuje
2. **Bramka akceptacji** — PM nie zatrudnia / nie podejmuje istotnych decyzji bez zgody
3. **Izolacja folderów** — każdy agent pisze tylko w swoim `team/agents/<slug>/`
4. **Dwa tryby delegacji** — wcielenie (małe) lub subagent (duże/równoległe)
5. **Dobór modelu** — Opus strategiczny, Sonnet default, Haiku mechaniczny. PM zawsze Opus
6. **Peer review** — kod/dokumenty kierunkowe/materiały publikowane przechodzą review
7. **Uczenie się** — agenci zbierają `LESSONS.md`, nie edytują własnych skryptów
8. **Żywa struktura** — PM proponuje nowe pliki/szablony/procesy gdy realnie potrzeba

## Czego NIE robić

- **NIE wywołuj skryptu zanim przejdziesz przez fazy 1-3.** Discovery → synteza → potwierdzenie → setup.
- **NIE pytaj o rzeczy które już znasz z discovery.** Pokaż je jako default i poproś o potwierdzenie/korektę.
- **NIE zadawaj kilkunastu pytań naraz.** Max 3-4 na blok AskUserQuestion, w fali iteracyjnej.
- **NIE używaj defaultów multi-tenant/RODO=yes bez sygnału.** Pytaj jeśli niejasne.
- **NIE uruchamiaj bez `--non-interactive`** (inaczej bash zacznie pytać przez stdin równolegle z Tobą).
- **NIE używaj `--force`** bez wyraźnej zgody na nadpisanie istniejącej struktury.
- **NIE modyfikuj wygenerowanych plików** po setupie — to praca PM-a od momentu inicjalizacji.

## Typowe scenariusze

**Projekt pusty (greenfield):**
- Discovery: katalog pusty / tylko `.git/`
- Synteza: "Projekt nowy, brak istniejącej zawartości. Potrzebuję od Ciebie wszystkiego."
- Pytania: nazwa, owner, typ, opis, stack (jeśli software)
- Potwierdzenie → setup

**Projekt software z istniejącym kodem (np. Next.js + Prisma):**
- Discovery: wykrywa `package.json` (Next.js, NextAuth), `prisma/schema.prisma` (PostgreSQL), `README.md`
- Synteza: pokazuje wszystko co wywnioskował z plików
- Pytania: tylko owner, multi-tenant (jeśli niejasne), confirmacja
- Potwierdzenie → setup

**Projekt z istniejącym `team/`:**
- Discovery: znajduje `team/`, czyta ROSTER + TASKS
- Synteza: raportuje stan ("PM + 2 agentów, 3 zadania aktywne")
- Pytania: "Co chcesz zrobić — nadpisać / zostawić / pokazać stan?"
- Jeśli `nadpisać`: kontynuuj normalnie z `--force`. Jeśli inne: zakończ bez setupu.

**Projekt content (np. tylko `posts/` i kilka `*.md`):**
- Discovery: brak plików kodowych, są treści
- Synteza: "Wygląda na projekt content. Potwierdź lub powiedz, że to coś innego."
- Pytania: owner, opis, branża, ewentualnie typ jeśli wieloznaczny
- Potwierdzenie → setup
