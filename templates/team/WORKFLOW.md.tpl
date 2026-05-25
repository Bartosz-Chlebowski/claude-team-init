# Zasady pracy zespołu — {{PROJECT_NAME}}

> Reguły delegacji, równoległości, handoffów i odbioru pracy. Obowiązują PM i wszystkich agentów.
> Odwołanie: `@team/WORKFLOW.md`

---

## 1. Cykl życia zadania

Każde zadanie przechodzi przez statusy (odzwierciedlone w `TASKS.md`):

```
backlog → przypisane → w toku → code review → do odbioru → done
                            ↘    zablokowane    ↗
```

- **backlog** — zadanie zapisane, jeszcze nieprzypisane.
- **przypisane** — ma wykonawcę, czeka na start (np. blokuje je inne zadanie).
- **w toku** — agent pracuje.
- **code review** — efekt gotowy, recenzuje go inny agent niż autor (sekcja 7).
  Dotyczy zadań z kodem; dla zadań bez kodu ten etap się pomija.
- **zablokowane** — czeka na coś (handoff, decyzję właściciela, inne zadanie). Powód zapisany.
- **do odbioru** — recenzja przeszła, PM sprawdza całość względem Definition of Done.
- **done** — odebrane przez PM, spełnia DoD.

PM aktualizuje statusy. Żadne zadanie nie znika „po cichu" — albo done, albo z powodem.

---

## 2. Reguły delegacji

- Jedno podzadanie = jeden agent odpowiedzialny. Współpraca jest możliwa, ale
  odpowiedzialność za wynik jest pojedyncza.
- PM dobiera wykonawcę po kompetencjach z `ROSTER.md`, nie po dostępności.
- Brief delegowanego zadania (czy w trybie wcielenia, czy subagenta) zawsze zawiera:
  zadanie, Definition of Done, folder roboczy agenta, pliki do przeczytania, format wyniku.
- Zależności są jawne: jeśli zadanie B potrzebuje wyniku A, B startuje dopiero po
  odbiorze A (lub po jawnym handoffie częściowym).
- **Dobór modelu subagenta.** PM (lub agent delegujący podzadanie) dobiera
  model AI subagenta do wagi zadania, nie odpala wszystkiego na maksimum:
  - **Opus** — zadania strategiczne lub krytyczne: planowanie wieloetapowe,
    decyzje architektoniczne, pełne analizy, recenzje kodu krytycznego dla
    bezpieczeństwa, rozumowanie na długim kontekście.
  - **Sonnet** — domyślny wybór: pisanie kodu, redakcja dokumentów wg
    konkretnych instrukcji, code review standardowy, typowy research.
  - **Haiku** — zadania proste i mechaniczne: lookupy, formatowanie, drobne
    poprawki, walidacja danych po jasnym schemacie.

  W briefie subagenta jedno zdanie uzasadniające wybór modelu. Gdy wątpliwość
  Opus vs Sonnet — Sonnet. Gdy wątpliwość Sonnet vs Haiku — Sonnet.
  **PM sam działa zawsze na Opus MAX effort** — to stała jego roli, {{OWNER_NAME}}
  odpala go z premedytacją na maksymalnej mocy.

---

## 3. Równoległość i izolacja folderów

Wielu agentów może pracować **jednocześnie** — pod warunkiem izolacji:

- Każdy agent ma swój folder: `team/agents/<slug>/`.
- Agent zapisuje **wyłącznie** w swoim folderze. Nigdy w folderze innego agenta.
- Pliki robocze, notatki, wersje robocze, outputy — wszystko u siebie.
- Dzięki temu dwa subagenty uruchomione równolegle nie nadpiszą sobie nawzajem pracy.

Gdy zadania są niezależne — PM może je zlecić równolegle (kilku subagentów naraz).
Gdy zależne — szereguje je wg zależności.

---

## 4. Pliki współdzielone

Pliki **poza** folderami agentów są współdzielone. Należą do nich m.in.:
<!-- IF_IS_TECHNICAL -->kod projektu, <!-- /IF_IS_TECHNICAL -->dokumentacja w katalogu głównym (`CLAUDE.md` oraz pliki kierunkowe),
`ROSTER.md`, `TASKS.md`<!-- IF_IS_NONTECHNICAL -->, materiały finalne projektu<!-- /IF_IS_NONTECHNICAL -->.

Reguły:
- **Nigdy dwóch agentów naraz** nie modyfikuje tego samego pliku współdzielonego.
- Modyfikacja pliku współdzielonego odbywa się jako jawny krok pod nadzorem PM —
  najczęściej PM scala wynik pracy agenta do pliku współdzielonego przy odbiorze.
- Agent, który chce zmienić plik współdzielony, **proponuje zmianę w swoim folderze**
  (np. jako diff lub fragment), a PM ją integruje. To eliminuje konflikty.
- `ROSTER.md` i `TASKS.md` aktualizuje **tylko PM**.

---

## 5. Handoffy między agentami

Gdy wynik jednego agenta jest wejściem dla drugiego:

1. Agent A kończy, oznacza zadanie „do odbioru", zostawia wynik w swoim folderze.
2. PM odbiera pracę A (sprawdza DoD).
3. PM przekazuje agentowi B lokalizację wyniku A jako materiał wejściowy
   (B czyta z folderu A, ale **nie pisze** w nim — pisze u siebie).
4. PM zapisuje fakt handoffu w `TASKS.md`.

Handoff zawsze przechodzi przez PM. Agenci nie „dogadują się" między sobą bezpośrednio —
PM jest punktem koordynacji.

---

## 6. Definition of Done

Zadanie jest `done`, gdy spełnia kryteria odbioru. Domyślne DoD wg typu pracy:

<!-- IF_IS_TECHNICAL -->
**Kod:**
- działa i robi to, co miał robić; spójny ze stackiem i strukturą projektu,
- bez oczywistych błędów; jeśli zakres obejmuje testy — testy przechodzą,
- istotne decyzje architektoniczne odnotowane w `DECISIONS.md` i właściwym pliku MD.

<!-- /IF_IS_TECHNICAL -->
**Dokument / analiza / treść:**
- odpowiada na pełen zakres zadania, konkretny i weryfikowalny,
- zapisany jako plik w folderze agenta we właściwym formacie,
- źródła/założenia podane tam, gdzie to istotne.

**Decyzja / research:**
- jasna rekomendacja + uzasadnienie + odrzucone alternatywy,
- gotowa do wpisania do `DECISIONS.md` w formacie z `CLAUDE.md`.

<!-- IF_IS_NONTECHNICAL -->
**Materiał publikowany (artykuł, post, prezentacja, raport zewnętrzny):**
- zgodny z briefem (cel, długość, format, kanał),
- przeszedł peer review (sekcja 7) — drugi agent zaakceptował,
- gotowy do publikacji bez dalszych korekt redakcyjnych.

<!-- /IF_IS_NONTECHNICAL -->
PM może zaostrzyć DoD dla konkretnego zadania — wtedy podaje je w briefie.
Zadanie, które nie spełnia DoD, **nie jest** raportowane jako zrobione — wraca do agenta.

---

## 7. Peer review

Praca wymagająca oceny merytorycznej (kod, dokument kierunkowy, materiał publikowany)
nie idzie do odbioru PM bez recenzji innej osoby niż autor. Reguły:

- **Recenzuje inny agent niż autor.** Autor nie recenzuje własnej pracy. Recenzent ma
  kompetencję pozwalającą ocenić dany typ wyniku — PM go dobiera (dedykowany
  reviewer/QA albo inny agent z pasującą kompetencją).
- Recenzent sprawdza pracę względem `team/STANDARDS.md` oraz Definition of Done (sekcja 6).
  Złamanie reguł krytycznych ze `STANDARDS.md` (sekcja „czego nie wolno") = recenzja
  **odrzucona**, praca wraca do autora.
- Recenzent **czyta** wynik w folderze autora, uwagi zapisuje **u siebie** — nie edytuje
  cudzego folderu. Poprawki nanosi autor.
- Recenzja kończy się jednoznacznie: `zaakceptowane` albo `do poprawy` + lista uwag.
- Dopiero `zaakceptowane` przesuwa zadanie do statusu „do odbioru" u PM.
- Recenzja to nie odbiór PM — PM nadal sprawdza całość zadania względem DoD. To dwa
  osobne etapy: recenzja ocenia jakość, odbiór PM — czy zadanie spełnia cel.

PM decyduje, które zadania wymagają peer review — typowo: <!-- IF_IS_TECHNICAL -->kod, <!-- /IF_IS_TECHNICAL -->dokumenty
kierunkowe (`CLAUDE.md`, pliki kierunkowe), materiały finalne wychodzące na zewnątrz.
Drobne zadania robocze (notatki, intermediate outputs) — bez review, sprawdza PM przy odbiorze.

## 8. Blockery

Agent, który napotka blocker, natychmiast zgłasza go PM (status `zablokowane` + powód).
PM nie chowa blockerów — eskaluje je do właściciela z propozycją rozwiązania.
Zadanie zablokowane nie jest „w toku" — status musi być prawdziwy.

---

## 9. Zasada prawdziwości statusów

Statusy w `TASKS.md` i raporty PM muszą odzwierciedlać rzeczywistość.
Nie ma „prawie done", „chyba działa", „zrobione" bez spełnienia DoD.
Lepszy szczery status `zablokowane` niż fałszywy `done`.

---

## 10. Uczenie się i edycja skryptów

Pracownicy (agenci + PM) **uczą się na błędach i realnych sytuacjach** — to
oczekiwana część pracy. Każdy może (i powinien) zbierać obserwacje, insighty
i propozycje rozszerzenia własnych kompetencji w toku pracy.

**Reguła krytyczna:** żaden agent nie edytuje samodzielnie własnego skryptu
(`team/agents/<slug>/<slug>.md` lub `team/PROJECT_MANAGER.md` w przypadku PM).
Skrypty edytuje **wyłącznie PM**, po przedstawieniu właścicielowi konkretnej propozycji
treści i otrzymaniu akceptacji.

Mechanika:
1. Agent zbiera lessons w pliku `team/agents/<slug>/LESSONS.md` (lub w sekcji
   „Lessons learned" raportu końcowego etapu).
2. PM przy odbiorze pracy zerka do `LESSONS.md`, ocenia, czy wpis jest wart
   utrwalenia w skrypcie (czy konkretny, weryfikowalny, nieduplikujący).
3. Jeśli tak — PM formułuje propozycję zmiany skryptu (dokładne brzmienie
   linii / sekcji do dodania lub zmiany) i przedstawia właścicielowi.
4. {{OWNER_NAME}} akceptuje → PM zapisuje. {{OWNER_NAME}} odrzuca → wpis zostaje w `LESSONS.md`
   jako log historyczny (nie znika).

Dla samego PM analogicznie: PM zbiera własne lessons dotyczące swojego skryptu,
proponuje właścicielowi konkretne brzmienie, po akceptacji sam zapisuje. Nikt poza
PM nie edytuje `PROJECT_MANAGER.md`.

Skrypt agenta to **kontrakt** — opisuje kompetencje i granice roli, na
podstawie których PM zatrudnia i odbiera pracę. Dlatego nie zmienia się go
bez kontroli.
