#!/usr/bin/env bash
# setup-team.sh — generator struktury "wirtualnej firmy" w projekcie
#
# Tworzy:
# - CLAUDE.md (instrukcje projektu)
# - team/ z PROJECT_MANAGER.md, HIRING.md, WORKFLOW.md, STANDARDS.md, REPORTING.md,
#   ROSTER.md, TASKS.md, README.md, templates/AGENT_TEMPLATE.md, agents/
# - opcjonalne pliki kierunkowe (ARCHITECTURE, FEATURES, DECISIONS, DATABASE_SCHEMA, PRICING)
#
# Pasuje do dowolnego typu projektu: software, content, research, marketing,
# operations, other. Pytania w kwestionariuszu dostosowują się do typu.
#
# Użycie:
#   bash setup-team.sh                         # tryb interaktywny (kwestionariusz)
#   bash setup-team.sh --name "Nazwa" ...     # tryb z flagami
#   bash setup-team.sh --help                  # pomoc

set -euo pipefail

# ============================================================================
# KONFIGURACJA
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"

# Wartości domyślne (puste = wymagane do podania)
PROJECT_NAME=""
OWNER_NAME=""
PROJECT_DESCRIPTION=""
PROJECT_TYPE=""              # software|content|research|marketing|operations|other
INDUSTRY="general"
PRODUCT_TYPE=""              # konkretny podtyp w obrębie PROJECT_TYPE (np. "SaaS", "blog", "kampania")
STACK_FRONTEND=""
STACK_BACKEND=""
STACK_DATABASE=""
STACK_AUTH=""
STACK_OTHER=""
MULTITENANT="no"
RODO="no"
DATA_LOCATION=""
DOC_FILES=""
TARGET_DIR="$(pwd)"
LANGUAGE="polski"
FORCE="no"
DRY_RUN="no"
NON_INTERACTIVE="no"

# ============================================================================
# POMOC
# ============================================================================

print_help() {
  cat <<'EOF'
setup-team.sh — generator struktury wirtualnej firmy w projekcie

UŻYCIE:
  bash setup-team.sh                         tryb interaktywny (kwestionariusz)
  bash setup-team.sh --name "..." ...        tryb z flagami
  bash setup-team.sh --help                  ta pomoc

WYMAGANE (w trybie nieinteraktywnym):
  --name "Nazwa projektu"         np. "Mój CRM" / "Blog Karoliny" / "Badanie rynku"
  --owner "Imię"                  decydent / właściciel projektu, np. "Anna"
  --description "1 zdanie"        krótki opis
  --project-type "..."            software|content|research|marketing|operations|other

OPCJONALNE:
  --industry "branża"             default: general (np. ubezpieczenia, edukacja)
  --product-type "..."            podtyp w obrębie typu (np. "SaaS", "blog", "kampania");
                                  default zależy od --project-type
  --doc-files "A,B,C"             pliki kierunkowe do wygenerowania
                                  default zależy od --project-type
                                  dostępne: ARCHITECTURE, FEATURES, DECISIONS,
                                            DATABASE_SCHEMA, PRICING

OPCJONALNE (typowo dla software):
  --stack-frontend "..."          np. "Next.js + TypeScript"
  --stack-backend "..."           np. "Next.js API routes" / "FastAPI"
  --stack-database "..."          np. "PostgreSQL + Prisma" (lub "none")
  --stack-auth "..."              np. "NextAuth" / "Auth0"
  --stack-other "..."             dodatkowe technologie (puste = brak)
  --multitenant "yes|no"          default: no — czy multi-tenant
  --rodo "yes|no"                 default: no — czy wymogi RODO/GDPR
  --data-location "..."           gdy --rodo yes; np. "EOG (preferencyjnie Polska)"

POZOSTAŁE:
  --target-dir "/path"            default: bieżący katalog
  --language "polski"             na razie tylko polski
  --force                         nadpisz istniejące pliki bez pytania
  --dry-run                       pokaż co zrobi, nie zapisuj
  --non-interactive               brakujące wymagane flagi → error (nie pytaj)

PRZYKŁADY:
  # Projekt software
  bash setup-team.sh --name "Mój CRM" --owner "Anna" --project-type software \
    --description "CRM dla branży X" --industry "edukacja" \
    --stack-frontend "Next.js" --stack-backend "Next.js API" \
    --stack-database "PostgreSQL" --stack-auth "NextAuth" --multitenant yes

  # Projekt content / blog
  bash setup-team.sh --name "Blog Karoliny" --owner "Karolina" --project-type content \
    --description "Blog ekspercki o psychologii"

  # Projekt research
  bash setup-team.sh --name "Badanie Q3" --owner "Marta" --project-type research \
    --description "Badanie rynku B2B w branży X"

EOF
}

# ============================================================================
# PARSER FLAG
# ============================================================================

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) PROJECT_NAME="$2"; shift 2 ;;
    --owner) OWNER_NAME="$2"; shift 2 ;;
    --description) PROJECT_DESCRIPTION="$2"; shift 2 ;;
    --project-type) PROJECT_TYPE="$2"; shift 2 ;;
    --industry) INDUSTRY="$2"; shift 2 ;;
    --product-type) PRODUCT_TYPE="$2"; shift 2 ;;
    --stack-frontend) STACK_FRONTEND="$2"; shift 2 ;;
    --stack-backend) STACK_BACKEND="$2"; shift 2 ;;
    --stack-database) STACK_DATABASE="$2"; shift 2 ;;
    --stack-auth) STACK_AUTH="$2"; shift 2 ;;
    --stack-other) STACK_OTHER="$2"; shift 2 ;;
    --multitenant) MULTITENANT="$2"; shift 2 ;;
    --rodo) RODO="$2"; shift 2 ;;
    --data-location) DATA_LOCATION="$2"; shift 2 ;;
    --doc-files) DOC_FILES="$2"; shift 2 ;;
    --target-dir) TARGET_DIR="$2"; shift 2 ;;
    --language) LANGUAGE="$2"; shift 2 ;;
    --force) FORCE="yes"; shift ;;
    --dry-run) DRY_RUN="yes"; shift ;;
    --non-interactive) NON_INTERACTIVE="yes"; shift ;;
    -h|--help) print_help; exit 0 ;;
    *) echo "ERR: nieznana flaga: $1" >&2; print_help; exit 2 ;;
  esac
done

# ============================================================================
# KWESTIONARIUSZ INTERAKTYWNY
# ============================================================================

ask() {
  # ask "Pytanie" "default" "var_name" [--allow-empty]
  local prompt="$1"
  local default="$2"
  local varname="$3"
  local allow_empty="${4:-}"
  local current_value="${!varname}"

  # Jeśli już ustawione przez flagę — pomiń
  if [[ -n "$current_value" ]]; then return; fi

  if [[ "$NON_INTERACTIVE" == "yes" ]]; then
    if [[ "$allow_empty" == "--allow-empty" || -n "$default" ]]; then
      printf -v "$varname" "%s" "$default"
      return
    else
      echo "ERR: brak wymaganej wartości dla --${varname,,} (tryb --non-interactive)" >&2
      exit 2
    fi
  fi

  local display_default=""
  if [[ -n "$default" ]]; then display_default=" [${default}]"; fi
  read -r -p "$prompt${display_default}: " answer

  if [[ -z "$answer" ]]; then
    if [[ -n "$default" ]]; then
      answer="$default"
    elif [[ "$allow_empty" != "--allow-empty" ]]; then
      echo "  ↳ wartość wymagana"
      ask "$prompt" "$default" "$varname" "$allow_empty"
      return
    fi
  fi
  printf -v "$varname" "%s" "$answer"
}

ask_yes_no() {
  local prompt="$1"
  local default="$2"   # yes|no
  local varname="$3"
  local current_value="${!varname}"

  if [[ -n "$current_value" && "$current_value" != "yes" && "$current_value" != "no" ]]; then
    echo "ERR: wartość --${varname,,} musi być 'yes' lub 'no' (jest: $current_value)" >&2
    exit 2
  fi

  # Jeśli ustawione przez flagę — pomiń (ale tylko jeśli niepuste i sensowne)
  if [[ "$current_value" == "yes" || "$current_value" == "no" ]]; then
    # Sprawdź czy to wartość z flagi (różna od domyślnej) — i tak akceptujemy
    return
  fi

  if [[ "$NON_INTERACTIVE" == "yes" ]]; then
    printf -v "$varname" "%s" "$default"
    return
  fi

  read -r -p "$prompt [${default}]: " answer
  answer="${answer:-$default}"
  case "$answer" in
    y|Y|yes|YES|tak|t) printf -v "$varname" "%s" "yes" ;;
    n|N|no|NO|nie) printf -v "$varname" "%s" "no" ;;
    *) echo "  ↳ podaj y/n"; ask_yes_no "$prompt" "$default" "$varname" ;;
  esac
}

# Sprawdzamy czy potrzeba kwestionariusza
need_questionnaire="no"
if [[ -z "$PROJECT_NAME" || -z "$OWNER_NAME" || -z "$PROJECT_DESCRIPTION" || -z "$PROJECT_TYPE" ]]; then
  need_questionnaire="yes"
fi

if [[ "$need_questionnaire" == "yes" && "$NON_INTERACTIVE" != "yes" ]]; then
  echo ""
  echo "════════════════════════════════════════════════════════════════════"
  echo "  SETUP TEAM — kwestionariusz konfiguracji"
  echo "════════════════════════════════════════════════════════════════════"
  echo ""
  echo "Odpowiedz na pytania. Pola z [wartość w nawiasach] mają default —"
  echo "wciśnij Enter, żeby zaakceptować."
  echo ""
  echo "── Identyfikacja projektu ─────────────────────────────────────────"
  ask "Nazwa projektu" "" PROJECT_NAME
  ask "Imię właściciela / decydenta" "" OWNER_NAME
  ask "Krótki opis (1 zdanie)" "" PROJECT_DESCRIPTION
  echo ""
  echo "Typ projektu — steruje tym, jakie sekcje generujemy:"
  echo "  software    — aplikacja, kod, infrastruktura (frontend/backend/db/auth)"
  echo "  content     — blog, treści, copywriting, SEO"
  echo "  research    — badania, analizy, raporty"
  echo "  marketing   — kampanie, lead-gen, social, brand"
  echo "  operations  — procesy biznesowe, dokumenty, organizacja"
  echo "  other       — coś innego (uniwersalny szablon)"
  ask "Typ projektu (software|content|research|marketing|operations|other)" "" PROJECT_TYPE
  ask "Branża" "general" INDUSTRY
  echo ""
fi

# Walidacja PROJECT_TYPE
case "$PROJECT_TYPE" in
  software|content|research|marketing|operations|other) ;;
  "")
    echo "ERR: brak --project-type (software|content|research|marketing|operations|other)" >&2
    exit 2
    ;;
  *)
    echo "ERR: nieprawidłowy --project-type: $PROJECT_TYPE (dozwolone: software|content|research|marketing|operations|other)" >&2
    exit 2
    ;;
esac

# Conditional vars per typ — używane do warunkowych bloków <!-- IF_IS_X --> w szablonach
IS_TECHNICAL="no"
IS_CONTENT="no"
IS_RESEARCH="no"
IS_MARKETING="no"
IS_OPERATIONS="no"
IS_OTHER="no"
IS_NONTECHNICAL="yes"     # negacja IS_TECHNICAL (dla istniejących blocków)

case "$PROJECT_TYPE" in
  software)
    IS_TECHNICAL="yes"
    IS_NONTECHNICAL="no"
    ;;
  content)    IS_CONTENT="yes" ;;
  research)   IS_RESEARCH="yes" ;;
  marketing)  IS_MARKETING="yes" ;;
  operations) IS_OPERATIONS="yes" ;;
  other)      IS_OTHER="yes" ;;
esac

# Default DOC_FILES zależy od typu projektu
if [[ -z "$DOC_FILES" ]]; then
  case "$PROJECT_TYPE" in
    software)   DOC_FILES_DEFAULT="ARCHITECTURE,FEATURES,DECISIONS" ;;
    content)    DOC_FILES_DEFAULT="FEATURES,DECISIONS" ;;
    research)   DOC_FILES_DEFAULT="FEATURES,DECISIONS" ;;
    marketing)  DOC_FILES_DEFAULT="FEATURES,DECISIONS" ;;
    operations) DOC_FILES_DEFAULT="FEATURES,DECISIONS" ;;
    *)          DOC_FILES_DEFAULT="DECISIONS" ;;
  esac
  DOC_FILES="$DOC_FILES_DEFAULT"
fi

# Default PRODUCT_TYPE zależy od typu projektu
if [[ -z "$PRODUCT_TYPE" ]]; then
  case "$PROJECT_TYPE" in
    software)   PRODUCT_TYPE="SaaS" ;;
    content)    PRODUCT_TYPE="blog/treści" ;;
    research)   PRODUCT_TYPE="badanie/analiza" ;;
    marketing)  PRODUCT_TYPE="kampania" ;;
    operations) PRODUCT_TYPE="proces biznesowy" ;;
    *)          PRODUCT_TYPE="inny" ;;
  esac
fi

# Pytania dalsze — tylko dla projektów technicznych
if [[ "$need_questionnaire" == "yes" && "$NON_INTERACTIVE" != "yes" && "$IS_TECHNICAL" == "yes" ]]; then
  echo "── Stack technologiczny ───────────────────────────────────────────"
  ask "Frontend (np. 'Next.js + TypeScript', 'n/a')" "n/a" STACK_FRONTEND
  ask "Backend (np. 'Next.js API routes', 'FastAPI')" "n/a" STACK_BACKEND
  ask "Baza danych (np. 'PostgreSQL + Prisma', wpisz 'none' jeśli brak)" "none" STACK_DATABASE
  ask "Auth (np. 'NextAuth', 'Auth0', 'n/a')" "n/a" STACK_AUTH
  ask "Dodatkowe technologie (puste = brak)" "" STACK_OTHER --allow-empty
  echo ""
  echo "── Założenia architektoniczne ─────────────────────────────────────"
  ask_yes_no "Multi-tenant? (czy jedna instancja obsługuje wielu klientów)" "no" MULTITENANT
  ask_yes_no "Wymogi RODO/GDPR?" "no" RODO
  if [[ "$RODO" == "yes" ]]; then
    ask "Lokalizacja danych (np. 'EOG (preferencyjnie Polska)')" "EOG (preferencyjnie Polska)" DATA_LOCATION
  fi
  echo ""
fi

# Pytania końcowe (dla wszystkich typów)
if [[ "$need_questionnaire" == "yes" && "$NON_INTERACTIVE" != "yes" ]]; then
  echo "── Pliki dokumentacji kierunkowej ─────────────────────────────────"
  echo "Domyślne dla typu '${PROJECT_TYPE}': ${DOC_FILES}"
  echo "Dostępne: ARCHITECTURE, FEATURES, DECISIONS, DATABASE_SCHEMA, PRICING"
  ask "Pliki do wygenerowania (lista przez przecinek)" "$DOC_FILES" DOC_FILES
  echo ""
  echo "── Docelowy katalog ───────────────────────────────────────────────"
  ask "Katalog docelowy (root projektu)" "$(pwd)" TARGET_DIR
  echo ""
fi

# Walidacja wymaganych pól
if [[ -z "$PROJECT_NAME" || -z "$OWNER_NAME" || -z "$PROJECT_DESCRIPTION" ]]; then
  echo "ERR: brakuje wymaganych pól (--name, --owner, --description)" >&2
  exit 2
fi

# Wartości pochodne
DATE="$(date +%Y-%m-%d)"
[[ -z "$DATA_LOCATION" ]] && DATA_LOCATION="(do uzupełnienia)"
# HAS_DB — tylko dla projektów technicznych z bazą
if [[ "$IS_TECHNICAL" == "yes" && -n "$STACK_DATABASE" && "$STACK_DATABASE" != "none" ]]; then
  HAS_DB="yes"
else
  HAS_DB="no"
fi
# Defaulty dla nietechnicznych — żeby placeholdery nie ziały "n/a"
if [[ "$IS_TECHNICAL" != "yes" ]]; then
  [[ -z "$STACK_FRONTEND" ]] && STACK_FRONTEND="n/d"
  [[ -z "$STACK_BACKEND" ]] && STACK_BACKEND="n/d"
  [[ -z "$STACK_DATABASE" ]] && STACK_DATABASE="n/d"
  [[ -z "$STACK_AUTH" ]] && STACK_AUTH="n/d"
fi

# Walidacja docelowego katalogu
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || true)"
if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
  echo "ERR: katalog docelowy nie istnieje: $TARGET_DIR" >&2
  exit 2
fi

# Sprawdź czy team/ już istnieje
if [[ -d "${TARGET_DIR}/team" && "$FORCE" != "yes" ]]; then
  if [[ "$NON_INTERACTIVE" == "yes" ]]; then
    echo "ERR: ${TARGET_DIR}/team już istnieje. Użyj --force aby nadpisać." >&2
    exit 2
  fi
  echo ""
  echo "⚠️  ${TARGET_DIR}/team już istnieje."
  read -r -p "Nadpisać? [no]: " ow
  ow="${ow:-no}"
  case "$ow" in
    y|Y|yes|YES|tak|t) FORCE="yes" ;;
    *) echo "Przerwano."; exit 0 ;;
  esac
fi

# ============================================================================
# RENDERING SZABLONÓW
# ============================================================================
#
# Strategia: kopiujemy szablon do tmp file, modyfikujemy in-place perl-em,
# na koniec mv do dst. Unika problemów z multiline substytucją w bashowej
# zmiennej i z `set -e` ucinającym wynik subshelli.

# Eksportujemy wszystkie zmienne dla perla (perl czyta przez $ENV{R_X})
export R_PROJECT_NAME="$PROJECT_NAME"
export R_OWNER_NAME="$OWNER_NAME"
export R_PROJECT_DESCRIPTION="$PROJECT_DESCRIPTION"
export R_PROJECT_TYPE="$PROJECT_TYPE"
export R_INDUSTRY="$INDUSTRY"
export R_PRODUCT_TYPE="$PRODUCT_TYPE"
export R_STACK_FRONTEND="$STACK_FRONTEND"
export R_STACK_BACKEND="$STACK_BACKEND"
export R_STACK_DATABASE="$STACK_DATABASE"
export R_STACK_AUTH="$STACK_AUTH"
export R_STACK_OTHER="$STACK_OTHER"
export R_DATA_LOCATION="$DATA_LOCATION"
export R_DATE="$DATE"
export R_LANGUAGE="$LANGUAGE"

# DOC_FILES_TABLE i DOC_FILES_INLINE — budujemy raz na początku
DOC_FILES_TABLE_VAL=""
DOC_FILES_INLINE_VAL=""
IFS=',' read -ra _DOC_ARR <<< "$DOC_FILES"
_first="yes"
for _f in "${_DOC_ARR[@]}"; do
  _f="$(echo "$_f" | xargs)"
  [[ -z "$_f" ]] && continue
  _desc=""
  case "$_f" in
    ARCHITECTURE) _desc="Decyzje architektoniczne" ;;
    FEATURES) _desc="Lista funkcji i priorytety" ;;
    DECISIONS) _desc="Log ważnych decyzji z uzasadnieniem" ;;
    DATABASE_SCHEMA) _desc="Schemat bazy danych" ;;
    PRICING) _desc="Strategia cenowa i analiza konkurencji" ;;
    *) _desc="(opis do uzupełnienia)" ;;
  esac
  DOC_FILES_TABLE_VAL="${DOC_FILES_TABLE_VAL}| \`${_f}.md\` | ${_desc} |
"
  if [[ "$_first" == "yes" ]]; then
    DOC_FILES_INLINE_VAL="\`${_f}.md\`"
    _first="no"
  else
    DOC_FILES_INLINE_VAL="${DOC_FILES_INLINE_VAL}, \`${_f}.md\`"
  fi
done
# Trim trailing newline z DOC_FILES_TABLE_VAL
DOC_FILES_TABLE_VAL="${DOC_FILES_TABLE_VAL%$'\n'}"
export R_DOC_FILES_TABLE="$DOC_FILES_TABLE_VAL"
export R_DOC_FILES_INLINE="$DOC_FILES_INLINE_VAL"

# render_template — kopiuje src do tmp, perl-i in-place, mv do dst
render_template() {
  local src="$1"
  local dst="$2"

  if [[ "$DRY_RUN" == "yes" ]]; then
    echo "  [DRY-RUN] zapisałbym: $dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  local tmp
  tmp="$(mktemp)"
  cp "$src" "$tmp"

  # 1. Bloki warunkowe <!-- IF_X -->...<!-- /IF_X -->
  local var value
  for var in IS_TECHNICAL IS_NONTECHNICAL IS_CONTENT IS_RESEARCH IS_MARKETING IS_OPERATIONS IS_OTHER MULTITENANT RODO HAS_DB STACK_OTHER; do
    value="${!var}"
    if [[ "$var" == "STACK_OTHER" ]]; then
      [[ -n "$STACK_OTHER" ]] && value="yes" || value="no"
    fi
    if [[ "$value" == "yes" ]]; then
      # Zostaw treść, usuń same markery (z opcjonalnym newline za markerem)
      perl -i -0777 -pe "s|<!-- IF_${var} -->\n?||g; s|<!-- /IF_${var} -->\n?||g" "$tmp"
    else
      # Usuń cały blok z markerami
      perl -i -0777 -pe "s|<!-- IF_${var} -->.*?<!-- /IF_${var} -->\n?||gs" "$tmp"
    fi
  done

  # 2. Placeholdery jednoliniowe (perl czyta zmienne ze środowiska)
  perl -i -pe '
    s|\{\{PROJECT_NAME\}\}|$ENV{R_PROJECT_NAME}|g;
    s|\{\{OWNER_NAME\}\}|$ENV{R_OWNER_NAME}|g;
    s|\{\{PROJECT_DESCRIPTION\}\}|$ENV{R_PROJECT_DESCRIPTION}|g;
    s|\{\{PROJECT_TYPE\}\}|$ENV{R_PROJECT_TYPE}|g;
    s|\{\{INDUSTRY\}\}|$ENV{R_INDUSTRY}|g;
    s|\{\{PRODUCT_TYPE\}\}|$ENV{R_PRODUCT_TYPE}|g;
    s|\{\{STACK_FRONTEND\}\}|$ENV{R_STACK_FRONTEND}|g;
    s|\{\{STACK_BACKEND\}\}|$ENV{R_STACK_BACKEND}|g;
    s|\{\{STACK_DATABASE\}\}|$ENV{R_STACK_DATABASE}|g;
    s|\{\{STACK_AUTH\}\}|$ENV{R_STACK_AUTH}|g;
    s|\{\{STACK_OTHER\}\}|$ENV{R_STACK_OTHER}|g;
    s|\{\{DATA_LOCATION\}\}|$ENV{R_DATA_LOCATION}|g;
    s|\{\{DATE\}\}|$ENV{R_DATE}|g;
    s|\{\{LANGUAGE\}\}|$ENV{R_LANGUAGE}|g;
    s|\{\{DOC_FILES_INLINE\}\}|$ENV{R_DOC_FILES_INLINE}|g;
  ' "$tmp"

  # 3. DOC_FILES_TABLE (multiline) — slurp mode (-0777)
  perl -i -0777 -pe 's|\{\{DOC_FILES_TABLE\}\}|$ENV{R_DOC_FILES_TABLE}|g' "$tmp"

  mv "$tmp" "$dst"
  echo "  ✓ $dst"
}

# ============================================================================
# GŁÓWNA AKCJA
# ============================================================================

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "  Generuję strukturę: $PROJECT_NAME"
echo "  Katalog docelowy:    $TARGET_DIR"
[[ "$DRY_RUN" == "yes" ]] && echo "  TRYB:                dry-run (nic nie zapisuję)"
echo "════════════════════════════════════════════════════════════════════"
echo ""

# 1. CLAUDE.md (główny katalog)
if [[ -f "${TARGET_DIR}/CLAUDE.md" && "$FORCE" != "yes" ]]; then
  echo "  ⏭  CLAUDE.md już istnieje — pomijam (użyj --force aby nadpisać)"
else
  render_template "${TEMPLATES_DIR}/CLAUDE.md.tpl" "${TARGET_DIR}/CLAUDE.md"
fi

# 2. team/* (wszystkie pliki w team/)
render_template "${TEMPLATES_DIR}/team/README.md.tpl" "${TARGET_DIR}/team/README.md"
render_template "${TEMPLATES_DIR}/team/PROJECT_MANAGER.md.tpl" "${TARGET_DIR}/team/PROJECT_MANAGER.md"
render_template "${TEMPLATES_DIR}/team/HIRING.md.tpl" "${TARGET_DIR}/team/HIRING.md"
render_template "${TEMPLATES_DIR}/team/WORKFLOW.md.tpl" "${TARGET_DIR}/team/WORKFLOW.md"
render_template "${TEMPLATES_DIR}/team/STANDARDS.md.tpl" "${TARGET_DIR}/team/STANDARDS.md"
render_template "${TEMPLATES_DIR}/team/REPORTING.md.tpl" "${TARGET_DIR}/team/REPORTING.md"
render_template "${TEMPLATES_DIR}/team/ROSTER.md.tpl" "${TARGET_DIR}/team/ROSTER.md"
render_template "${TEMPLATES_DIR}/team/TASKS.md.tpl" "${TARGET_DIR}/team/TASKS.md"
render_template "${TEMPLATES_DIR}/team/templates/AGENT_TEMPLATE.md.tpl" "${TARGET_DIR}/team/templates/AGENT_TEMPLATE.md"

# 3. team/agents/ (pusty folder + .gitkeep)
if [[ "$DRY_RUN" != "yes" ]]; then
  mkdir -p "${TARGET_DIR}/team/agents"
  touch "${TARGET_DIR}/team/agents/.gitkeep"
  echo "  ✓ ${TARGET_DIR}/team/agents/ (pusty folder)"
else
  echo "  [DRY-RUN] utworzyłbym pusty folder: ${TARGET_DIR}/team/agents/"
fi

# 4. Pliki kierunkowe (opcjonalne)
echo ""
echo "── Pliki kierunkowe ───────────────────────────────────────────────"
IFS=',' read -ra DOC_ARR <<< "$DOC_FILES"
for f in "${DOC_ARR[@]}"; do
  f="$(echo "$f" | xargs)"
  [[ -z "$f" ]] && continue
  local_tpl="${TEMPLATES_DIR}/docs/${f}.md.tpl"
  if [[ ! -f "$local_tpl" ]]; then
    echo "  ⚠️  brak szablonu dla ${f}.md w ${TEMPLATES_DIR}/docs/ — pomijam"
    continue
  fi
  if [[ -f "${TARGET_DIR}/${f}.md" && "$FORCE" != "yes" ]]; then
    echo "  ⏭  ${f}.md już istnieje — pomijam"
    continue
  fi
  render_template "$local_tpl" "${TARGET_DIR}/${f}.md"
done

# ============================================================================
# PODSUMOWANIE
# ============================================================================

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "  ✅ GOTOWE"
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "Struktura utworzona w: $TARGET_DIR"
echo ""
echo "Co dalej:"
echo "  1. Przejrzyj CLAUDE.md i pliki w team/ — wypełnij placeholdery <...>"
echo "  2. Odpal Claude Code w katalogu projektu i odwołaj się do PM:"
echo "     @team/PROJECT_MANAGER.md — działaj jako Project Manager. Zadanie: ..."
case "$PROJECT_TYPE" in
  software)
    echo "  3. Pierwsze zadanie zwykle: ustal MVP scope, ARCHITECTURE, FEATURES"
    ;;
  content)
    echo "  3. Pierwsze zadanie zwykle: ustal strategię contentową, persony, kalendarz publikacji"
    ;;
  research)
    echo "  3. Pierwsze zadanie zwykle: ustal cele badania, hipotezy, metodologię"
    ;;
  marketing)
    echo "  3. Pierwsze zadanie zwykle: ustal cele kampanii, target, kanały, KPI"
    ;;
  operations)
    echo "  3. Pierwsze zadanie zwykle: zmapuj obecny proces, zidentyfikuj wąskie gardła"
    ;;
  *)
    echo "  3. Pierwsze zadanie zwykle: doprecyzuj cele projektu i pierwsze kroki"
    ;;
esac
echo ""
