/*********************************************************************************
Class Name      : Opportunities
Description     : Main Domain class for Opportunity Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*********************************************************************************/
public inherited sharing class Opportunities extends ApplicationDomain {
  public Opportunities(List<Opportunity> opportunities) {
    super(opportunities);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
    ProjectsService.projectCheckout(
      getQualifiedOpportunitiesForProjects(
        (List<Opportunity>) Records,
        existingRecords
      )
    );
    BillingService.generateBillFromProjectCheckout(
      getQualifiedOpportunitiesForProjects(
        (List<Opportunity>) Records,
        existingRecords
      )
    );
  }

  public Set<id> getQualifiedOpportunitiesForProjects(
    List<Opportunity> Records,
    Map<Id, sObject> existingRecords
  ) {
    Set<Id> selectedOpps = new Set<Id>();
    Map<Id, Opportunity> oppsOldMap = new Map<ID, Opportunity>(
      (List<Opportunity>) existingRecords.values()
    );
    for (Opportunity opp : Records) {
      if (
        opp.StageName == 'Closed Won' &&
        opp.StageName != oppsOldMap.get(opp.id).StageName
      ) {
        selectedOpps.add(opp.id);
      }
    }
    return selectedOpps;
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Opportunities(sObjectList);
    }
  }
}
