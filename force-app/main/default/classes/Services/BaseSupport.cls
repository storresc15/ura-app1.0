/*******************************************************************************
Class Name      : BaseSupport
Description     : Salesforce support class
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
--------------------------------------------------------------------------------
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing class BaseSupport extends TicketSupport {
  Integer totalCase = 1;
  BaseSupport__mdt baseSupport;

  public BaseSupport(Integer totalCasePerMonth, String support) {
    this.totalCase = totalCasePerMonth;

    this.baseSupport = BaseSupport__mdt.getInstance(support);
  }

  //Total cost to resolve one case
  public override Double getCost() {
    return baseSupport.Ticket_Cost__c * totalCase;
  }

  public override String getDescription() {
    return 'This class represents information about base tickets';
  }
}
