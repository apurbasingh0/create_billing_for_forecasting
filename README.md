"# create_billing_for_forecasting" 
🔄 TriggerOpportunityHandler
Purpose:
Automatically manage Billing Details records related to Opportunity when specific billing fields are updated.
🔧 What It Does:
•	On Opportunity update (After Trigger):
o	Checks if the Opportunity belongs to one of the Power Business Units: CMS, WD, SWG, WH, WCT, IAQ, EVC, Lighting.
o	For each Opportunity and business unit:
	If a matching Billing record exists, it updates it using current Opportunity field values.
	If not, it creates a new Billing_Details__c record with values pulled from custom fields on the Opportunity.
•	Operates for billing months N, N_1, and N_2.
🧠 Key Features:
•	Dynamic field access using op.get(fieldName) to avoid hardcoding.
•	Avoids redundant inserts or updates by checking if field values exist and have changed.
•	Uses a static flag isFirstBilling to run logic only once per trigger execution (prevents recursion).
📌 Notes:
•	Ensure all custom fields like PLSI_<BU>_Expected_Billing_Date__c and Expected_Billing_Date_N_1_<BU>__c exist and are populated correctly.
•	Field names are dynamically constructed — field naming consistency is crucial.
