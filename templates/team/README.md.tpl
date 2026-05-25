# Wirtualna firma — {{PROJECT_NAME}}

Struktura agentów oddelegowanych do projektu {{PROJECT_NAME}}. Ten plik to przegląd dla właściciela.

## Jak to działa

Rozmawiasz z **Project Managerem**. Wydajesz mu zadania — on je analizuje, dzieli,
deleguje do pracowników o pasujących kompetencjach, nadzoruje i raportuje wyniki.
Gdy brakuje kompetencji, PM proponuje zatrudnienie nowego agenta — **Ty akceptujesz
każdą decyzję PM-a**, w tym każde zatrudnienie, zanim zostanie wykonana.

## Jak uruchomić PM-a

Na początku czatu odwołaj się do jego skryptu:

```
@team/PROJECT_MANAGER.md  — działaj jako Project Manager. Zadanie: ...
```

PM sam wczyta resztę plików (`ROSTER`, `TASKS`, `WORKFLOW`, `HIRING`, `REPORTING`).

## Pliki

| Plik | Zawartość |
|------|-----------|
| `PROJECT_MANAGER.md` | Playbook PM — tożsamość, pętla pracy, delegacja, nadzór |
| `HIRING.md` | Proces zatrudniania + szablon karty rekrutacji |
| `WORKFLOW.md` | Cykl życia zadania, izolacja folderów, handoffy, code review, Definition of Done |
| `STANDARDS.md` | Standard techniczny — konwencje kodu, bezpieczeństwo |
| `REPORTING.md` | Formaty raportów PM |
| `ROSTER.md` | Rejestr zatrudnionych agentów (prowadzi PM) |
| `TASKS.md` | Kolejka zadań i statusy (prowadzi PM) |
| `templates/AGENT_TEMPLATE.md` | Szablon skryptu nowego pracownika |
| `agents/<slug>/` | Folder roboczy każdego pracownika — skrypt + jego praca |

## Model pracy

**Hybrydowy.** Skrypty MD są źródłem prawdy o rolach. PM przy małych zadaniach wciela
się w rolę agenta; przy dużych/równoległych uruchamia osobnych subagentów brifowanych
skryptem MD. Każdy agent zapisuje pracę tylko we własnym folderze — dzięki temu wielu
może działać jednocześnie bez kolizji.

## Stan startowy

Zatrudniony jest wyłącznie Project Manager. Zespół wykonawczy PM zbuduje pod realne
zadania — każde zatrudnienie najpierw zatwierdzasz Ty.
