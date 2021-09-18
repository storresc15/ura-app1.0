/*******************************************************************************
Class Name      : DecoratorSupport
Description     : Decorator support class used as a single decorator class to be used as main decorator based on custom metadata to add the price of the tickets
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing class DecoratorSupport extends TicketSupport {
  TicketSupport support;
  Integer totalCase = 1;
  Specific_Support__mdt specificSupport;

  public DecoratorSupport(
    TicketSupport s,
    Integer totalCasePerMonth,
    String supportName
  ) {
    this.support = s;
    this.totalCase = totalCasePerMonth;
    //To be updated with the right metadata tyoe to get the decorator details
    this.specificSupport = Specific_Support__mdt.getInstance(supportName);
  }

  public override Double getCost() {
    return specificSupport.Ticket_Cost__c * totalCase + support.getCost();
  }
}
