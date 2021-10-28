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

  public void createBillFromOpportunity(
    Opportunity opp,
    fflib_ISObjectUnitOfWork uow
  ) {
    Bill__c bill = new Bill__c();
    //Add rest of fields from opp or custom metadata
    bill.Account__c = opp.AccountId;
    bill.amount__c = opp.Amount;
    bill.Description__c =
      'Bill Created Automatically for Account: ' +
      opp.AccountId +
      ' From Opportunity: ' +
      opp.Name;
    uow.registerNew(bill);
  }

  public Bill__c createBillFromProjectSupport(
    agf__PPM_Project__c project,
    fflib_ISObjectUnitOfWork uow,
    Double amount
  ) {
    Bill__c bill = new Bill__c();
    //Add rest of fields from opp or custom metadata
    bill.Account__c = project.Account__c;
    bill.amount__c = amount;
    bill.Description__c =
      'Bill Created Automatically for Account: ' +
      project.Account__c +
      ' From Project Support: ' +
      project.Name;
    uow.registerNew(bill);
    return bill;
  }

  public Bill__c createBillFromCases(
    Account acc,
    fflib_ISObjectUnitOfWork uow,
    Double amount
  ) {
    Bill__c bill = new Bill__c();
    bill.Account__c = acc.id;
    bill.amount__c = amount;
    bill.Description__c =
      'Bill Created Automatically for Account: ' +
      acc.Name +
      ' From Cases: ';
    uow.registerNew(bill);
    return bill;
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Billings(sObjectList);
    }
  }
}
