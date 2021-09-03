/*********************************************************************************
Class Name      : CasesSelector
Description     : Main Selector for Case object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*********************************************************************************/
public inherited sharing class CasesSelector extends ApplicationSelector
{
    
    public CasesSelector() {
        super();
    }
    
    public CasesSelector(Boolean includeFieldSetFields) {
		super(includeFieldSetFields);
	}
    
    //To be reviewed the required fields on the queries
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Case.Description,
            Case.Id,
            Case.Subject,
            Case.OwnerId,    
            Case.Priority,
            Case.AccountId,
            Case.ContactId   };
    }
    public Schema.SObjectType getSObjectType() {
        return Case.sObjectType;
    }
    
    public List<Case> selectById(Set<ID> idSet) {
        return (List<Case>) selectSObjectsById(idSet);
    }
}