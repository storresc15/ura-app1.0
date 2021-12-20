public without sharing class PermissionInfoBuilder {
  public SessionInformationWrapper theSessionInformation;

  public PermissionInfoBuilder() {
    theSessionInformation = new SessionInformationWrapper();
  }

  public PermissionInfoBuilder setUserType(String userType) {
    theSessionInformation.UserType = userType == 'CspLitePortal'
      ? 'Customer User'
      : 'Internal User';
    return this;
  }

  public PermissionInfoBuilder setLoginType(String loginType) {
    theSessionInformation.LoginType = loginType;
    return this;
  }

  public PermissionInfoBuilder setSessionId(String sessionId) {
    theSessionInformation.SessionId = sessionId;
    return this;
  }

  public PermissionInfoBuilder setLoginHistory(String loginHistory) {
    system.debug('Inside the login history: ' + loginHistory);
    this.theSessionInformation.LoginHistory = loginHistory == null ||
      loginHistory == ''
      ? ''
      : loginHistory;
    system.debug(
      'Returning this as login history: ' +
      this.theSessionInformation.LoginHistory
    );
    return this;
  }

  public PermissionInfoBuilder setIsLoggedInAsUser() {
    if (this.theSessionInformation.UserType == 'Customer User') {
      this.theSessionInformation.IsLoggedInAsUser = false;
      return this;
    } else if (this.theSessionInformation.LoginHistory == '') {
      this.theSessionInformation.IsLoggedInAsUser = true;
      return this;
    } else {
      system.debug(
        'Inside the setIsLoggedInAsUser:  the login history' +
        this.theSessionInformation.LoginHistory
      );
      this.theSessionInformation.IsLoggedInAsUser = false;
      return this;
    }
  }

  public PermissionInfoBuilder setHasPermission() {
    String parentSession = '';
    String userId = '';
    String sessionId = this.theSessionInformation.SessionId;
    system.debug('Inside setHasPermission: The session Id' + sessionId);

    if (this.theSessionInformation.UserType == 'Customer User') {
      this.theSessionInformation.HasPermission = true;
      return this;
    }
    if (
      this.theSessionInformation.UserType == 'Internal User' &&
      !this.theSessionInformation.IsLoggedInAsUser
    ) {
      this.theSessionInformation.HasPermission = true;
      return this;
    }

    if (this.theSessionInformation.IsLoggedInAsUser) {
      this.theSessionInformation.HasPermission = false;
      AuthSession authSession = [
        SELECT Id, LoginHistoryId, ParentId
        FROM AuthSession
        WHERE Id = :sessionId
        LIMIT 1
      ];
      parentSession = authSession.ParentId;

      AuthSession parentAuthSession = [
        SELECT Id, LoginHistoryId, UsersId
        FROM AuthSession
        WHERE Id = :parentSession
        LIMIT 1
      ];
      userId = parentAuthSession != null ? parentAuthSession.UsersId : null;
    }

    Map<Id, PermissionSet> psMap = new Map<Id, PermissionSet>(
      [
        SELECT ID, Name
        FROM PermissionSet
        WHERE
          Id IN (
            SELECT PermissionSetId
            FROM PermissionSetAssignment
            WHERE AssigneeId = :userId
          )
      ]
    );

    for (PermissionSet ps : psMap.values()) {
      if (ps.Name == 'LogInToExperience_Permission_RW') {
        this.theSessionInformation.HasPermission = true;
        return this;
      }
    }
    //this.theSessionInformation.HasPermission = false;

    return this;
  }

  public SessionInformationWrapper build() {
    return this.theSessionInformation;
  }

  public class SessionInformationWrapper {
    public String UserType;
    public String LoginType;
    public String SessionId;
    public String LoginHistory;
    public Boolean HasPermission;
    public Boolean IsLoggedInAsUser;
  }
}
