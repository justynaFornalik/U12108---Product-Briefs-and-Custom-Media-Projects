/**
   @author Original: J Fornalik GEHC
   @date Original: 11 Dec 2018
   @description This trigger is used to handle trigger actions for Product Briefs
*/


trigger ProductBriefMasterTrigger on Product_Brief__c (after insert) {

    if(trigger.isAfter){
        if(trigger.isInsert){
            ProductBriefTriggerHandler.onAfterInsert(trigger.new); //why cannot I pass trigger.newMap?       
        }
    }
}s