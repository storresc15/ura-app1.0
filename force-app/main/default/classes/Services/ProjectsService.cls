/*******************************************************************************
Class Name      : ProjectService
Description     : Main Project Service Class to be used on the application
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-08-05              Initial version
*******************************************************************************/
public with sharing class ProjectsService {
  public static void projectCheckout(Set<Id> oppIds) {
    service().projectCheckout(oppIds);
  }

  public static void handleProjectsAccessToUsers(Set<Id> projectids) {
    service().handleProjectsAccessToUsers(projectids);
  }

  private static IProjectsService service() {
    return (IProjectsService) Application.Service.newInstance(
      IProjectsService.class
    );
  }
}
