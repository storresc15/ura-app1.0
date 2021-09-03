/*********************************************************************************
Class Name      : Projects
Description     : Main Domain class for Project Object
Created By      : Sebastian Torres
Created Date    : 2021-09-03  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-03              Initial version
*********************************************************************************/
public inherited sharing class Projects extends ApplicationDomain {
    public Projects(List<agf__PPM_Project__c> projects) {
        super(projects);
    }

    //Defaulting field values on insert
    public override void onApplyDefaults() {

    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Projects(sObjectList);
        }
    }
}