/*********************************************************************************
Class Name      : Credomatic_Async_QueueableProcessor
Description     : Main queuable service class, provides queuable support based on the async request object
        Can provide also callout support for integrations
Created By      : Sebastian Torres
Created Date    : 2021-04-14 
Modification Log: 
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-04-14              Initial version
*********************************************************************************/
public without sharing class Async_QueueableProcessor implements queueable, Database.AllowsCallouts {
  @testvisible
  private static Boolean fakeException = false; // This static variable is added to test exception handling

  public void execute(QueueableContext context) {
    //if(!Credomatic_Application.appEnabled) return; // On/off switch
    List<AsyncRequest__c> requests;
    try {
      requests = [
        SELECT ID, AsyncType__c, Params__c
        FROM AsyncRequest__c
        WHERE Error__c = FALSE AND CreatedById = :UserInfo.getUserId()
        LIMIT 1
        FOR UPDATE
      ];
    } catch (Exception ex) {
      return;
    }
    if (requests.size() == 0)
      return;

    AsyncRequest__c currentRequest = requests[0];

    try {
      AsyncJob job = AsyncJobFactory.getInstance(currentRequest.AsyncType__c);
      job.executeAsyncProcess(currentRequest);

      if (test.isRunningTest() && fakeException)
        system.debug(requests[20000].id);

      delete currentRequest;
      // Optional
      database.emptyRecycleBin(new List<ID>{ currentRequest.id });
    } catch (Exception ex) {
      currentRequest.Error__c = true;
      currentRequest.Error_Message__c = ex.getMessage();
      update currentRequest;
    }

    List<AsyncRequest__c> moreRequests = [
      SELECT ID, AsyncType__c, Params__c
      FROM AsyncRequest__c
      WHERE
        Error__c = FALSE
        AND ID != :currentRequest.id
        AND CreatedById = :UserInfo.getUserId()
      LIMIT 1
    ];

    if (moreRequests.size() == 0)
      return;

    try {
      enqueueGoingAsync(context.getJobId());
    } catch (Exception ex) {
      tryToQueue();
    }
  }

  public static void enqueueGoingAsync(ID currentJobId) {
    List<AsyncApexJob> jobs = [
      SELECT ID, Status, ExtendedStatus
      FROM AsyncApexJob
      WHERE
        JobType = 'Queueable'
        AND (status = 'Queued'
        OR Status = 'Holding')
        AND CreatedById = :userinfo.getUserID()
        AND ApexClass.Name = 'Async_QueueableProcessor'
        AND ID != :currentJobId
      LIMIT 1
    ];
    if (jobs.size() == 1)
      return; // Already have one queued that isn't this one.

    system.enqueueJob(new Async_QueueableProcessor());
  }

  @future
  private static void tryToQueue() {
    //if(!Credomatic_Application.appEnabled) return; // On/off switch
    try {
      if (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0)
        enqueueGoingAsync(null);
    } catch (Exception ex) {
      // Wait for someone else to make a request...
      // Or maybe use scheduled Apex?
    }
  }
}
