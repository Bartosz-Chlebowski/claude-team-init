# Standard pracy — {{PROJECT_NAME}}

> Wspólny standard dla wszystkich agentów. Obowiązuje przy każdym zadaniu.
> Dokument żywy — aktualizuje go PM po akceptacji właściciela (patrz `PROJECT_MANAGER.md` sekcja 7).
> Odwołanie: `@team/STANDARDS.md`

Standard ma trzymać jakość i spójność: każdy agent pracuje tak, jakby pracował jeden zespół.
Założenia projektu: `CLAUDE.md`. Kluczowe decyzje: pliki kierunkowe + `DECISIONS.md`.

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
<!-- IF_IS_NONTECHNICAL -->
## 1. Jakość wyniku

- Każdy wynik (dokument, analiza, treść, materiał) musi być **konkretny i weryfikowalny**.
  Generyczne stwierdzenia („to ważne", „ludzie tego potrzebują") bez dowodu — nie liczą się.
- Twierdzenia opierają się na źródle: dane, badanie, cytat, doświadczenie. Brak źródła =
  oznacz wprost jako założenie lub hipotezę.
- Język dostosowany do odbiorcy — bez żargonu, jeśli nie jest niezbędny.
- Format wyniku zgodny z briefem (długość, struktura, kanał publikacji).

## 2. Źródła i fact-checking

- Każde nieoczywiste stwierdzenie ma podane źródło (link, dokument, autor).
- Cytaty dosłowne — w cudzysłowie z podaniem źródła. Parafrazy — z atrybucją.
- Liczby, daty, nazwy własne — zweryfikowane przed publikacją.
- W razie wątpliwości — sprawdź drugi raz, nie zgaduj.

## 3. Struktura dokumentów

- Każdy dokument ma jasną strukturę: cel → kontekst → treść właściwa → wnioski / CTA.
- Nagłówki opisują zawartość sekcji — czytelnik wie, gdzie szukać.
- Długie dokumenty mają spis treści lub TL;DR na początku.
- Brak „lania wody" — każda sekcja niesie wartość.

## 4. Spójność i brand

- Trzymaj się ustalonego tone of voice projektu (jeśli zdefiniowany w pliku kierunkowym).
- Terminologia spójna w całym projekcie — jeśli nazywamy coś „X", nie zmieniamy w połowie na „Y".
- Format wizualny (jeśli dotyczy): zgodny z brand-bookiem projektu.

## 5. Pliki i organizacja

- Każdy wynik zapisany w **folderze swojego agenta** (`team/agents/<slug>/`).
- Nazwy plików informują o zawartości — bez `final_v3_FINAL.docx`.
- Wersjonowanie przez sufix `-v1`, `-v2` gdy potrzebujesz iteracji; finalna bez sufixu.
- Pliki współdzielone (w katalogu głównym projektu) modyfikuje PM przy odbiorze, nie agent.

## 6. Etyka i odpowiedzialność

- Nie publikuj treści dyskryminujących, mylących, manipulacyjnych.
- Atrybucja AI: jeśli treść była generowana przez AI i wymaga to oznaczenia (zależnie
  od kanału / klienta) — oznacz wyraźnie.
- Dane wrażliwe (osobowe, finansowe, klienckie) — traktuj zgodnie z założeniami projektu
  z `CLAUDE.md`. Brak wysyłki do zewnętrznych usług bez akceptacji właściciela.

## 7. Definition of Done

- Wynik spełnia brief: cel, format, długość, deadline.
- Każde twierdzenie ma podstawę (źródło lub jawnie oznaczone założenie).
- Tekst przeczytany na głos / przejrzany przed oddaniem (no typos, no broken sentences).
- Decyzje merytoryczne (np. wybór kątu, struktura) odnotowane w `DECISIONS.md` jeśli
  są kierunkowe.

## 8. Czego nie wolno

- Zmyślać liczb, dat, cytatów, źródeł.
- Plagiatu — kopiowania cudzej pracy bez atrybucji.
- Oddawania wyniku, którego sam(a) byś nie podpisał(a) imieniem.
- Wprowadzania zmian w plikach współdzielonych (poza folderem swojego agenta) bez PM.
- Zostawiania pracy „prawie skończonej" bez raportu o blockerze.

## 9. Definition of Done — szczegół

Obowiązuje DoD z `WORKFLOW.md` sekcja 6 (dokument / analiza / decyzja) plus zgodność
z tym standardem. Wynik łamiący sekcję 2 (źródła), 6 (etyka) lub 8 (czego nie wolno)
**nie przechodzi** odbioru — wraca do autora.
<!-- /IF_IS_NONTECHNICAL -->

---

Standard jest żywy. Gdy projekt urośnie i pojawią się nowe konwencje, PM przygotowuje
aktualizację tego pliku i przedstawia ją właścicielowi do zatwierdzenia.
