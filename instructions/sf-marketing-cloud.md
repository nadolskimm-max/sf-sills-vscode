---
description: >-
  Integrates Salesforce Marketing Cloud with CRM including Marketing Cloud Connect, Journey Builder, AMPscript, data extensions, and email automation. Use when configuring MC Connect, building journeys, writing AMPscript, or setting up data extensions. Do NOT use for standard email templates (use sf-email) or Data Cloud CDP (use sf-data-cloud).
---

# Marketing Cloud Integration

## Core Responsibilities

1. Configure Marketing Cloud Connect (MC Connect)
2. Design Journey Builder journeys
3. Write AMPscript for dynamic content
4. Manage Data Extensions and data synchronization
5. Set up tracking and analytics

## Marketing Cloud Connect

### Synchronized Objects

| CRM Object | MC Object | Direction |
|---|---|---|
| Contact | Subscriber | Bidirectional |
| Lead | Subscriber | CRM â†’ MC |
| Campaign | Campaign | CRM â†’ MC |
| Campaign Member | Journey Entry | CRM â†’ MC |
| Custom Object | Data Extension | CRM â†’ MC |

### MC Connect Setup

```
1. Install Marketing Cloud Connect package in Salesforce
2. Configure Connected App in Salesforce
3. Map Salesforce user to MC user
4. Select objects to synchronize
5. Configure synchronized data extensions
6. Set sync frequency (near-real-time or scheduled)
```

## Journey Builder

### Journey Architecture

```
Entry Source (Data Extension, API, Salesforce Data)
â”śâ”€â”€ Decision Split: Is VIP Customer?
â”‚   â”śâ”€â”€ YES â†’ Email: VIP Welcome
â”‚   â”‚         â†’ Wait: 3 days
â”‚   â”‚         â†’ Email: Exclusive Offer
â”‚   â””â”€â”€ NO  â†’ Email: Standard Welcome
â”‚            â†’ Wait: 7 days
â”‚            â†’ Decision Split: Opened Email?
â”‚               â”śâ”€â”€ YES â†’ Email: Follow-up Offer
â”‚               â””â”€â”€ NO  â†’ SMS: Reminder
â””â”€â”€ Exit: Remove from journey
```

### Journey Entry Sources

| Source | Use Case |
|---|---|
| Data Extension | Batch send to list |
| Salesforce Data | Triggered by CRM events |
| API Event | Real-time from external system |
| Audience | Data Cloud segment |
| CloudPages | Form submission |

## AMPscript

### Variable & Personalization

```
%%[
VAR @firstName, @lastName, @accountName
SET @firstName = AttributeValue("FirstName")
SET @lastName = AttributeValue("LastName")
SET @accountName = AttributeValue("Account_Name")
]%%

Hello %%=v(@firstName)=%% %%=v(@lastName)=%%,

Thank you for being a valued customer of %%=v(@accountName)=%%.
```

### Conditional Content

```
%%[
VAR @tier
SET @tier = AttributeValue("Loyalty_Tier")

IF @tier == "Gold" THEN
]%%
    <p>As a Gold member, enjoy 20% off your next purchase.</p>
%%[
ELSEIF @tier == "Silver" THEN
]%%
    <p>As a Silver member, enjoy 10% off your next purchase.</p>
%%[
ELSE
]%%
    <p>Join our loyalty program for exclusive discounts.</p>
%%[
ENDIF
]%%
```

### Lookup Functions

```
%%[
/* Lookup from Data Extension */
VAR @productName
SET @productName = Lookup("Products_DE", "ProductName", "ProductId", @productId)

/* Lookup rows (multiple results) */
VAR @rows
SET @rows = LookupRows("Order_History_DE", "ContactId", @subscriberKey)

FOR @i = 1 TO RowCount(@rows) DO
    VAR @row
    SET @row = Row(@rows, @i)
    /* Process each row */
NEXT @i
]%%
```

## Data Extensions

### Definition

| Column | Data Type | Use |
|---|---|---|
| SubscriberKey | Text (254) | Primary key, maps to Contact ID |
| EmailAddress | EmailAddress | Subscriber email |
| FirstName | Text (100) | Personalization |
| Loyalty_Tier | Text (50) | Segmentation |
| Last_Purchase_Date | Date | Journey triggers |

### SQL Query (Automation Studio)

```sql
SELECT
    c.Id AS SubscriberKey,
    c.Email AS EmailAddress,
    c.FirstName,
    c.LastName,
    a.Name AS Account_Name,
    a.Loyalty_Tier__c AS Loyalty_Tier
FROM Contact_Salesforce c
JOIN Account_Salesforce a ON c.AccountId = a.Id
WHERE c.HasOptedOutOfEmail = 'false'
  AND c.Email IS NOT NULL
```

## Tracking & Analytics

| Metric | Description |
|---|---|
| Open Rate | Unique opens / delivered |
| Click Rate | Unique clicks / delivered |
| Bounce Rate | Bounces / sent |
| Unsubscribe Rate | Unsubs / delivered |
| Conversion Rate | Custom events / delivered |

## Cross-Skill References

- For CRM email templates: see **sf-email**
- For CRM data sync: see **sf-data**
- For Data Cloud segments: see **sf-data-cloud**
- For Connected Apps (MC Connect): see **sf-connected-apps**
