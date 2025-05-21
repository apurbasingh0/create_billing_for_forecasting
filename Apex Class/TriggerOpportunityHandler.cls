/**********************************************************************************
* ClassName: TriggerOpportunityHandler
* Created By: Apurba Singh
* Created on: 11-03-2024
* Description:It is a helper class.
* Modified on :
* Modified by :
***********************************************************************************/
public class TriggerOpportunityHandler {
    public static Integer count = 0;
    public static boolean isFirstBilling = true;

    //added by apurba singh 
    //last modifed date: 11-03-2024
    //Description: Create billing details record when the billing details are filed on opportunity
    Public static void createBilling(list<opportunity> oppList, Map<id,opportunity> oldMap){
        try{
            set<Id> oppIds = new Set<Id>();
            for(Opportunity op:oppList){
                oppIds.add(op.Id);
            }
            
            List<string> powerBus = new List<string>{'CMS','WD','SWG','WH','WCT','IAQ','EVC','Lighting'};
                List<string> months = new List<string>{'N','N_1','N_2'};
                    //get billing details to the opportunity
                    Map<string, Billing_Details__c> billingMap = new Map<string,Billing_Details__c>();
            for(Billing_Details__c b:[select id, Business_Units__c ,opportunity__c,Month__c, Expected_Billing_Date__c, Expected_Billing_Value__c 
                                      from Billing_Details__c where Opportunity__c  In:oppIds ]){
                                          billingMap.put(b.opportunity__c+b.Business_Units__c+b.Month__c, b);
                                      }
            list<Billing_details__c> updateBillingList = new list<Billing_Details__c>();
            list<Billing_details__c> insertBillingList = new List<Billing_Details__c>();
            for(opportunity op:oppList){
                if(op.PLSI_Business_Unit__c == 'Power Project' || op.PLSI_Business_Unit__c == 'Power EV Project' || op.PLSI_Business_Unit__c == 'Power IAQ Project' || op.PLSI_Business_Unit__c == 'Lighting Project'){
                    for(string s:powerBus){
                        for (String m : months) {
                            String key = op.Id + s + m;
                            if(billingMap.containsKey(op.id+s+m)){
                                Billing_Details__c updatebd = updatebillingMethod(op,billingMap.get(key));
                                updateBillingList.add(updatebd);
                            }
                            else{
                                Billing_Details__c newBd = CreatebillingMethod(op, s, m);
                                if (newBd != null) {
                                    insertBillingList.add(newBd);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('updateBillingList'+updateBillingList);
            if (!updateBillingList.isEmpty() || updateBillingList.size()>0) {
                update updateBillingList;
            }
            if (!insertBillingList.isEmpty() || insertBillingList.size()>0) {
                insert insertBillingList;
            }
            
        }catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
        }
        
    }

    
    //to update the existing billing record
    public static Billing_Details__c UpdatebillingMethod(opportunity op, Billing_Details__c bd){
        try{
        String m = bd.Month__c;
        String bu = bd.Business_Units__c;
        Billing_Details__c newBd = new Billing_Details__c();
        newBd.id = bd.id;
        if (m == 'N') {
            newBd.Expected_Billing_Date__c = Date.valueof(op.get('PLSI_'+bd.Business_Units__c+'_Expected_Billing_Date__c'));
            newBd.Expected_Billing_Value__c = Integer.ValueOf(op.get('PLSI_'+bd.Business_Units__c+'_Expected_Billing_Value__c'));
        }
        else {
            newBd.Expected_Billing_Date__c = Date.valueof(op.get('Expected_Billing_Date_'+m+'_'+bu+'__c'));
            newBd.Expected_Billing_Value__c = Integer.ValueOf(op.get('Expected_Billing_Value_'+m+'_'+bu+'__c'));
        }
        if(bd!= newBd){
            return newBd;
        }
            
        }catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
            
        }
      
        return null;
    }
    
    //to create the new billing records
    public static Billing_Details__c createbillingMethod(opportunity op, string bu, string month){
        try{
 
        String dateFieldName = '';
        String valueFieldName = '';
        
        if (month == 'N') {
            dateFieldName = 'PLSI_' + bu + '_Expected_Billing_Date__c';
            valueFieldName = 'PLSI_' + bu + '_Expected_Billing_Value__c';
        } else {
            dateFieldName = 'Expected_Billing_Date_' + month + '_' + bu + '__c';
            valueFieldName = 'Expected_Billing_Value_' + month + '_' + bu + '__c';
        }
        if (op.get(dateFieldName) != null && op.get(valueFieldName) != null && op.get(valueFieldName) != 0 ) {
        Billing_Details__c newBd = new Billing_Details__c();
        newBd.Business_Units__c = bu;
        newBd.Opportunity__c = op.Id;
        newBd.Expected_Billing_Date__c = Date.valueOf(op.get(dateFieldName));
        newBd.Expected_Billing_Value__c = Integer.valueOf(op.get(valueFieldName));
        newBd.Month__c = month;

        return newBd;
    }
        
      /*  if(op.get('PLSI_'+bu+'_Expected_Billing_Date__c')!=null || op.get('PLSI_'+bu+'_Expected_Billing_Value__c')!=null){
            Billing_Details__c newBd = new Billing_Details__c();
            newBd.Business_Units__c = bu;
            newBd.Opportunity__c = op.id;
            newBd.Expected_Billing_Date__c = Date.ValueOf(op.get('PLSI_'+bu+'_Expected_Billing_Date__c'));
            newBd.Expected_Billing_Value__c = Integer.Valueof(op.get('PLSI_'+bu+'_Expected_Billing_Value__c'));
            newBd.Month__c = 'N';
            return newBd;            
        }else if(op.get('Expected_Billing_Date_'+month+'_'+bu+'__c')!=null || op.get('Expected_Billing_Value_'+month+'_'+bu+'__c')!=null){
            System.debug('Date:::'+month);
            Billing_Details__c newBd = new Billing_Details__c();
            newBd.Business_Units__c = bu;
            newBd.Opportunity__c = op.id;
            newBd.Expected_Billing_Date__c = Date.ValueOf(op.get('Expected_Billing_Date_'+month+'_'+bu+'__c'));
            newBd.Expected_Billing_Value__c = Integer.Valueof(op.get('Expected_Billing_Value_'+month+'_'+bu+'__c'));
            newBd.Month__c = month;
            return newBd;            
        }*/
        
        
        }catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
        }
        return null;
    }
    
   
      
    }