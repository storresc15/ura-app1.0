/*********************************************************************************
Class Name      : Opportunities
Description     : Main Domain class for Opportunity Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*********************************************************************************/
public inherited sharing class Opportunities extends ApplicationDomain {
    public Opportunities(List<Opportunity> opportunities) {
        super(opportunities);
    }

    //Defaulting field values on insert
    public override void onApplyDefaults() {

    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Opportunities(sObjectList);
        }
    }
}