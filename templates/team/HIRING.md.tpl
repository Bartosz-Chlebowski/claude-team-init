# Proces zatrudniania — {{PROJECT_NAME}}

> Instrukcja dla Project Managera: kiedy i jak zatrudniać agentów, jak nadawać kompetencje.
> Odwołanie: `@team/HIRING.md`

---

## 1. Kiedy zatrudniać

Zatrudniasz **tylko**, gdy spełnione są łącznie warunki:
- istnieje konkretne zadanie do wykonania,
- żaden agent w `ROSTER.md` nie ma pasującej kompetencji,
- luki nie da się rozsądnie pokryć rozszerzeniem kompetencji istniejącego agenta.

Nie zatrudniasz „na zapas", nie tworzysz ról dublujących istniejące, nie mnożysz
agentów dla samej struktury. Mały, kompetentny zespół > duży, rozmyty.

Jeśli zadanie da się pokryć **rozszerzeniem** kompetencji istniejącego agenta —
to też zmiana wymagająca akceptacji właściciela (karta zmiany, sekcja 4).

---

## 2. Proces krok po kroku

**Krok 1 — Identyfikacja luki.**
Nazwij konkretnie, jakiej kompetencji brakuje. Nie „ktoś od X" w stylu ogólnym, tylko
konkretny opis: co dokładnie ma umieć, dla jakiego zadania, z jakim wyjściem.
<!-- IF_IS_TECHNICAL -->
Przykład: „potrzebny backend developer {{STACK_BACKEND}} do warstwy API multi-tenant".
<!-- /IF_IS_TECHNICAL -->
<!-- IF_IS_NONTECHNICAL -->
Przykład: „potrzebny copywriter z doświadczeniem w branży {{INDUSTRY}}, piszący
artykuły SEO 1500-2500 słów z research-em źródeł".
<!-- /IF_IS_NONTECHNICAL -->

**Krok 2 — Karta rekrutacji.**
Wypełnij kartę wg szablonu z sekcji 4. Jedna karta = jeden agent.

**Krok 3 — Akceptacja właściciela.**
Przedstaw kartę właścicielowi. **Czekasz na akceptację.** {{OWNER_NAME}} może zmienić zakres,
kompetencje lub odrzucić zatrudnienie. Nie tworzysz agenta przed akceptacją.

**Krok 4 — Utworzenie agenta.** Po akceptacji:
1. Ustal `slug` agenta — krótki, kebab-case, unikalny (np. `backend-dev`, `qa-tester`,
   `seo-content`, `data-analyst`). Slug = nazwa folderu i pliku.
2. Utwórz folder roboczy: `team/agents/<slug>/`.
3. Utwórz skrypt agenta: `team/agents/<slug>/<slug>.md` na bazie
   `team/templates/AGENT_TEMPLATE.md`, wypełniony danymi z karty rekrutacji.
4. Utwórz pusty plik `team/agents/<slug>/LESSONS.md` (agent zapisuje tam
   obserwacje, PM zerka przy odbiorze — patrz `WORKFLOW.md` sekcja 10).
5. Dopisz agenta do `team/ROSTER.md` (nowy wiersz tabeli, status: aktywny).
6. Jeśli zatrudnienie to istotna decyzja organizacyjna — odnotuj w `team/TASKS.md`
   w logu zdarzeń.

**Krok 5 — Potwierdzenie.**
Poinformuj właściciela: agent utworzony, gdzie jest jego skrypt, jak się do niego odwołać
(`@team/agents/<slug>/<slug>.md`).

---

## 3. Zasady nadawania kompetencji

- **Konkretne, nie ogólne.** „Pisze testy E2E w Playwright" — nie „zna się na testach".
- **Weryfikowalne.** Kompetencja musi dać się sprawdzić w efekcie pracy.
- **Niedublujące.** Dwóch agentów nie ma tej samej kluczowej kompetencji. Jeśli zakresy
  się nakładają — to sygnał, że role trzeba scalić albo rozgraniczyć.
<!-- IF_IS_TECHNICAL -->
- **Spójne ze stackiem.** Kompetencje techniczne muszą pasować do stacku z `CLAUDE.md`
  ({{STACK_FRONTEND}}, {{STACK_BACKEND}}, {{STACK_DATABASE}}, {{STACK_AUTH}}).
<!-- /IF_IS_TECHNICAL -->
<!-- IF_IS_NONTECHNICAL -->
- **Spójne z charakterem projektu.** Kompetencje pasują do typu projektu z `CLAUDE.md`
  ({{PROJECT_TYPE}} / {{PRODUCT_TYPE}}, branża: {{INDUSTRY}}).
<!-- /IF_IS_NONTECHNICAL -->
- **Z granicą.** Każdy agent ma jasno opisane, czego **nie** robi — gdzie kończy się
  jego rola i zaczyna handoff do innego agenta.

---

## 4. Szablon karty rekrutacji

PM wypełnia i przedstawia właścicielowi do akceptacji:

```
KARTA REKRUTACJI

Slug:            <kebab-case, np. backend-dev>
Nazwa roli:      <np. Backend Developer>
Zatrudnienie powiązane z zadaniem: <ID lub opis zadania z TASKS.md>

Uzasadnienie:
<dlaczego ta rola jest potrzebna teraz, jakiej luki nie pokrywa obecny zespół>

Kompetencje (konkretne, weryfikowalne):
- <kompetencja 1>
- <kompetencja 2>
- <kompetencja 3>

Zakres odpowiedzialności:
<za co agent odpowiada>

Czego NIE robi (granice roli / handoffy):
<gdzie kończy się rola, do kogo trafia handoff>

Folder roboczy:  team/agents/<slug>/
Skrypt:          team/agents/<slug>/<slug>.md

Decyzja właściciela:   [ ] akceptuję   [ ] zmiany   [ ] odrzucam
```

Szablon karty **zmiany kompetencji** istniejącego agenta — analogicznie, ale zamiast
„Uzasadnienie zatrudnienia" podajesz „Co się zmienia i dlaczego" oraz wskazujesz agenta.

---

## 5. Zwalnianie / archiwizacja agenta

Jeśli rola przestaje być potrzebna — nie usuwasz folderu (praca ma zostać).
Zmieniasz status agenta w `ROSTER.md` na `zarchiwizowany` i odnotowujesz powód.
Decyzję, jak każdą istotną, przedstawiasz właścicielowi.
