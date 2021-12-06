global with sharing class BillingSupportProjects_BatchService implements System.Schedulable, Database.Batchable<SObject>, Database.Stateful {
  // Simple job log for errors
  private List<JobError> jobErrors = new List<JobError>();

  global void execute(SchedulableContext sc) {
    // Start the job once the scheduled time has arrived
    Database.executeBatch(new Billing_BatchService());
  }

  public Database.QueryLocator start(Database.BatchableContext context) {
    // Obtain appropriate query locator from the selector
    return new ProjectsSelector().queryLocatorProjectsReadyToBill();
  }

  public void execute(
    Database.BatchableContext context,
    List<agf__PPM_Project__c> projects
  ) {
    try {
      // Opportunities ready to be invoiced
      Set<Id> projectsToBillIds = new Map<Id, SObject>(projects).keySet();

      // Create invoices
      BillingService.generateBillFromSupportProject(projectsToBillIds);
    } catch (Exception e) {
      // Capture context and error for reporting once job complete
      JobError jobError = new JobError();
      jobError.records = opps;
      jobError.message = e.getMessage();
      jobErrors.add(jobError);
    }
  }

  public void finish(Database.BatchableContext context) {
    // Simple notification of any errors received via email
    if (jobErrors.size() > 0) {
      // Email address from user
      Map<Id, String> usersEmail = new UsersSelector()
        .getUsersEmail(new Set<Id>{ UserInfo.getUserId() });
      // Construct email body
      String emailBody = '';
      for (JobError jobError : jobErrors) {
        List<String> failed = new List<String>();
        for (agf__PPM_Project__c project : jobError.records) {
          failed.add(project.Name);
        }
        emailBody += String.format(
          '<p>Error {0} occurred during the processing of Project {1}</p>',
          new List<String>{ jobError.message, String.join(failed, ',') }
        );
      }
      // Send email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(
        new List<String>{ usersEmail.get(UserInfo.getUserId()) }
      );
      mail.setReplyTo(usersEmail.get(UserInfo.getUserId()));
      mail.setSenderDisplayName(UserInfo.getUserName());
      mail.setSubject('Create Invoice Job Failures');
      mail.setHtmlBody(emailBody);
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }
  }

  /**
   * Simple wrapper class containing the error message and the records in scope at the time
   **/
  public class JobError {
    public String message;
    public List<Opportunity> records;
  }
}
