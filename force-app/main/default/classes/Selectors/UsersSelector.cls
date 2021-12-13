/*******************************************************************************
Class Name      : UsersSelector
Description     : Main Selector for User object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05 
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*******************************************************************************/
public inherited sharing class UsersSelector extends ApplicationSelector {
  public UsersSelector() {
    super();
  }

  public UsersSelector(Boolean includeFieldSetFields) {
    super(includeFieldSetFields);
  }

  //To be reviewed the required fields on the queries
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      User.Id,
      User.FirstName,
      User.LastName,
      User.ProfileId,
      User.IsActive,
      User.Email,
      User.Title,
      User.ContactId,
      User.Username,
      User.ContactId,
      User.Alias
    };
  }

  public Schema.SObjectType getSObjectType() {
    return User.sObjectType;
  }

  public List<User> selectById(Set<ID> idSet) {
    return (List<User>) selectSObjectsById(idSet);
  }
  //Method used to query by contact Ids
  public List<User> selectByContactId(Set<Id> conIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('ContactId IN :conIds');
    return (List<User>) Database.query(query.toSOQL());
  }

  public List<User> selectByIdWithAccountId(Set<Id> idSet) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id IN :idSet');
    query.selectField('contact.AccountId');
    return (List<User>) Database.query(query.toSOQL());
  }

  public Map<Id, User> selectyByContactIdWithPermissionSetsMap(Set<Id> conIds) {
    Map<Id, User> resultMap = new Map<Id, User>();
    for (User u : [
      SELECT
        ID,
        USERNAME,
        ContactId,
        (SELECT ID, PermissionSetId FROM PermissionSetAssignments)
      FROM USER
      WHERE ContactId IN :conIds
    ]) {
      resultMap.put(u.contactId, u);
    }
    return resultMap;
  }

  //Method to call for users with permission sets
  public List<User> selectyByContactIdWithPermissionSets(Set<Id> conIds) {
    Set<String> permissionSetFields = new Set<String>{
      'Id',
      'PermissionSetId'
    };
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('ContactId IN :conIds');
    fflib_QueryFactory rsQF = query.subSelectQuery('PermissionSetAssignments')
      .selectFields(permissionSetFields);
    return (List<User>) Database.query(query.toSOQL());
  }
}
