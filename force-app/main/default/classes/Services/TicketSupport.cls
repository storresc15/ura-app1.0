/*******************************************************************************
Class Name      : TicketSupport
Description     : Abstract class to be inherited by all the core support models
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing abstract class TicketSupport {
  public virtual String getDescription() {
    return 'This is the base abstract class';
  }

  public abstract Double getCost();
}
