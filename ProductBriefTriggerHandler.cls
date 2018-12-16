Related/**
   @author Original: Justyna F 
   @date Original: 11 Dec 2018
   @description Class to handle updates to Product_Brief__c object in order to grant access (Read/Write) to the creator of the Product Brief to all Custom Media Projects (Project__c) related to the same opportunity
*/

public with sharing class ProductBriefTriggerHandler{

	public static void onAfterInsert(List<Product_Brief__c> productBriefsList) {
        Set<Id> productBriefsSet =  new Set<Id>();
        for(Product_Brief__c productBrief : productBriefsList) {
            productBriefsSet.add(productBrief.Id);
        }
		List<Product_Brief__c> productBriefs = [SELECT Id, createdById, Opportunity__c FROM Product_Brief__c WHERE Id IN :productBriefsSet];
		List<Id> OpportunityIds = new List<Id>();
		Map<Id,List<Id>> OppsWithProjectList = new Map<Id,List<Id>>();
		List<Project__Share> projectShares = new List<Project__Share>();
		for (Product_Brief__c brief: productBriefs) {
			OpportunityIds.add(brief.Opportunity__c);
            List<Project__c> projects = new List<SObject>();
            OppsWithProjectList.put(brief.Opportunity__c, projects);
		}

		 for(Project__c project: [SELECT Id, Related_Opportunity__c FROM Project__c WHERE Related_Opportunity__c IN :OpportunityIds]) {
            OppsWithProjectList.get(project.Related_Opportunity__c).add(project);
        }

        for (Product_Brief__c brief:productBriefs) { 
            for (User creator: brief.CreatedBy) {
            	for(Project__c project:OppsWithProjectList.get(brief.Opportunity__c)) {
            		Project__Share creatorShare = new Project__Share();
			        //Set the Id of record being shared
			        creatorShare.ParentId = project.Id;
			        //Set the ID of user or group being granted access
			        creatorShare.UserOrGroupId = brief.createdBy.Id;
			        //Set the access level
			        creatorShare.AccessLevel = 'All';
			        //Add objects to list for insert
			        projectShares.add(creatorShare); 
			        }
			    }
			}
		Database.insert(projectShares, false);
	}
}