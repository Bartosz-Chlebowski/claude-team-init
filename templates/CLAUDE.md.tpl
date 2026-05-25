# {{PROJECT_NAME}} — Instrukcje projektu

## Czym jest ten projekt

{{PROJECT_DESCRIPTION}}

Branża: {{INDUSTRY}}. Typ projektu: {{PROJECT_TYPE}} ({{PRODUCT_TYPE}}).

<!-- IF_IS_TECHNICAL -->
## Stack technologiczny

- **Frontend:** {{STACK_FRONTEND}}
- **Backend:** {{STACK_BACKEND}}
- **Baza danych:** {{STACK_DATABASE}}
- **Auth:** {{STACK_AUTH}}
<!-- IF_STACK_OTHER -->
- **Inne:** {{STACK_OTHER}}
<!-- /IF_STACK_OTHER -->
<!-- /IF_IS_TECHNICAL -->

## Kluczowe założenia

<!-- IF_MULTITENANT -->
- **Multi-tenant** — jedna instancja obsługuje wielu klientów (tenantów). Każde zapytanie do bazy musi być filtrowane po tenant_id. To warunek bezpieczeństwa, nie opcja.
<!-- /IF_MULTITENANT -->
<!-- IF_RODO -->
- **Zgodność RODO** — przetwarzanie danych osobowych zgodne z RODO/GDPR. Lokalizacja danych: {{DATA_LOCATION}}.
- **Brak wysyłki danych wrażliwych do zewnętrznych procesorów AI** (OpenAI/Anthropic/Gemini API itp.) — dane nie opuszczają naszej infrastruktury.
<!-- /IF_RODO -->
<!-- IF_HAS_DB -->
- **Baza danych niedostępna z zewnątrz** — tylko przez warstwę API aplikacji.
<!-- /IF_HAS_DB -->
<!-- IF_IS_NONTECHNICAL -->
- **Założenia uzupełnić wg potrzeb projektu** — np. cele biznesowe, ograniczenia, deadliny, kanały publikacji, target.
<!-- /IF_IS_NONTECHNICAL -->

## Struktura dokumentacji projektu

Wszystkie decyzje, analizy i ustalenia trzymamy w plikach MD w tym folderze:

| Plik | Zawartość |
|------|-----------|
| `CLAUDE.md` | Ten plik — bazowe założenia, czytany automatycznie |
{{DOC_FILES_TABLE}}

Struktura dokumentacji jest **żywa** — PM proponuje nowe pliki kierunkowe
(po akceptacji właściciela), gdy projekt tego potrzebuje.

## Jak pracujemy

- Każda istotna decyzja architektoniczna lub zmiana założeń trafia do odpowiedniego pliku MD
- Ten plik jest punktem startowym każdego czatu — nie trzeba powtarzać kontekstu
- Jeśli coś jest niejasne, pytaj o jeden konkret na raz

## Reguła aktualizacji dokumentacji

Po każdej ważnej decyzji projektowej, zmianie założeń lub wyborze kierunku Claude **automatycznie**:

1. Aktualizuje odpowiedni plik MD (np. plik kierunkowy z listy powyżej)
2. Dodaje wpis do `DECISIONS.md` w formacie:
   ```
   ## [YYYY-MM-DD] Tytuł decyzji
   **Decyzja:** co postanowiono
   **Uzasadnienie:** dlaczego
   **Alternatywy odrzucone:** co rozważano
   ```
3. Jeśli zmiana dotyczy założeń projektu — aktualizuje też ten plik (`CLAUDE.md`)

Zasada działa bez proszenia — Claude nie czeka na polecenie "zapisz to".

## Zespół wirtualnej firmy

Projekt ma zorganizowany zespół wirtualnych agentów koordynowanych przez Project Managera.
Szczegóły w `team/README.md`. Wejście do PM-a: `@team/PROJECT_MANAGER.md`.

**Struktura firmy jest żywa** — PM rozbudowuje ją w miarę realnych potrzeb projektu:
nowe role agentów, nowe szablony, nowe procesy raportowania. Każda zmiana wymaga
akceptacji właściciela.
