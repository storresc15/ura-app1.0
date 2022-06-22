/*******************************************************************************
Class Name      : Cases
Description     : Main Domain class for Case Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
-------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*******************************************************************************/
public inherited sharing class Cases extends ApplicationDomain {
  public Cases(List<Case> cases) {
    super(cases);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public override void onBeforeInsert() {
  }

  public override void onAfterInsert() {
    Map<Id, Case> caseMap = new Map<Id, Case>((List<Case>) Records);
    SupportService.setEntitlementsAssigments(caseMap.keySet());
  }

  public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
    SupportService.setSupportEntitlement(
      getQualifyingRecordsToUpdateEntitlement(
        (List<Case>) Records,
        existingRecords
      )
    );
    SupportService.calculateEntitlementCases(
      getQualifyingRecordsToCalculateRemainingCases(
        (List<Case>) Records,
        existingRecords
      )
    );
  }

  public Set<Id> getQualifyingRecordsToUpdateEntitlement(
    List<Case> Records,
    Map<Id, sObject> existingRecords
  ) {
    Set<Id> selectedCases = new Set<Id>();
    Map<Id, Case> casesOldMap = new Map<ID, Case>(
      (List<Case>) existingRecords.values()
    );
    for (Case c : Records) {
      if (
        c.EntitlementId == null ||
        c.EntitlementId != casesOldMap.get(c.id).EntitlementId
      ) {
        selectedCases.add(c.id);
      }
    }
    return selectedCases;
  }

  public set<Id> getQualifyingRecordsToCalculateRemainingCases(
    List<Case> Records,
    Map<Id, sObject> existingRecords
  ) {
    Set<Id> accIds = new Set<Id>();
    Map<Id, Case> casesOldMap = new Map<ID, Case>(
      (List<Case>) existingRecords.values()
    );
    for (Case c : Records) {
      if (c.Status != casesOldMap.get(c.id).Status) {
        accIds.add(c.AccountId);
      }
    }
    return accIds;
  }

  public void assignEntitlement(
    Case c,
    Id entitlementId,
    fflib_ISObjectUnitOfWork uow
  ) {
    system.debug('Called the assign Entitlement from Case Domain');
    c.EntitlementId = entitlementId;
    uow.registerDirty(c);
  }

  public void updateBilling(
    Case c,
    Bill__c bill,
    fflib_ISObjectUnitOfWork uow
  ) {
    c.Bill__c = bill.Id;
    uow.registerDirty(c, Case.Bill__c, bill);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Cases(sObjectList);
    }
  }
}
