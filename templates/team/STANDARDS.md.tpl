# Standard pracy — {{PROJECT_NAME}}

> Wspólny standard dla wszystkich agentów. Obowiązuje przy każdym zadaniu.
> Dokument **żywy** — PM po pierwszej sesji proponuje właścicielowi rozbudowę
> pod konkretny projekt (patrz sekcja końcowa).
> Odwołanie: `@team/STANDARDS.md`

Standard ma trzymać jakość i spójność. Założenia projektu: `CLAUDE.md`. Kluczowe
decyzje: `DECISIONS.md` i pliki kierunkowe.

---

## CZĘŚĆ I — Reguły uniwersalne (dla każdej pracy)

### 1. Jakość wyniku

- Każdy wynik (kod, dokument, analiza, materiał) musi być **konkretny i weryfikowalny**.
  Generyczne stwierdzenia bez dowodu — nie liczą się.
- Twierdzenia opierają się na źródle (dane, dokumentacja, doświadczenie, kod, badanie).
  Brak źródła = oznacz wprost jako założenie lub hipotezę.
- Format wyniku zgodny z briefem (długość, struktura, kanał, deadline).

### 2. Organizacja pracy

- Każdy wynik zapisany w **folderze swojego agenta** (`team/agents/<slug>/`).
- Nazwy plików informują o zawartości — bez `final_v3_FINAL.docx`.
- Wersjonowanie przez sufix `-v1`, `-v2`; finalna bez sufixu.
- Pliki współdzielone (w katalogu głównym projektu i w `team/`) modyfikuje PM
  przy odbiorze. Agent proponuje zmianę przez plik w swoim folderze.

### 3. Etyka i odpowiedzialność

- Nie zmyślasz danych, liczb, cytatów, źródeł.
- Plagiat = praca odrzucona. Cudza praca = z atrybucją lub przepisz po swojemu.
- Atrybucja AI: jeśli kanał / klient wymaga oznaczania treści AI — oznacz wyraźnie.
- Nie publikujesz / nie commit-ujesz wyniku, którego sam(a) byś nie podpisał(a) imieniem.

### 4. Bezpieczeństwo i dane

- Sekrety (klucze, hasła, tokeny, dane osobowe) **wyłącznie** w zmiennych środowiskowych
  lub zabezpieczonych vault. Nigdy w kodzie, repo, dokumentach, logach.
- Dane wrażliwe — zgodnie z założeniami projektu z `CLAUDE.md`.
<!-- IF_RODO -->
- RODO/GDPR: dane zgodnie z lokalizacją z `CLAUDE.md` ({{DATA_LOCATION}}).
  Brak wysyłki danych wrażliwych do zewnętrznych procesorów AI.
<!-- /IF_RODO -->

### 5. Definition of Done — bazowy

- Wynik spełnia brief (cel, format, długość, deadline).
- Każde twierdzenie ma podstawę (źródło lub jawnie oznaczone założenie).
- Przejrzane przed oddaniem (no typos, no broken sentences).
- Decyzje kierunkowe odnotowane w `DECISIONS.md`.
- Przeszedł peer review (`WORKFLOW.md` sekcja 7) — jeśli wymagany dla tego typu pracy.

### 6. Czego nie wolno

- Zmyślać danych, liczb, cytatów, źródeł.
- Plagiatu.
- Oddawania wyniku „prawie skończonego" bez raportu o blockerze (zgłaszasz PM).
- Modyfikować plików współdzielonych poza folderem agenta bez PM.
- Pomijać peer review gdy jest wymagany.

---

## CZĘŚĆ II — Moduły domenowe

> Włączone moduły dla **tego** projektu (na podstawie wykrytych domen).
> PM może zaproponować dodanie / usunięcie modułu po pierwszej sesji.

<!-- IF_DOMAIN_SOFTWARE -->
### Moduł SOFTWARE — kod i infrastruktura

**S.1. Język i typowanie**
- <język + tryb (np. TypeScript strict, Python type hints, Rust strict clippy)>. Brak luźnego typowania bez uzasadnienia.
- Typy współdzielone trzymane w jednym miejscu, importowane — nie duplikowane.
- Kod (nazwy zmiennych, funkcji, plików) po angielsku. Treści domenowe widoczne dla
  użytkownika — wg języka produktu. Komentarze — krótko, tylko gdy wyjaśniają „dlaczego".

**S.2. Nazewnictwo**
- Konwencje nazewnicze zgodne ze standardem stacku {{STACK_FRONTEND}} / {{STACK_BACKEND}}.
- Nazwy plików zgodne z konwencją projektu.
<!-- IF_HAS_DB -->
- Tabele i kolumny w bazie: `snake_case`, nazwy w liczbie mnogiej dla tabel.
<!-- /IF_HAS_DB -->
- Nazwy mówią, co rzecz robi — bez skrótów wymagających domysłu.

**S.3. Struktura projektu**
- Trzymaj się jednej, ustalonej struktury katalogów. Konkretny układ to **decyzja
  architektoniczna** — zapada w pliku kierunkowym. Agent nie zmienia struktury
  samowolnie; rozbieżność zgłasza PM.
- Logika biznesowa oddzielona od warstwy UI i od warstwy dostępu do danych.
- Brak „martwego" kodu, zakomentowanych bloków, plików-śmieci.

<!-- IF_MULTITENANT -->
**S.4. Multi-tenant — reguła krytyczna**
Każde zapytanie do bazy musi być filtrowane po `tenant_id`. Brak izolacji =
krytyczny błąd, kod **nie przechodzi** code review.

<!-- /IF_MULTITENANT -->
<!-- IF_HAS_DB -->
**S.5. Baza danych**
- Zmiany schematu wyłącznie przez migracje — nie ręcznie na bazie.
- Surowy SQL tylko gdy ORM realnie nie wystarcza; nigdy z niezabezpieczoną interpolacją.
- Zmiana schematu = aktualizacja pliku kierunkowego ze schematem.
- Baza niedostępna z zewnątrz — tylko przez warstwę API.

<!-- /IF_HAS_DB -->
**S.6. API i walidacja**
- Każdy endpoint waliduje dane wejściowe.
- Jawna obsługa błędów: poprawne kody HTTP, czytelne komunikaty, brak wycieku detali.
- Endpointy chronione przez {{STACK_AUTH}} tam, gdzie wymagają zalogowania;
  sprawdzenie uprawnień <!-- IF_MULTITENANT -->i tenanta <!-- /IF_MULTITENANT -->po stronie serwera.

**S.7. Obsługa błędów i logowanie**
- Błędy obsługiwane jawnie — żadnego cichego połykania wyjątków.
- Logi sensowne, bez danych wrażliwych. Operacje asynchroniczne mają odczytywalny stan.

**S.8. Specyficzne dla kodu „czego nie wolno"**
- Luźne typowanie bez uzasadnienia.
<!-- IF_MULTITENANT -->
- Zapytania do bazy bez izolacji tenanta.
<!-- /IF_MULTITENANT -->
<!-- IF_HAS_DB -->
- Ręczne zmiany schematu bazy z pominięciem migracji.
<!-- /IF_HAS_DB -->
- Zmiana struktury projektu lub założeń architektonicznych bez decyzji w pliku kierunkowym.

**S.9. DoD dla kodu**
Obowiązuje DoD bazowy + zgodność z tym modułem + przeszedł code review.
Kod łamiący S.<!-- IF_MULTITENANT -->4 (multi-tenant), <!-- /IF_MULTITENANT -->S.6 (auth) lub S.8 — **nie przechodzi** review.

<!-- /IF_DOMAIN_SOFTWARE -->
<!-- IF_DOMAIN_CONTENT -->
### Moduł CONTENT — treści publikowane

**C.1. Brief jako kontrakt**
Każdy materiał ma jasny brief: cel, target, format, długość, kanał, deadline,
tone of voice. Bez briefu nie startujesz pisania — pytasz PM. Brief żyje w
folderze agenta razem z wynikiem.

**C.2. Źródła i fact-checking**
- Każde nieoczywiste stwierdzenie ma podane źródło (link, dokument, autor).
- Cytaty dosłowne — w cudzysłowie z podaniem źródła. Parafrazy — z atrybucją.
- Liczby, daty, nazwy własne, dane techniczne — zweryfikowane przed publikacją.

**C.3. Struktura tekstu**
- Hook na początku — czytelnik decyduje w 3 sekundy czy zostaje.
- Cel / kontekst → treść właściwa → wnioski / CTA.
- Nagłówki opisują zawartość sekcji.
- Długie teksty mają TL;DR / spis treści.
- Brak „lania wody" — każda sekcja niesie wartość.

**C.4. Tone of voice i brand**
- Trzymaj się ustalonego tone of voice (jeśli zdefiniowany w pliku kierunkowym).
- Terminologia spójna w całym projekcie.
- Nie kopiujesz cudzego stylu bez akceptacji właściciela.

**C.5. SEO i optymalizacja (jeśli dotyczy kanału)**
- Tytuł, meta description, URL, nagłówki H1-H3 — zgodne z briefem SEO.
- Słowa kluczowe wplecione naturalnie, bez keyword stuffing.

**C.6. DoD dla materiału**
Bazowy DoD + brief spełniony + peer review przeszedł + format gotowy do publikacji.

<!-- /IF_DOMAIN_CONTENT -->
<!-- IF_DOMAIN_RESEARCH -->
### Moduł RESEARCH — badania i analizy

**R.1. Metodologia jawna**
Każde badanie startuje od jawnej metodologii: cele, hipotezy, populacja docelowa,
metoda zbierania danych, próba (rozmiar, kryteria), analiza, ograniczenia.
Metodologia spisana **przed** zbieraniem danych. Zmiana w trakcie = decyzja
kierunkowa do akceptacji właściciela.

**R.2. Reprezentatywność i bias**
- Próba dostosowana do celu badania (eksploracja vs walidacja vs ranking).
- Świadomość biasów: selekcji, samowyboru, framing-u pytań, anchoring-u.
- W raporcie zawsze sekcja „Ograniczenia próby" — szczerze, nie obronnie.
- Rozróżnienie korelacja vs przyczynowość.

**R.3. Konstrukcja narzędzia (ankieta / wywiad / obserwacja)**
- Pytania neutralne, niesugestywne.
- Pre-test narzędzia na minimum 3-5 osobach przed deploymentem.
- Pytania otwarte przed zamkniętymi (Stage 1 → Stage 2) gdy eksploracyjnie.

**R.4. Zbieranie i przechowywanie danych**
- Wszystkie surowe dane zachowane (z timestampami, ID respondentów anonimizowanymi).
- Audyt trail: kto kiedy zebrał, z którego kanału, jakim narzędziem.
<!-- IF_RODO -->
- Zgody RODO/GDPR — w przypadku PL: dwa opt-iny (zgoda na przetwarzanie + zgoda
  marketingowa, jeśli aplikuje).
<!-- /IF_RODO -->

**R.5. Analiza i wnioski**
- Analiza opisana metodologicznie.
- Statystyki istotne podane z p-value lub przedziałem ufności jeśli próba pozwala.
- Wnioski rozdzielone od interpretacji.
- Anty-pattern: cherry-picking — nie wybierasz danych pasujących do tezy.

**R.6. Specyficzne dla research „czego nie wolno"**
- Wyciągać wniosków poza próbę.
- Manipulować pytaniami żeby uzyskać oczekiwaną odpowiedź.
- Pomijać niewygodnych danych z raportu.
- Mylić eksploracji z walidacją (i odwrotnie).

**R.7. DoD dla raportu**
Bazowy DoD + pełna metodologia + surowe dane zachowane + wnioski rozdzielone od
interpretacji + peer review (drugi badacz zaakceptował metodologię i wnioski).

<!-- /IF_DOMAIN_RESEARCH -->
<!-- IF_DOMAIN_MARKETING -->
### Moduł MARKETING — kampanie i lead-gen

**M.1. KPI przed startem**
Każda kampania startuje od jasnych KPI — co mierzymy, jakim narzędziem, jaki cel.
Brak KPI = nie startujesz. KPI spisane w briefie, przeglądane po zakończeniu.

**M.2. Atrybucja i tracking**
- Każdy link wychodzący ma UTM (source, medium, campaign, content).
- Konwersje śledzone: w analytics, CRM, pixel.
- Atrybucja jasna: ostatni klik / multi-touch / data-driven — wybór ustalony per kampania.
- Brak trackingu = nie odpalasz kampanii.

**M.3. Brand consistency**
- Wszystkie materiały zgodne z brand guidelines (logo, kolory, typografia, tone).
- Komunikat spójny z pozycjonowaniem produktu.
- Asset peer review przed publikacją.

**M.4. Testowanie**
- Hipoteza testowa wyraźnie postawiona.
- A/B testy: jeden zmieniony element naraz, próba statystycznie sensowna.
- Wyniki testów zapisane.

**M.5. Lejek i journey**
- Każda aktywność świadomie umiejscowiona w lejku (TOFU / MOFU / BOFU).
- CTA dostosowane do etapu.
- Customer journey przemyślany.

**M.6. Compliance i budżet**
<!-- IF_RODO -->
- Lista mailingowa zgodna z RODO.
<!-- /IF_RODO -->
- Reklamy zgodne z politykami platform.
- Brak dark patterns.
- Każde wydanie powyżej progu (z `CLAUDE.md`) wymaga akceptacji właściciela.

**M.7. DoD dla kampanii**
Bazowy DoD + KPI spełnione (lub jawnie raportowane) + tracking działa + materiały
peer review + raport po-kampanijny w `DECISIONS.md`.

<!-- /IF_DOMAIN_MARKETING -->
<!-- IF_DOMAIN_OPERATIONS -->
### Moduł OPERATIONS — procesy biznesowe

**O.1. Każdy proces ma właściciela**
Każdy proces operacyjny ma jednego nazwanego właściciela (RACI: Responsible).
Brak właściciela = proces nie startuje.

**O.2. Dokumentacja procesu**
- Każdy działający proces ma SOP (Standard Operating Procedure) — krok po kroku.
- SOP czytelny dla nowej osoby (osoba spoza zespołu rozumie w 15 min).
- Wersjonowanie SOP: data, autor, powód zmiany.

**O.3. SLA i terminowość**
- Każdy proces ma deklarowany SLA jeśli ma odbiorcę.
- Naruszenia SLA śledzone — log incydentów.
- Plan recovery dla każdego krytycznego procesu.

**O.4. RACI**
Dla każdego znaczącego zadania rozpisz RACI:
- **R**esponsible — kto fizycznie wykonuje
- **A**ccountable — kto odpowiada za wynik (jedna osoba)
- **C**onsulted — z kim konsultujemy przed decyzją
- **I**nformed — kogo informujemy o wyniku

**O.5. Handoffy**
- Handoff między procesami = jawny artefakt (ticket, dokument), nie ustny.
- Brak handoffu = brak przekazania odpowiedzialności.

**O.6. Pomiary i continuous improvement**
- Każdy znaczący proces ma metrykę zdrowia.
- Po incydencie — retrospekcja (co, dlaczego, co zmieniamy). Bez blame culture.

**O.7. DoD dla procesu / playbooka**
Bazowy DoD + SOP kompletny + właściciel nazwany + RACI rozpisane + SLA jeśli aplikuje +
plan recovery jeśli krytyczny + peer review.

<!-- /IF_DOMAIN_OPERATIONS -->

---

## CZĘŚĆ III — Rozbudowa standardu

**Ten plik jest startem, nie końcem.** Wygenerowane moduły pokrywają typowe domeny,
ale **każdy projekt ma swoją specyfikę** — branżową regulację, klienta z własnym
style guide, unikalny proces. PM ma za zadanie:

1. **Po pierwszej sesji z właścicielem** — przejrzeć ten plik, zidentyfikować luki
   specyficzne dla tego konkretnego projektu (nie ogólne).
2. **Zaproponować konkretne sekcje custom** — np. „M.8 — compliance dla SaaS w UE
   wymaga prerejestracji w X", „C.7 — klient wymaga publikacji w godzinach 8-10 CET",
   „R.8 — badanie regulowane przez UODO i wymaga konsultacji z IOD".
3. **Po akceptacji właściciela** — sam zapisać sekcje do tego pliku oraz wpis w
   `DECISIONS.md`.

Sekcje custom są **częścią modułów** (numerowane w obrębie modułu) lub osobnymi
sekcjami w **Części IV — Custom dla tego projektu** którą PM tworzy gdy potrzeba.

Standardy domenowe powyżej są **inspiracją i bazą** — nie zamykają tematu.
