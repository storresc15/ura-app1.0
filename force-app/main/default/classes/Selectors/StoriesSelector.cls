/*******************************************************************************
Class Name      : StoriesSelector
Description     : Main Selector for Stirues object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-11-08  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-11-08              Initial version
*******************************************************************************/
public inherited sharing class StoriesSelector extends ApplicationSelector {
  public StoriesSelector() {
    super();
  }

  public StoriesSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      agf__ADM_Work__c.Id,
      agf__ADM_Work__c.Name,
      agf__ADM_Work__c.agf__Sprint__c,
      agf__ADM_Work__c.agf__Subject__c,
      agf__ADM_Work__c.agf__Details__c,
      agf__ADM_Work__c.agf__Status__c,
      agf__ADM_Work__c.agf__Due_Date__c,
      agf__ADM_Work__c.agf__Scrum_Team_Name__c,
      agf__ADM_Work__c.agf__Epic_Name__c,
      agf__ADM_Work__c.agf__Sprint_Name__c
    };
  }

  public Schema.SObjectType getSObjectType() {
    return agf__ADM_Work__c.sObjectType;
  }

  public List<agf__ADM_Work__c> selectById(Set<ID> idSet) {
    return (List<agf__ADM_Work__c>) selectSObjectsById(idSet);
  }

  public List<agf__ADM_Work__c> selectBySprintId(Set<ID> sprintIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('agf__Sprint__c IN :sprintIds');
    return (List<agf__ADM_Work__c>) Database.query(query.toSOQL());
  }
}
