/*******************************************************************************
Class Name      : AccountsSelector
Description     : Main Selector for Account object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
Sebastian                 2021-11-13              Added the select by id with contacts
*******************************************************************************/
public inherited sharing class AccountsSelector extends ApplicationSelector {
  public AccountsSelector() {
    super();
  }

  public AccountsSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Account.Description,
      Account.Id,
      Account.Name,
      Account.OwnerId,
      Account.AnnualRevenue,
      Account.BillingPostalCode,
      Account.SLA__c
    };
  }
  public Schema.SObjectType getSObjectType() {
    return Account.sObjectType;
  }

  //Method used to query by contact Ids
  public List<Account> selectAccountWithCasesAndEntitlements(Set<Id> accIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id IN :accIds');

    fflib_QueryFactory rsQF = query.subSelectQuery('Cases')
      .selectFields(new Set<String>{ 'Id', 'entitlementid' })
      .setCondition('AccountId in :accIds');

    return (List<Account>) Database.query(query.toSOQL());
  }

  public List<Account> selectAccountWithContacts(Set<Id> accIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id IN :accIds');

    fflib_QueryFactory rsQF = query.subSelectQuery('Contacts')
      .selectFields(new Set<String>{ 'Id', 'AccountId' })
      .setCondition('AccountId in :accIds');

    return (List<Account>) Database.query(query.toSOQL());
  }

  public List<Account> selectById(Set<ID> idSet) {
    return (List<Account>) selectSObjectsById(idSet);
  }

  //Method for the billing service used in batch
  public Database.QueryLocator queryLocatorAccountReadyToBill() {
    return Database.getQueryLocator(
      newQueryFactory().setCondition('Active__c = \'\'Yes\'\'').toSOQL()
    );
  }

  public List<Account> selectAccountWithCasesForBilling(Set<Id> accIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id IN :accIds');

    fflib_QueryFactory rsQF = query.subSelectQuery('Cases')
      .selectFields(new Set<String>{ 'Id', 'Project__c', 'AccountId' })
      .setCondition(
        'AccountId in :accIds AND Project__c = NULL AND Bill__c = NULL'
      );

    return (List<Account>) Database.query(query.toSOQL());
  }
}
