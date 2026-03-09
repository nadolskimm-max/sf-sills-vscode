---
description: >-
  Creates and reviews Lightning Web Components for Salesforce. Use when building LWC components, writing Jest tests, creating Apex controllers with @AuraEnabled methods, or setting up Lightning Message Service. Do NOT use for Aura components, Apex-only logic (use sf-apex), or Visualforce pages.
applyWhen: "**/lwc/**/*.js,**/lwc/**/*.html"
---

# Lightning Web Components

## Core Responsibilities

1. Generate LWC components (HTML template + JS controller + CSS + meta XML)
2. Create `@AuraEnabled` Apex controllers for data operations
3. Write Jest unit tests for components
4. Set up Lightning Message Service (LMS) for cross-component communication
5. Ensure SLDS compliance and accessibility

## Component Structure

Every LWC consists of up to four files in a folder matching the component name:

```
force-app/main/default/lwc/accountList/
â”śâ”€â”€ accountList.html        # Template
â”śâ”€â”€ accountList.js          # Controller
â”śâ”€â”€ accountList.css         # Styles (optional)
â””â”€â”€ accountList.js-meta.xml # Metadata config
```

## Workflow

### Phase 1 â€” Design

- Identify data requirements (wire vs imperative Apex)
- Determine component targets (Record Page, App Page, Home Page, Flow)
- Plan parent-child communication (properties down, events up)

### Phase 2 â€” Generate

- HTML: Use SLDS classes, `lwc:if` directives (not `if:true`), `for:each` with `key`
- JS: Use `@wire` for reactive data, `@api` for public properties, `@track` only if needed
- Meta XML: Set `isExposed`, `targets`, and `targetConfigs`
- Apex: Use `@AuraEnabled(cacheable=true)` for read operations

### Phase 3 â€” Test

```bash
sf force lightning lwc test run --coverage
```

## Template Patterns

### Data Table with Wire

```html
<template>
    <lightning-card title="Accounts">
        <template lwc:if={accounts.data}>
            <lightning-datatable
                key-field="Id"
                data={accounts.data}
                columns={columns}
                sorted-by={sortedBy}
                sorted-direction={sortedDirection}
                onsort={handleSort}>
            </lightning-datatable>
        </template>
        <template lwc:if={accounts.error}>
            <c-error-panel errors={accounts.error}></c-error-panel>
        </template>
    </lightning-card>
</template>
```

### JS Controller with Wire

```javascript
import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', sortable: true },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];

export default class AccountList extends LightningElement {
    columns = COLUMNS;
    sortedBy;
    sortedDirection = 'asc';

    @wire(getAccounts)
    accounts;

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
    }
}
```

### Meta XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>62.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__RecordPage</target>
        <target>lightning__AppPage</target>
        <target>lightning__HomePage</target>
    </targets>
</LightningComponentBundle>
```

## Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| `if:true` / `if:false` | Use `lwc:if`, `lwc:elseif`, `lwc:else` |
| `@track` on primitives | Remove â€” primitives are reactive by default since LWC v2 |
| Direct DOM manipulation | Use template refs or reactive properties |
| No error handling on wire | Always handle `.error` case in template |
| Missing `key` on iteration | Add `key={item.Id}` to `for:each` items |
| Imperative call for read data | Use `@wire` with `cacheable=true` |

## Cross-Skill References

- For Apex controllers: see **sf-apex** for `@AuraEnabled` patterns
- For test patterns: see **sf-testing**
- For LWC patterns, LMS, Jest: see [references/patterns.md](references/patterns.md)
