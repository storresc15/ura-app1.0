/*******************************************************************************
Class Name      : AdminSupportFactory
Description     : Factory to return the details of the selected SLA from Account
Created By      : Sebastian Torres
Created Date    : 2021-09-24
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-24              Initial version
*******************************************************************************/
public without sharing class AdminSupportFactory {
  public static SupportDetails getSupportDetails(String supportType) {
    if (supportType == 'No Support' || supportType == null)
      return null;
    Support_Tier__mdt support = Support_Tier__mdt.getInstance(supportType);
    if (support == null)
      return null;

    SupportDetails details = new SupportDetails();
    details.AllowedTickets = support.Allowed_Tickets__c;
    details.DefaultDiscount = support.Default_Discount__c;
    details.EntitlementProcess = support.Entitlement_Process__c;

    return details;
  }

  public class SupportDetails {
    public Decimal AllowedTickets;
    public Decimal DefaultDiscount;
    public String EntitlementProcess;
  }
}
