/*******************************************************************************
Class Name      : IBillingService
Description     : Main Billing Service Interface
Created By      : Sebastian Torres
Created Date    : 2021-10-22
Modification Log:
-------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-10-22              Initial version
*******************************************************************************/
public interface IBillingService {
  void generateBillFromProjectCheckout(Set<Id> oppIds);
  void generateBillFromSupportProject(Set<Id> projectIds);
  void generateBillFromSupportTickets(Set<Id> accIds);
  Double getBalanceForUraApp(Set<Id> accIds);
}
