## Salesforce Development Conventions

- Use `sf` CLI (v2), not `sfdx` (deprecated). Always specify `--target-org <alias>`.
- Use `--dry-run` before deploying to production.
- API version: v62.0 minimum (v66.0 for Agentforce GenAiPlannerBundle).
- Project structure follows `force-app/main/default/` convention.
- One trigger per object — delegate to handler classes (Trigger Actions Framework).
- All SOQL/DML must be bulkified (no queries or DML inside for-loops).
- Use `with sharing` by default. Document reason if using `without sharing`.
- Enforce CRUD/FLS with `WITH SECURITY_ENFORCED` or `Security.stripInaccessible`.
- Test classes require 90%+ coverage, 200+ records for trigger bulk tests.
- Use `lwc:if` (not deprecated `if:true`/`if:false`) and `key` on all iterations.
- Naming: PascalCase classes, camelCase methods, UPPER_SNAKE constants.
- Custom objects: `PascalCase__c`. Custom fields: `PascalCase__c`.
- Flows: `{Object}_{Trigger}_{Purpose}`. Permission Sets: `{Role}_Permissions`.
