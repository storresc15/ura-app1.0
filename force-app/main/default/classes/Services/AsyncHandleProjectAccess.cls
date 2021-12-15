/*******************************************************************************
Class Name      : Credomatic_AsyncAddressValidation
Description     : Address Validation Async support class
Created By      : Sebastian Torres
Created Date    : 2021-04-14 
Modification Log: 
------------------------------------------------------------------------------- 
Developer                   Date                   Description
-------------------------------------------------------------------------------
Sebastian                 2021-04-14              Initial version
*******************************************************************************/
public class AsyncHandleProjectAccess extends AsyncJob {
  public override void executeAsyncProcess(AsyncRequest__c request) {
    //Checking limits
    if (!limitsAvailable())
      return;

    futureUpdateCall(request.Params__c);
  }

  @future
  static void futureUpdateCall(String params) {
    List<ID> idsAfterSplit = params.split(',');
    Set<Id> projectIds = new Set<Id>();

    for (id id : idsAfterSplit) {
      projectIds.add(id);
    }

    ProjectsService.handleProjectsAccessToUsers(projectIds);
  }
}
