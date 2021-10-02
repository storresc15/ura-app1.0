/*******************************************************************************
Class Name      : SupportService
Description     : Main Support Service Interface
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public with sharing class SupportService {
  public static void setSupportEntitlement(Set<Id> caseIds) {
    service().setSupportEntitlement(caseIds);
  }

  private static ISupportService service() {
    return (ISupportService) Application.Service.newInstance(
      ISupportService.class
    );
  }
}