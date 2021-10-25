/*******************************************************************************
Class Name      : BillingService
Description     : Main Billing Service Interface
Created By      : Sebastian Torres
Created Date    : 2021-10-22
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-10-22              Initial version
*******************************************************************************/
public with sharing class BillingService {
  public static void generateBillFromProjectCheckout(Set<Id> oppIds) {
    service().generateBillFromProjectCheckout(oppIds);
  }

  public static void generateBillFromSupportProject(Set<Id> projectIds) {
    service().generateBillFromSupportProject(projectIds);
  }

  public static void generateBillFromSupportTickets(Set<Id> caseIds) {
    service().generateBillFromSupportTickets(caseIds);
  }

  private static IBillingService service() {
    return (IBillingService) Application.Service.newInstance(
      IBillingService.class
    );
  }
}