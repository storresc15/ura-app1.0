/*******************************************************************************
Class Name      : SessionService
Description     : Main Session Service Interface
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing class SessionService {
  public static PermissionInfoBuilder.SessionInformationWrapper getSessionInfo() {
    return service().getSessionInfo();
  }

  private static ISessionService service() {
    return (ISessionService) Application.Service.newInstance(
      ISessionService.class
    );
  }
}
