/*********************************************************************************
Class Name      : AsyncJobFactory
Description     : Factory class for implementing the Async Jobs
Created By      : Sebastian Torres
Created Date    : 2021-04-14 
Modification Log: 
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-04-14              Initial version
*********************************************************************************/
public without sharing class AsyncJobFactory {
  public static AsyncJob getInstance(String jobName) {
    AsyncJob job = null;

    if (jobName == 'HandleUserPermission')
      job = new AsyncHandleProjectAccess();
    if (jobName == 'HandleUserActivation')
      job = new AsyncHandleUserCreation();
    if (jobName == 'HandleUserDeactivation')
      job = new AsyncHandleUserDeactivation();
    //implement rest of async processes

    return job;
  }
}
