/*******************************************************************************
Class Name      : Contacts
Description     : Main Domain class for Contact Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*******************************************************************************/
public inherited sharing class Contacts extends ApplicationDomain {
  public Contacts(List<Contact> contacts) {
    super(contacts);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
    getQualifiedContactsAndUpdateUsers(
      (List<Contact>) Records,
      existingRecords
    );
  }

  public void getQualifiedContactsAndUpdateUsers(
    List<Contact> Records,
    Map<Id, sObject> existingRecords
  ) {
    Map<Id, Contact> contactsOldMap = new Map<ID, Contact>(
      (List<Contact>) existingRecords.values()
    );
    List<AsyncRequest__c> newAsyncRequests = new List<AsyncRequest__c>();
    List<String> textChangedIdsActivate = new List<ID>();
    List<String> textChangedIdsDeactivate = new List<ID>();
    for (Contact c : Records) {
      if (
        c.AccountId != null &&
        c.Active__c != contactsOldMap.get(c.id).Active__c
      ) {
        if (c.Active__c) {
          textChangedIdsActivate.add(c.Id);
          if (textChangedIdsActivate.size() > 100) {
            newAsyncRequests.add(
              new AsyncRequest__c(
                AsyncType__c = 'HandleUserActivation',
                Params__c = string.Join(textChangedIdsActivate, ',')
              )
            );
            textChangedIdsActivate.clear();
          }
        } else if (!c.Active__c) {
          textChangedIdsDeactivate.add(c.Id);
          if (textChangedIdsDeactivate.size() > 100) {
            newAsyncRequests.add(
              new AsyncRequest__c(
                AsyncType__c = 'HandleUserDeactivation',
                Params__c = string.Join(textChangedIdsDeactivate, ',')
              )
            );
            textChangedIdsDeactivate.clear();
          }
        }
      }
    }
    if (textChangedIdsActivate.size() > 0) {
      newAsyncRequests.add(
        new AsyncRequest__c(
          AsyncType__c = 'HandleUserActivation',
          Params__c = string.Join(textChangedIdsActivate, ',')
        )
      );
    }
    if (textChangedIdsDeactivate.size() > 0) {
      newAsyncRequests.add(
        new AsyncRequest__c(
          AsyncType__c = 'HandleUserDeactivation',
          Params__c = string.Join(textChangedIdsDeactivate, ',')
        )
      );
    }
    insert newAsyncRequests;
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Contacts(sObjectList);
    }
  }
}
