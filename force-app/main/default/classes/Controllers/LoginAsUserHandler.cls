public without sharing class LoginAsUserHandler {
  @AuraEnabled(cacheable=true)
  public static SessionInfo getSessionInfo() {
    try {
      PermissionInfoBuilder.SessionInformationWrapper sessionInformation = SessionService.getSessionInfo();
      SessionInfo result = new SessionInfo();
      result.UserType = sessionInformation.UserType;
      result.IsLoggedInAsUser = sessionInformation.IsLoggedInAsUser;
      result.HasPermission = sessionInformation.HasPermission;

      return result;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  //Wrapper class to provide details to LWC

  public class SessionInfo {
    @AuraEnabled
    public String UserType;
    @AuraEnabled
    public Boolean HasPermission;
    @AuraEnabled
    public Boolean IsLoggedInAsUser;
  }
}
