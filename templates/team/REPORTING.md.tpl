# Raportowanie — {{PROJECT_NAME}}

> Formaty raportów PM oraz karty rekrutacji. Używa Project Manager.
> Odwołanie: `@team/REPORTING.md`

---

## 1. Raport z zakończonego zadania

PM przedstawia właścicielowi po odebraniu zadania (lub jego dużego etapu):

```
RAPORT — <tytuł zadania>          [data: YYYY-MM-DD]

Status:        done / częściowo / zablokowane
Wykonawcy:     <agent(ci), którzy realizowali>

Co zrobiono:
<konkretnie, co powstało — z lokalizacją plików>

Wynik / efekt:
<co {{OWNER_NAME}} z tego ma, gdzie to jest, jak sprawdzić>

Decyzje podjęte:
<istotne decyzje + czy trafiły do DECISIONS.md>

Blockery / ryzyka:
<co stoi na drodze, jeśli coś>

Następne kroki:
<co proponujesz dalej>

Do akceptacji właściciela:
<jeśli coś wymaga decyzji — wypunktuj jasno>
```

Jeśli raport nie wymaga niczego od właściciela — sekcję „Do akceptacji" pomiń.

---

## 2. Status okresowy / przegląd projektu

Na żądanie właściciela („jak stoimy", „co się dzieje"):

```
STATUS PROJEKTU          [data: YYYY-MM-DD]

W toku:        <zadania + agenci>
Do odbioru:    <zadania czekające na sprawdzenie>
Zablokowane:   <zadania + powód>
Backlog:       <ile zadań czeka>

Zespół:        <liczba aktywnych agentów + role>

Uwagi PM:
<co warto wiedzieć — ryzyka, propozycje, rekomendacje>
```

---

## 3. Plan zadania do akceptacji

Zanim PM zacznie delegować większe zadanie:

```
PLAN — <tytuł zadania>

Rozbicie na podzadania:
1. <podzadanie> → <agent / rola> → <zależności>
2. ...

Potrzebne zatrudnienia:
<karty rekrutacji, jeśli są — patrz HIRING.md>

Tryb wykonania:
<które podzadania równolegle, które szeregowo>

Do akceptacji właściciela:
[ ] rozbicie i przypisania   [ ] zatrudnienia   [ ] start
```

---

## 4. Karta rekrutacji

Pełny szablon karty rekrutacji znajduje się w `team/HIRING.md`, sekcja 4.
PM używa go za każdym razem, gdy proponuje zatrudnienie — i przedstawia właścicielowi
razem z planem zadania albo osobno.

---

## 5. Zasady raportowania

- Krótko i konkretnie. {{OWNER_NAME}} woli zwięzłe raporty bez lania wody.
- Statusy prawdziwe — patrz `WORKFLOW.md` sekcja 9. Nie ma „prawie done".
- Każdy raport wskazuje **lokalizację plików** — żeby {{OWNER_NAME}} mógł sam sprawdzić.
- Decyzje do akceptacji zawsze wyodrębnione, nie schowane w tekście.
- Markdown i nagłówki tylko gdy raport tego wymaga — krótki status to kilka zdań.
