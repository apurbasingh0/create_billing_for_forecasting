# 🔄 TriggerOpportunityHandler

## Overview

This Apex handler and trigger logic automatically creates or updates **Billing_Details__c** records when an `Opportunity` is updated with billing information.

---

## 🔧 Functionality

- Trigger runs **after update** on `Opportunity`.
- Applies only once per execution (controlled by a static flag).
- Supports `Power Business Units`:  
  `CMS`, `WD`, `SWG`, `WH`, `WCT`, `IAQ`, `EVC`, `Lighting`
- For each related business unit and billing month (`N`, `N_1`, `N_2`), it:
  - **Updates existing** `Billing_Details__c` if it exists.
  - **Creates new** `Billing_Details__c` if it doesn't.

---
---
💡 Notes
Dynamically accesses fields using SObject.get() based on naming patterns.

Avoids duplicate inserts and updates.

Only processes Opportunities belonging to one of the specified business units.

Billing fields must follow consistent naming:

PLSI_<BU>_Expected_Billing_Date__c

Expected_Billing_Date_<month>_<BU>__c

📂 Methods
createBilling(List<Opportunity> oppList, Map<Id, Opportunity> oldMap)
Main handler that checks business unit and month, then delegates to:

updateBillingMethod(...): updates existing billing records.

createBillingMethod(...): creates new billing records if data is available.

✅ Best Practices
Ensure custom fields exist and match naming conventions.

Confirm trigger is deployed only once to avoid multiple executions.

Use field-level security and null checks as needed.

---

