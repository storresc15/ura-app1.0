/*******************************************************************************
Class Name      : Accounts
Description     : Main Domain class for Account Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*******************************************************************************/
public inherited sharing class Accounts extends ApplicationDomain {
  public Accounts(List<Account> accounts) {
    super(accounts);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
    SupportService.setEntitlementSupportOnAccount(
      getQualifiedAccountsForEntitlementChange(
        (List<Account>) Records,
        existingRecords
      )
    );
  }

  public Set<Id> getQualifiedAccountsForEntitlementChange(
    List<Account> Records,
    Map<Id, sObject> existingRecords
  ) {
    Set<Id> selectedAccounts = new Set<Id>();
    Map<Id, Account> accountsOldMap = new Map<ID, Account>(
      (List<Account>) existingRecords.values()
    );
    for (Account acc : Records) {
      if (acc.SLA__c != accountsOldMap.get(acc.id).SLA__c) {
        selectedAccounts.add(acc.id);
      }
    }
    return selectedAccounts;
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Accounts(sObjectList);
    }
  }
}
