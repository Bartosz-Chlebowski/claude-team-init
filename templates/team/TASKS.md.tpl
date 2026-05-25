# TASKS — kolejka zadań {{PROJECT_NAME}}

> Kolejka i status wszystkich zadań. Aktualizuje **wyłącznie** Project Manager.
> Odwołanie: `@team/TASKS.md`

## Statusy

`backlog` → `przypisane` → `w toku` → `code review` → `do odbioru` → `done`
(poboczny: `zablokowane` — z podanym powodem)

Pełny opis cyklu życia zadania: `team/WORKFLOW.md` sekcja 1.

## Priorytety

- `P1` — krytyczny: blokuje inne prace lub pilne dla właściciela. Robione w pierwszej kolejności.
- `P2` — normalny: domyślny priorytet.
- `P3` — niski: do zrobienia, gdy nie ma nic ważniejszego.

---

## Zadania aktywne

| ID | Priorytet | Zadanie | Wykonawca | Status | Zależy od | Uwagi |
|----|-----------|---------|-----------|--------|-----------|-------|
| — | — | — | — | — | — | — |

---

## Zadania zakończone

| ID | Zadanie | Wykonawca | Data done |
|----|---------|-----------|-----------|
| — | — | — | — |

---

## Log zdarzeń

| Data | Zdarzenie |
|------|-----------|
| {{DATE}} | Utworzono strukturę firmy: PM + pliki instrukcyjne. Zespół wykonawczy: pusty. |

---

## Zasady prowadzenia kolejki

- Każde zadanie od właściciela trafia tu jako wpis z unikalnym ID (T1, T2, ...).
- Status zawsze odzwierciedla rzeczywistość — patrz `WORKFLOW.md` sekcja 9.
- Zadanie zablokowane ma podany powód w kolumnie „Uwagi".
- Handoffy między agentami odnotowuje się w logu zdarzeń.
- Zadanie zakończone (`done`) przenosi się do tabeli „Zadania zakończone".
