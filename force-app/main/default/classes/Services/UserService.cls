/*******************************************************************************
Class Name      : ProjectService
Description     : Main Project Service Class to be used on the application
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
--------------------------------------------------------------------------------
Developer                   Date                   Description
--------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*******************************************************************************/
public with sharing class UserService {
  public static void activateUserFromContact(Set<Id> conIds) {
    service().activateUserFromContact(conIds);
  }
  public static void deactivateUserFromContact(Set<Id> conIds) {
    service().deactivateUserFromContact(conIds);
  }

  private static IUserService service() {
    return (IUserService) Application.Service.newInstance(IUserService.class);
  }
}
