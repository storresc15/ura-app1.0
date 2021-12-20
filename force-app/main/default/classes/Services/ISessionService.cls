/*******************************************************************************
Class Name      : ISessionService
Description     : Main Support Session Interface
Created By      : Sebastian Torres
Created Date    : 2021-12-15
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-12-15              Initial version
*******************************************************************************/
public interface ISessionService {
  PermissionInfoBuilder.SessionInformationWrapper getSessionInfo();
}
