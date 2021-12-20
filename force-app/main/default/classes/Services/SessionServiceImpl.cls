/*******************************************************************************
Class Name      : SessionServiceImpl
Description     : Main Support Service Implementation
Created By      : Sebastian Torres
Created Date    : 2021-09-17
Modification Log:
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-09-17              Initial version
*******************************************************************************/
public without sharing class SessionServiceImpl implements ISessionService {
  public PermissionInfoBuilder.SessionInformationWrapper getSessionInfo() {
    Map<String, String> sessionMap = Auth.SessionManagement.getCurrentSession();

    PermissionInfoBuilder.SessionInformationWrapper sessionInfo = new PermissionInfoBuilder()
      .setUserType(sessionMap.get('UserType'))
      .setLoginType(sessionMap.get('LoginType'))
      .setSessionId(sessionMap.get('SessionId'))
      .setLoginHistory(sessionMap.get('LoginHistoryId'))
      .setIsLoggedInAsUser()
      .setHasPermission()
      .build();

    return sessionInfo;
  }
}
