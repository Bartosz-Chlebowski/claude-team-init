# Standard pracy — {{PROJECT_NAME}}

> Wspólny standard dla wszystkich agentów. Obowiązuje przy każdym zadaniu.
> Dokument żywy — aktualizuje go PM po akceptacji właściciela (patrz `PROJECT_MANAGER.md` sekcja 7).
> Odwołanie: `@team/STANDARDS.md`

Standard ma trzymać jakość i spójność: każdy agent pracuje tak, jakby pracował jeden zespół.
Założenia projektu: `CLAUDE.md`. Kluczowe decyzje: `DECISIONS.md` i pliki kierunkowe.

---

<!-- IF_IS_TECHNICAL -->
## 1. Język i typowanie

- <język + tryb (np. TypeScript strict, Python type hints, Rust strict clippy)>. Brak luźnego typowania bez uzasadnienia.
- Typy współdzielone trzymane w jednym miejscu, importowane — nie duplikowane.
- Kod (nazwy zmiennych, funkcji, plików) po angielsku. Treści domenowe widoczne dla
  użytkownika — wg języka produktu. Komentarze — krótko, tylko gdy wyjaśniają „dlaczego".

## 2. Nazewnictwo

- Konwencje nazewnicze zgodne ze standardem stacku {{STACK_FRONTEND}} / {{STACK_BACKEND}}.
- Nazwy plików zgodne z konwencją projektu (PascalCase dla komponentów, kebab-case dla modułów, itp.).
<!-- IF_HAS_DB -->
- Tabele i kolumny w bazie: `snake_case`, nazwy w liczbie mnogiej dla tabel.
<!-- /IF_HAS_DB -->
- Nazwy mówią, co rzecz robi — bez skrótów wymagających domysłu.

## 3. Struktura projektu

- Trzymaj się jednej, ustalonej struktury katalogów. Konkretny układ to **decyzja
  architektoniczna** — zapada w odpowiednim pliku kierunkowym. Agent nie zmienia
  struktury samowolnie; rozbieżność zgłasza PM.
- Logika biznesowa oddzielona od warstwy UI i od warstwy dostępu do danych.
- Brak „martwego" kodu, zakomentowanych bloków, plików-śmieci w repo.

<!-- IF_MULTITENANT -->
## 4. Multi-tenant — reguła krytyczna

Produkt obsługuje wielu klientów na jednej instancji. **Każde** zapytanie do bazy
musi być filtrowane po `tenant_id`. Nigdy nie ma zapytania, które sięga
danych globalnie bez izolacji tenanta. To nie jest opcja — to warunek bezpieczeństwa.
Brak izolacji tenanta = krytyczny błąd, zadanie nie przechodzi code review.

<!-- /IF_MULTITENANT -->
<!-- IF_HAS_DB -->
## 5. Baza danych

- Zmiany schematu wyłącznie przez migracje — nie ręcznie na bazie.
- Surowy SQL tylko gdy ORM realnie nie wystarcza, z uzasadnieniem; nigdy
  z niezabezpieczoną interpolacją danych wejściowych.
- Zmiana schematu = aktualizacja pliku kierunkowego ze schematem (pilnuje PM przy odbiorze).
- Baza niedostępna z zewnątrz — dostęp tylko przez warstwę API.

<!-- /IF_HAS_DB -->
## 6. API i walidacja

- Każdy endpoint waliduje dane wejściowe, zanim ich użyje.
- Jawna obsługa błędów: poprawne kody HTTP, czytelne komunikaty, brak wycieku
  szczegółów technicznych do użytkownika.
- Endpointy chronione przez {{STACK_AUTH}} tam, gdzie wymagają zalogowania; sprawdzenie
  uprawnień <!-- IF_MULTITENANT -->i tenanta <!-- /IF_MULTITENANT -->po stronie serwera, nigdy tylko po stronie klienta.

## 7. Bezpieczeństwo<!-- IF_RODO --> i RODO<!-- /IF_RODO -->

<!-- IF_RODO -->
- Dane zgodnie z lokalizacją z `CLAUDE.md` ({{DATA_LOCATION}}). Zakaz wysyłania
  danych wrażliwych do zewnętrznych procesorów AI poza naszą infrastrukturą.
<!-- /IF_RODO -->
- Sekrety (klucze, hasła, tokeny) wyłącznie w zmiennych środowiskowych —
  nigdy w kodzie ani w repo.
- Dane wrażliwe nie trafiają do logów.

## 8. Obsługa błędów i logowanie

- Błędy obsługiwane jawnie — żadnego cichego połykania wyjątków.
- Logi sensowne i bez danych wrażliwych. Operacje asynchroniczne muszą mieć
  odczytywalny stan (sukces/błąd).

## 9. Czego nie wolno

- Luźne typowanie bez uzasadnienia.
<!-- IF_MULTITENANT -->
- Zapytania do bazy bez izolacji tenanta.
<!-- /IF_MULTITENANT -->
- Sekrety w kodzie lub repo.
<!-- IF_RODO -->
- Wysyłka danych wrażliwych do zewnętrznych usług AI / procesorów niezgodnych z {{DATA_LOCATION}}.
<!-- /IF_RODO -->
<!-- IF_HAS_DB -->
- Ręczne zmiany schematu bazy z pominięciem migracji.
<!-- /IF_HAS_DB -->
- Zmiana struktury projektu lub założeń architektonicznych bez decyzji w pliku kierunkowym.
- Zostawianie martwego/zakomentowanego kodu.

## 10. Definition of Done dla kodu

Obowiązuje DoD z `WORKFLOW.md` sekcja 6 (kod) plus zgodność z tym standardem.
Kod łamiący sekcję <!-- IF_MULTITENANT -->4, <!-- /IF_MULTITENANT -->7 lub 9 **nie przechodzi** code review — wraca do autora.
<!-- /IF_IS_TECHNICAL -->
<!-- IF_IS_CONTENT -->
## 1. Brief jako kontrakt

Każdy materiał ma jasny brief: cel, target, format, długość, kanał, deadline,
tone of voice. Bez briefu nie startujesz pisania — pytasz PM. Brief żyje w
folderze agenta, zachowany razem z wynikiem.

## 2. Źródła i fact-checking

- Każde nieoczywiste stwierdzenie ma podane źródło (link, dokument, autor).
- Cytaty dosłowne — w cudzysłowie z podaniem źródła. Parafrazy — z atrybucją.
- Liczby, daty, nazwy własne, dane techniczne — zweryfikowane przed publikacją.
- W razie wątpliwości — sprawdź drugi raz, nie zgaduj.
- Źródła wymienione na końcu materiału lub w przypisach (zależnie od formatu).

## 3. Struktura tekstu

- Hook na początku — czytelnik decyduje w 3 sekundy czy zostaje.
- Cel / kontekst → treść właściwa → wnioski / CTA.
- Nagłówki opisują zawartość sekcji.
- Długie teksty mają TL;DR / spis treści.
- Brak „lania wody" — każda sekcja niesie wartość.
- Format wizualny dostosowany do kanału (długość akapitów, listy, embed).

## 4. Tone of voice i brand

- Trzymaj się ustalonego tone of voice (jeśli zdefiniowany — w pliku kierunkowym).
- Terminologia spójna w całym projekcie — nie zmieniaj nazw w połowie.
- Nie kopiujesz cudzego stylu bez akceptacji właściciela.

## 5. SEO i optymalizacja (jeśli dotyczy kanału)

- Tytuł, meta description, URL, nagłówki H1-H3 — zgodne z briefem SEO jeśli go ma.
- Słowa kluczowe wplecione naturalnie, bez keyword stuffing.
- Long-tail i intent-driven, nie tylko volume.

## 6. AI i etyka

- Atrybucja AI: jeśli treść jest generowana przez AI i kanał / klient tego wymaga —
  oznacz wyraźnie. Nie udawaj że nie używałeś.
- Nie publikuj treści dyskryminujących, mylących, manipulacyjnych, clickbait bez pokrycia.
- Nie kopiujesz fragmentów z innych źródeł bez atrybucji (plagiat = praca odrzucona).

## 7. Czego nie wolno

- Zmyślać liczb, dat, cytatów, autorów, źródeł.
- Plagiatu — kopiowania cudzej pracy bez atrybucji.
- Publikować materiałów nieprzeczytanych na głos / nieprzejrzanych (typos, broken sentences).
- Zmieniać tone of voice projektu bez akceptacji właściciela.
- Tworzyć treści, których sam(a) byś nie podpisał(a) imieniem.

## 8. Definition of Done dla materiału

- Brief spełniony (cel, format, długość, deadline).
- Każde twierdzenie ma podstawę (źródło lub jawnie oznaczone założenie).
- Tekst przeszedł peer review (sekcja `WORKFLOW.md` 7) — drugi agent zaakceptował.
- Format gotowy do publikacji bez dalszych korekt redakcyjnych.
- Decyzje kierunkowe (np. wybór kąta, persony) odnotowane w `DECISIONS.md`.
<!-- /IF_IS_CONTENT -->
<!-- IF_IS_RESEARCH -->
## 1. Metodologia jawna

Każde badanie startuje od jawnej metodologii: cele, hipotezy, populacja docelowa,
metoda zbierania danych, próba (rozmiar, kryteria), analiza, ograniczenia.
Metodologia spisana **przed** zbieraniem danych, w pliku kierunkowym lub folderze
agenta. Zmiana metodologii w trakcie = decyzja kierunkowa do akceptacji właściciela.

## 2. Reprezentatywność i bias

- Próba dostosowana do celu badania (eksploracja vs walidacja vs ranking).
- Świadomość biasów: selekcji, samowyboru, framing-u pytań, anchoring-u.
- W raporcie zawsze sekcja „Ograniczenia próby" — szczerze, nie obronnie.
- Rozróżnienie korelacja vs przyczynowość.

## 3. Konstrukcja narzędzia (ankieta / wywiad / obserwacja)

- Pytania neutralne, niesugestywne (unikać „Czy zgadzasz się że X?" — preferować „Co sądzisz o X?").
- Pre-test narzędzia na minimum 3-5 osobach przed deploymentem.
- Branching logiczny opisany w dokumentacji.
- Pytania otwarte przed zamkniętymi (Stage 1 → Stage 2) gdy badamy eksploracyjnie.

## 4. Zbieranie danych

- Wszystkie surowe dane zachowane (z timestampami, ID respondentów anonimizowanymi).
- Audyt trail: kto kiedy zebrał, z którego kanału, jakim narzędziem.
- Zgody RODO/GDPR — w przypadku PL: dwa opt-iny (zgoda na przetwarzanie + zgoda
  marketingowa, jeśli aplikuje).

## 5. Analiza i wnioski

- Analiza opisana metodologicznie (jakie testy, jakie progi, jakie cross-taby).
- Statystyki istotne podane z p-value lub przedziałem ufności jeśli próba na to pozwala.
- Wnioski rozdzielone od interpretacji — najpierw co dane mówią, potem co Twoim zdaniem to oznacza.
- Anty-pattern: cherry-picking — nie wybierasz danych pasujących do tezy.

## 6. Cytowanie i źródła

- Każda liczba ma źródło (własne dane, raport, baza danych).
- Cudze badania cytowane z autorem, datą, metodą.
- Brak źródła = jawnie oznaczone jako „obserwacja własna" lub „hipoteza".

## 7. Czego nie wolno

- Wyciągać wniosków poza próbę (n=10 → „Polacy uważają że…").
- Manipulować pytaniami żeby uzyskać oczekiwaną odpowiedź.
- Pomijać niewygodnych danych z raportu.
- Stosować skali pomiarowej nieadekwatnej do typu zmiennej.
- Mylić eksploracji z walidacją (i odwrotnie).

## 8. Definition of Done dla raportu badawczego

- Metodologia opisana w pełni (cel, hipotezy, próba, narzędzie, analiza, ograniczenia).
- Surowe dane zachowane, dostępne do weryfikacji.
- Wnioski rozdzielone od interpretacji.
- Peer review (sekcja `WORKFLOW.md` 7) — drugi badacz zaakceptował metodologię i wnioski.
- Raport gotowy do prezentacji właścicielowi / klientowi.
<!-- /IF_IS_RESEARCH -->
<!-- IF_IS_MARKETING -->
## 1. KPI przed startem

Każda kampania / aktywność marketingowa startuje od jasnych KPI — co mierzymy,
jakim narzędziem, jaki cel (liczba lub %). Brak KPI = nie startujesz. KPI spisane
w briefie kampanii, przeglądane po zakończeniu.

## 2. Atrybucja i tracking

- Każdy link wychodzący ma UTM (source, medium, campaign, content).
- Konwersje śledzone: w analytics, CRM, pixel. Audyt na starcie.
- Atrybucja jasna: ostatni klik / multi-touch / data-driven — wybór ustalony per kampania.
- Brak trackingu = nie wiesz czy działa. Nie odpalasz kampanii bez setupu trackingu.

## 3. Brand consistency

- Wszystkie materiały zgodne z brand guidelines (logo, kolory, typografia, tone).
- Komunikat spójny z pozycjonowaniem produktu — nie obiecujesz tego, czego produkt nie spełnia.
- Każdy asset peer review przed publikacją: redaktor / copywriter / brand owner.

## 4. Testowanie

- Hipoteza testowa wyraźnie postawiona: „X wygeneruje więcej konwersji niż Y bo Z".
- A/B testy: jeden zmieniony element naraz, próba statystycznie sensowna.
- Wyniki testów zapisane (co testowaliśmy, jaki wynik, co teraz robimy).

## 5. Lejek i journey

- Każda aktywność świadomie umiejscowiona w lejku (TOFU / MOFU / BOFU).
- CTA dostosowane do etapu — nie sprzedajesz w treści edukacyjnej TOFU.
- Customer journey przemyślany: co user robi po kliku w naszym materiale.

## 6. Compliance i etyka

<!-- IF_RODO -->
- Lista mailingowa zgodna z RODO: zgoda opt-in, możliwość rezygnacji, dane zgodnie z lokalizacją z `CLAUDE.md`.
<!-- /IF_RODO -->
- Reklamy zgodne z politykami platform (Meta, Google Ads, LinkedIn — każda ma swoje reguły).
- Brak dark patterns w komunikacji (np. fałszywe deadliny, sztuczne ograniczenia).
- Atrybucja AI: jeśli kreacja generowana przez AI i platforma / klient wymaga — oznacz.

## 7. Budżet i wydatki

- Każde wydanie powyżej progu (ustalony w `CLAUDE.md`) wymaga akceptacji właściciela.
- Wydatki śledzone: gdzie poszły, jaki wynik.
- Brak wydatków poza zatwierdzonym budżetem.

## 8. Czego nie wolno

- Odpalać kampanii bez setupu trackingu.
- Obietnic produktowych, których produkt nie spełnia.
- Spamować list (zgoda RODO + częstotliwość rozsądna).
- Kopiować kreacji konkurencji bez modyfikacji = ryzyko prawne i brand damage.
- Wydawać poza budżet bez akceptacji.

## 9. Definition of Done dla kampanii

- KPI spełnione (lub jawnie raportowane jeśli nie).
- Tracking działa, dane dostępne w analytics.
- Materiały zgodne z brand guidelines, peer review przeszedł.
- Raport po-kampanijny: co działało, co nie, co dalej (`DECISIONS.md`).
<!-- /IF_IS_MARKETING -->
<!-- IF_IS_OPERATIONS -->
## 1. Każdy proces ma właściciela

Każdy proces operacyjny ma jednego nazwanego właściciela (RACI: Responsible).
Brak właściciela = proces wisi w próżni → nie startuje. Właściciel = osoba odpowiedzialna
za jakość, terminowość, ewolucję procesu.

## 2. Dokumentacja procesu

- Każdy działający proces ma SOP (Standard Operating Procedure) — krok po kroku,
  z wejściami, wyjściami, wyjątkami.
- SOP czytelny dla nowej osoby (osoba spoza zespołu rozumie w 15 min).
- Wersjonowanie SOP: data ostatniej zmiany, kto zmienił, dlaczego.
- Zmiany w SOP — decyzja kierunkowa, akceptacja właściciela procesu.

## 3. SLA i terminowość

- Każdy proces ma deklarowany SLA (czas odpowiedzi, czas realizacji) — jeśli ma odbiorcę.
- Naruszenia SLA śledzone — log incydentów.
- Plan recovery dla każdego krytycznego procesu (co robimy gdy padnie).

## 4. RACI

Dla każdego znaczącego zadania / procesu rozpisz RACI:
- **R**esponsible — kto fizycznie wykonuje
- **A**ccountable — kto odpowiada za wynik (jedna osoba)
- **C**onsulted — z kim konsultujemy przed decyzją
- **I**nformed — kogo informujemy o wyniku

Bez RACI = nie wiadomo kto pyta kogo o co. Konflikty interpretacyjne = strata energii.

## 5. Komunikacja i handoffy

- Handoff między procesami / zespołami = jawny artefakt (ticket, email, dokument),
  nie ustny przekaz.
- Brak handoffu = brak przekazania odpowiedzialności (zostaje u poprzedniego właściciela).
- Status zadań aktualizowany przez właściciela, nie domyślnie wiadomo.

## 6. Pomiary i metryki

- Każdy znaczący proces ma metrykę zdrowia (np. liczba ticketów, czas zamknięcia, satysfakcja odbiorcy).
- Metryki przeglądane regularnie (cykl ustalony w `CLAUDE.md` lub osobnym pliku kierunkowym).
- Dane do metryk zbierane przez sam proces, nie ad-hoc na potrzeby raportu.

## 7. Continuous improvement

- Po incydencie / błędzie procesowym — retrospekcja (co, dlaczego, co zmieniamy).
- Wnioski zapisywane w `DECISIONS.md` i / lub w SOP-ie.
- Anty-pattern: blame culture — nie szukamy winnego, szukamy luki w procesie.

## 8. Czego nie wolno

- Startować procesu bez właściciela.
- Wykonywać kroków poza udokumentowanym SOP-em (jeśli SOP istnieje).
- Pomijać RACI dla zadań cross-funkcyjnych.
- Ignorować naruszeń SLA bez wpisania do logu.
- Zmieniać SOP bez akceptacji właściciela procesu.

## 9. Definition of Done dla procesu / playbooka

- SOP / dokumentacja procesu kompletna i czytelna.
- Właściciel nazwany, RACI rozpisane.
- SLA i metryki zdefiniowane (jeśli aplikuje).
- Plan recovery / rollback (jeśli proces krytyczny).
- Peer review (`WORKFLOW.md` 7) — druga osoba przeczytała i potwierdziła wykonywalność.
<!-- /IF_IS_OPERATIONS -->
<!-- IF_IS_OTHER -->
## 1. Jakość wyniku

- Każdy wynik musi być **konkretny i weryfikowalny**. Generyczne stwierdzenia bez dowodu — nie liczą się.
- Twierdzenia opierają się na źródle: dane, badanie, cytat, doświadczenie. Brak źródła =
  oznacz wprost jako założenie lub hipotezę.
- Język dostosowany do odbiorcy — bez żargonu, jeśli nie jest niezbędny.
- Format wyniku zgodny z briefem (długość, struktura, kanał).

## 2. Źródła i fact-checking

- Każde nieoczywiste stwierdzenie ma podane źródło.
- Cytaty dosłowne — w cudzysłowie z podaniem źródła. Parafrazy — z atrybucją.
- Liczby, daty, nazwy własne — zweryfikowane przed publikacją.
- W razie wątpliwości — sprawdź drugi raz, nie zgaduj.

## 3. Struktura dokumentów

- Każdy dokument ma jasną strukturę: cel → kontekst → treść właściwa → wnioski / CTA.
- Nagłówki opisują zawartość sekcji.
- Długie dokumenty mają spis treści lub TL;DR.
- Brak „lania wody" — każda sekcja niesie wartość.

## 4. Pliki i organizacja

- Każdy wynik zapisany w **folderze swojego agenta** (`team/agents/<slug>/`).
- Nazwy plików informują o zawartości — bez `final_v3_FINAL.docx`.
- Wersjonowanie przez sufix `-v1`, `-v2`; finalna bez sufixu.
- Pliki współdzielone modyfikuje PM przy odbiorze.

## 5. Etyka i odpowiedzialność

- Nie publikuj treści dyskryminujących, mylących, manipulacyjnych.
- Atrybucja AI: jeśli treść generowana przez AI i wymaga oznaczenia — oznacz.
- Dane wrażliwe — zgodnie z założeniami projektu z `CLAUDE.md`.

## 6. Definition of Done

- Wynik spełnia brief (cel, format, deadline).
- Każde twierdzenie ma podstawę (źródło lub jawnie oznaczone założenie).
- Przejrzane przed oddaniem (no typos).
- Decyzje kierunkowe odnotowane w `DECISIONS.md`.

## 7. Czego nie wolno

- Zmyślać liczb, dat, cytatów, źródeł.
- Plagiatu.
- Oddawać wyniku, którego sam(a) byś nie podpisał(a) imieniem.
- Modyfikować plików współdzielonych poza folderem agenta bez PM.
<!-- /IF_IS_OTHER -->

---

Standard jest żywy. Gdy projekt urośnie i pojawią się nowe konwencje, PM przygotowuje
aktualizację tego pliku i przedstawia ją właścicielowi do zatwierdzenia.
