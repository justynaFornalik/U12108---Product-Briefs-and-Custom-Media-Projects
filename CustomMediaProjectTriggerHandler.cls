/**
   @author Original: Justyna F 
   @date Original: 16 Dec 2018
   @description Class to handle updates to Project__c object in order to grant access to that project to all Product Briefs creators related to the same opportunity.
*/

public with sharing class CustomMediaProjectTriggerHandler {
	public static void onAfterInsert(List<Project__c> projectsList) {
		Set<Id> projectsIds = new Set<Id>();
		for(Project__c project: projectsList) {
			projectsIds.add(project.Id);
		}
		List<Project__c> customMediaProjects = [SELECT Id, Related_Opportunity__c FROM Project__c WHERE Id in: projectsIds];
		List<Id> OpportunityIds = new List<Id>();
		Map<Id, List<Id>> OppsWithProductBriefsList = new Map<Id, List<Id>>();
		List<Project__Share> projectShares = new List<Project__Share>();
		for (Project__c cmproject: customMediaProjects) {
			OpportunityIds.add(cmproject.Related_Opportunity__c);
			List<Product_Brief__c> productBriefs = new List<SObject>();
			OppsWithProductBriefsList.put(cmproject.Related_Opportunity__c, productBriefs);
		}

		for(Product_Brief__c brief: [SELECT Id, Opportunity__c, createdById FROM Product_Brief__c WHERE Opportunity__c IN :OpportunityIds]) {
			OppsWithProductBriefsList.get(brief.Opportunity__c).add(brief);
		}

		for (Project__c proj: customMediaProjects) {
			for(Product_Brief__c pBrief: OppsWithProductBriefsList.get(proj.Related_Opportunity__c)) {
				Project__Share share = new Project__Share();
				share.ParentId = proj.Id;
				share.UserOrGroupId = pBrief.createdById;
				share.AccessLevel = 'All';
				projectShares.add(share);
			}
		}
		Database.insert(projectShares, false);
	}
}