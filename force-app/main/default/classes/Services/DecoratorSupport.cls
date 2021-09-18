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

  public DecoratorSupport(
    TicketSupport s,
    Integer totalCasePerMonth,
    String supportName
  ) {
    support = s;
    totalCase = totalCasePerMonth;
    //To be updated with the right metadata tyoe to get the decorator details
  }

  public override Double getCost() {
    return 80.0 * totalCase + support.getCost();
  }
}
