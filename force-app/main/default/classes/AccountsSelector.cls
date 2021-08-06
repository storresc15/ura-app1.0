/*********************************************************************************
Class Name      : AccountsSelector
Description     : Main Selector for Account object, handles all queries for the specific sObject - Use of fflib selector layer
Created By      : Sebastian Torres
Created Date    : 2021-08-05
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*********************************************************************************/
public inherited sharing class AccountsSelector extends ApplicationSelector
{
    
    public AccountsSelector() {
        super();
    }
    
    public AccountsSelector(Boolean includeFieldSetFields) {
		super(includeFieldSetFields);
	}
    
    //To be reviewed the required fields on the queries
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Description,
            Account.Id,
            Account.Name,
            Account.OwnerId,    
            Account.AnnualRevenue,
            Account.BillingPostalCode   };
    }
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
    
    public List<Account> selectById(Set<ID> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }
}