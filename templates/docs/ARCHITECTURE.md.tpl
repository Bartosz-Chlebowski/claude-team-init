# Architektura — {{PROJECT_NAME}}

> Decyzje architektoniczne projektu. Aktualizuje PM po akceptacji właściciela (patrz `team/PROJECT_MANAGER.md` sekcja 7).
> Każda zmiana tu trafia też do `DECISIONS.md` z uzasadnieniem.

## 1. Przegląd

{{PROJECT_DESCRIPTION}}

<!-- IF_IS_TECHNICAL -->
## 2. Stack

- **Frontend:** {{STACK_FRONTEND}}
- **Backend:** {{STACK_BACKEND}}
- **Baza danych:** {{STACK_DATABASE}}
- **Auth:** {{STACK_AUTH}}
<!-- IF_STACK_OTHER -->
- **Inne:** {{STACK_OTHER}}
<!-- /IF_STACK_OTHER -->
<!-- /IF_IS_TECHNICAL -->
<!-- IF_IS_NONTECHNICAL -->
## 2. Charakter projektu

- **Typ:** {{PROJECT_TYPE}} ({{PRODUCT_TYPE}})
- **Branża:** {{INDUSTRY}}
- **Kanały / odbiorcy:** <uzupełnij — gdzie idzie wynik, kto go odbiera>
- **Narzędzia robocze:** <jakimi narzędziami pracujemy (np. Notion, Figma, Ahrefs, ...)>
<!-- /IF_IS_NONTECHNICAL -->

## 3. Struktura katalogów / organizacja pracy

<do uzupełnienia po pierwszej iteracji>

<!-- IF_IS_TECHNICAL -->
## 4. Warstwy aplikacji

<UI / logika biznesowa / dostęp do danych — granice odpowiedzialności>
<!-- /IF_IS_TECHNICAL -->
<!-- IF_IS_NONTECHNICAL -->
## 4. Procesy i przepływy pracy

<jak idą sprawy: brief → research → produkcja → review → publikacja itp.>
<!-- /IF_IS_NONTECHNICAL -->

<!-- IF_MULTITENANT -->
## 5. Multi-tenant

Każde zapytanie do bazy filtruje po `tenant_id`. Brak izolacji = krytyczny błąd.
Konkretna implementacja (middleware / decorator / context) — do ustalenia.
<!-- /IF_MULTITENANT -->

<!-- IF_RODO -->
## 6. Dane i RODO

- Lokalizacja danych: {{DATA_LOCATION}}
- Zewnętrzne procesory AI: zakaz dla danych wrażliwych
- <inne wymogi RODO specyficzne dla projektu>
<!-- /IF_RODO -->

## 7. Integracje zewnętrzne

<lista integracji + cel + zakres>

## 8. Otwarte pytania

<co jeszcze do rozstrzygnięcia>
