/*********************************************************************************
Class Name      : Contacts
Description     : Main Domain class for Contact Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*********************************************************************************/
public inherited sharing class Contacts extends ApplicationDomain {
    public Contacts(List<Contact> contacts) {
        super(contacts);
    }

    //Defaulting field values on insert
    public override void onApplyDefaults() {

    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Contacts(sObjectList);
        }
    }
}