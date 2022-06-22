/*******************************************************************************
Class Name      : EntitlementsSelector
Description     : Main Selector for Entitlement object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2022-06-13
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2022-06-13              Initial version
*******************************************************************************/
public inherited sharing class EntitlementsSelector extends ApplicationSelector {
  public EntitlementsSelector() {
    super();
  }

  public EntitlementsSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Entitlement.Id,
      Entitlement.Name,
      Entitlement.StartDate,
      Entitlement.EndDate,
      Entitlement.AccountId,
      Entitlement.AssetId,
      Entitlement.CreatedDate
    };
  }
  public Schema.SObjectType getSObjectType() {
    return Entitlement.sObjectType;
  }

  public List<Entitlement> selectById(Set<ID> idSet) {
    return (List<Entitlement>) selectSObjectsById(idSet);
  }

  public List<Entitlement> selectFromAccountIds(Set<ID> idSet) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('AccountId IN :idSet');
    return (List<Entitlement>) Database.query(query.toSOQL());
  }
}
