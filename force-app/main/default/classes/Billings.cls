/*******************************************************************************
Class Name      : Billings
Description     : Main Domain class for Bill Object
Created By      : Sebastian Torres
Created Date    : 2021-09-24  
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-24              Initial version
*******************************************************************************/
public inherited sharing class Billings extends ApplicationDomain {
  public Billings(List<Bill__c> bills) {
    super(bills);
  }

  //Defaulting field values on insert
  public override void onApplyDefaults() {
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Billings(sObjectList);
    }
  }
}
