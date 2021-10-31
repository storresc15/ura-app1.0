/*******************************************************************************
Class Name      : BillingsSelector
Description     : Main Selector for Bill object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-10-30
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-10-30              Initial version
*******************************************************************************/
public inherited sharing class BillingsSelector extends ApplicationSelector {
  public BillingsSelector() {
    super();
  }

  public BillingsSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Bill__c.Description__c,
      Bill__c.Id,
      Bill__c.Account__c,
      Bill__c.Amount__c,
      Bill__c.Name
    };
  }
  public Schema.SObjectType getSObjectType() {
    return Bill__c.sObjectType;
  }

  public List<Bill__c> selectById(Set<ID> idSet) {
    return (List<Bill__c>) selectSObjectsById(idSet);
  }

  public List<Bill__c> selectByAccountId(Set<ID> idSet) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Account__c IN :idSet');
    return (List<Bill__c>) Database.query(query.toSOQL());
  }
}
