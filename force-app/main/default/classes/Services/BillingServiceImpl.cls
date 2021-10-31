/*******************************************************************************
Class Name      : BillingServiceImpl
Description     : Main Billing Service Implementation. This class will also leverage at some point integration with third party integration system still in development. It shoul gather input required from the platform to generate the billing information, will return as of 2021 the billing record, however, in the future this would be handled by third party integration and then reply from the third party app will generate the billing record in SFDC.
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-10-22            Initial version
*******************************************************************************/
public without sharing class BillingServiceImpl implements IBillingService {
  public void generateBillFromProjectCheckout(Set<Id> oppIds) {
    //Get the Opps from selector
    OpportunitiesSelector oppsSelector = (OpportunitiesSelector) Application.Selector.newInstance(
      Opportunity.SObjectTYpe
    );

    //Use uow and domain layer to have the actual build of the record
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    Billings bills = new Billings(new List<Bill__c>());

    //Call if there is some required metadata to build this(Discounts etc) ----

    //Iterate through them and get the required information to create Bill record
    for (Opportunity opp : oppsSelector.selectById(oppIds)) {
      if (opp.StageName == 'Closed Won') {
        bills.createBillFromOpportunity(opp, uow);
      }
    }

    //Based on record information and custom  metadata information build the logic to get the information for billing

    //Commit the records
    uow.commitWork();
  }

  public void generateBillFromSupportProject(Set<Id> projectIds) {
    //Call the project selector to get the records
    ProjectsSelector selector = (ProjectsSelector) Application.Selector.newInstance(
      agf__PPM_Project__c.sObjectType
    );

    //get the custom metadata for required information and discounts

    //Use uow and domain classes to delegate the creation of the Bill record
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    Billings bills = new Billings(new List<Bill__c>());
    Cases cases;

    //Iterate over the projects to get required informatio and create record
    //IMPORTANT!! Remember to replace the selector method with the one containing cases
    for (
      agf__PPM_Project__c project : selector.selectByIdWithCases(projectIds)
    ) {
      cases = new Cases(project.Cases__r);
      Double amount = CostSupportFactory.getTicketsCost(project.Cases__r);
      Bill__c bill = bills.createBillFromProjectSupport(project, uow, amount);
      for (case c : project.Cases__r) {
        cases.updateBilling(c, bill, uow);
      }
    }

    //commit the uow
    uow.commitWork();
  }

  public void generateBillFromSupportTickets(Account acc, Set<Id> caseIds) {
    //Use uow and domain classes to delegate the creation of the Bill record
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    Billings bills = new Billings(new List<Bill__c>());

    Double Amount = CostSupportFactory.getTicketsCost(caseIds);
    //Get additional information for the bill from AccountIds?? Or add a parameter to probably search for accounts rather than only case Ids.
    //Consider replacing the below method with the correct bill from cases implementation
    bills.createBillFromCases(acc, uow, amount);

    //commit the uow
    uow.commitWork();
  }

  /*Simple method to retrieve the total amount due to a customer in the URA Homepage dashboard */
  public Double getBalanceForUraApp(Set<Id> accIds) {
    BillingsSelector selector = (BillingsSelector) Application.Selector.newInstance(
      Bill__c.SObjectTYpe
    );
    Double result = 0;
    for (Bill__c bill : selector.selectByAccountId(accIds)) {
      result += bill.Amount__c;
    }
    return result;
  }

  /*
    Following method is not included in the Interface contract yet, should be implemented once we have the billing api running--- this method will be called from external system and will handle the response to create a bill record in SFDC (Consider also the global)
    global void handleBillCreationFromAPI(Set<Id> recordIds) {

        //Use uow and domain layer to have the actual build of the record
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        Billings bills = new Billings(new List<Bill__c>());
        bills.createBillFromOpportunity(opp, uow);
    }

    */
}
