/**********************************************************************************
* ClassName: PLSI_OpportunityTrigger
* Created By: Apurba Singh 
* Created on: 19-03-2023
* Description:It will call the helper class.
* Modified on :
* Modified by :
***********************************************************************************/
trigger PLSI_OpportunityTrigger on Opportunity (after insert,after delete,after update,before insert,before update) {

 if(Trigger.isUpdate && Trigger.isAfter)
{
    if(TriggerOpportunityHandler.isFirstBilling == true){
        TriggerOpportunityHandler.isFirstBilling = false;
        TriggerOpportunityHandler.createBilling(Trigger.New, trigger.oldmap);
        
    }

}
 
    
}