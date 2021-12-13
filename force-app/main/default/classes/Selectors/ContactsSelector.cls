/*******************************************************************************
Class Name      : ContactsSelector
Description     : Main Selector for Contact object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05 
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*******************************************************************************/
public inherited sharing class ContactsSelector extends ApplicationSelector {
  public ContactsSelector() {
    super();
  }

  public ContactsSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Contact.Id,
      Contact.FirstName,
      Contact.LastName,
      Contact.OwnerId,
      Contact.Active__c,
      Contact.Email,
      Contact.Title,
      Contact.Active__c,
      Contact.AccountId
    };
  }

  public Schema.SObjectType getSObjectType() {
    return Contact.sObjectType;
  }

  public List<Contact> selectById(Set<ID> idSet) {
    return (List<Contact>) selectSObjectsById(idSet);
  }
}
