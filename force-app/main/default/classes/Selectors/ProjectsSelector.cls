/*******************************************************************************
Class Name      : ProjectsSelector
Description     : Main Selector for Projects object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*******************************************************************************/
public inherited sharing class ProjectsSelector extends ApplicationSelector {
  public ProjectsSelector() {
    super();
  }

  public ProjectsSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      agf__PPM_Project__c.Id,
      agf__PPM_Project__c.Name,
      agf__PPM_Project__c.agf__Project_Summary__c,
      agf__PPM_Project__c.agf__Delivery_Scrum_Team__c,
      agf__PPM_Project__c.agf__Development_Lead__c,
      agf__PPM_Project__c.Account__c,
      agf__PPM_Project__c.Opportunity__c
    };
  }

  public Schema.SObjectType getSObjectType() {
    return agf__PPM_Project__c.sObjectType;
  }

  public List<agf__PPM_Project__c> selectById(Set<ID> idSet) {
    return (List<agf__PPM_Project__c>) selectSObjectsById(idSet);
  }
}
