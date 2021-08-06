/*********************************************************************************
Class Name      : OpportunitiesSelector
Description     : Main Selector for Opp object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*********************************************************************************/
public inherited sharing class OpportunitiesSelector extends ApplicationSelector
{
    public OpportunitiesSelector() {
        super();
    }
    
    public OpportunitiesSelector(Boolean includeFieldSetFields) {
		super(includeFieldSetFields);
	}
    
    //To be reviewed the required fields on the queries
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Opportunity.Id,
            Opportunity.Name,
            Opportunity.OwnerId    
             };
    }
    
    public Schema.SObjectType getSObjectType() {
        return Opportunity.sObjectType;
    }
    
    public List<Opportunity> selectById(Set<ID> idSet) {
        return (List<Opportunity>) selectSObjectsById(idSet);
    }
    
}