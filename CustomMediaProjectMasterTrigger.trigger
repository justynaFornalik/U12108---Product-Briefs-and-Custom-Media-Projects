/**
   @author Original: Justyna Fornalik GEHC
   @date Original: 15 Dec 2018
   @description This trigger is used to handle trigger actions for Custom Media Projects
*/


trigger CustomMediaProjectMasterTrigger on Project__c (after insert) {
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            CustomMediaProjectTriggerHandler.onAfterInsert(trigger.new);
        }
    }
}