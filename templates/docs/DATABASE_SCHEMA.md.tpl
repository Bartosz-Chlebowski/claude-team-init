# Schemat bazy danych — {{PROJECT_NAME}}

> Źródło prawdy o strukturze bazy. Aktualizuje PM po każdej migracji.
> Reguła: zmiana schematu = aktualizacja tego pliku przed merge.

## Stack

{{STACK_DATABASE}}

## Tabele

<lista tabel + opis>

### Przykład struktury wpisu:

```
### users
- id (PK)
- email (unique)
<!-- IF_MULTITENANT -->
- tenant_id (FK → tenants.id) — IZOLACJA TENANTA
<!-- /IF_MULTITENANT -->
- created_at, updated_at

Indeksy:
- idx_users_email (unique)
<!-- IF_MULTITENANT -->
- idx_users_tenant (tenant_id)
<!-- /IF_MULTITENANT -->
```

## Relacje

<diagram lub opis relacji między tabelami>

## Migracje

<lista migracji w porządku chronologicznym>

<!-- IF_MULTITENANT -->
## Zasada multi-tenant

**Każda** tabela z danymi tenant-specific MUSI mieć kolumnę `tenant_id`
i odpowiedni indeks. Brak izolacji = krytyczny błąd.
<!-- /IF_MULTITENANT -->
