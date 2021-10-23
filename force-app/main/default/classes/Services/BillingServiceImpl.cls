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

    //Iterate through them and get the required information to create Bill record

    //Call if there is some required metadata to build this(Discounts etc)

    //Based on record information and custom  metadata information build the logic to get the information for billing

    //Use uow and domain layer to have the actual build of the record

    //Commit the records
  }

  public void generateBillFromSupportProject(Set<Id> projectIds) {
  }

  public void generateBillFromSupportTickets(Set<Id> caseIds) {
  }

  /*
    Following method is not included in the Interface contract yet, should be implemented once we have the billing api running--- this method will be called from external system and will handle the response to create a bill record in SFDC (Consider also the global)
    global void handleBillCreationFromAPI(Set<Id> recordIds) {

    }

    */
}
