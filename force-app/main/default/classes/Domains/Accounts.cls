/*********************************************************************************
Class Name      : Accounts
Description     : Main Domain class for Account Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*********************************************************************************/
public inherited sharing class Accounts extends ApplicationDomain {
    public Accounts(List<Account> accounts) {
        super(accounts);
    }

    //Defaulting field values on insert
    public override void onApplyDefaults() {

    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }
}