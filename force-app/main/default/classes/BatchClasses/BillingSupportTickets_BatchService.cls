global with sharing class BillingSupportTickets_BatchService implements System.Schedulable, Database.Batchable<SObject>, Database.Stateful {
  // Simple job log for errors
  private List<JobError> jobErrors = new List<JobError>();

  //Excecute - Main Excecute method
  global void execute(SchedulableContext sc) {
    // Start the job once the scheduled time has arrived
    Database.executeBatch(new BillingSupportTickets_BatchService());
  }

  public Database.QueryLocator start(Database.BatchableContext context) {
    // Obtain appropriate query locator from the selector
    return new AccountsSelector().queryLocatorAccountReadyToBill();
  }

  public void execute(Database.BatchableContext context, List<Account> accs) {
    try {
      // Opportunities ready to be invoiced
      Set<Id> accsToBill = new Map<Id, SObject>(accs).keySet();

      // Create invoices
      BillingService.generateBillFromSupportTickets(accsToBill);
    } catch (Exception e) {
      // Capture context and error for reporting once job complete
      JobError jobError = new JobError();
      jobError.records = accs;
      jobError.message = e.getMessage();
      jobErrors.add(jobError);
    }
  }

  public void finish(Database.BatchableContext context) {
    // Simple notification of any errors received via email
    if (jobErrors.size() > 0) {
      // Email address from user
      String usersEmail = UserInfo.getUserEmail();
      // Construct email body
      String emailBody = '';
      for (JobError jobError : jobErrors) {
        List<String> failedOpps = new List<String>();
        for (Account acc : jobError.records) {
          failedOpps.add(acc.Name);
        }
        emailBody += String.format(
          '<p>Error {0} occurred during the processing of Opportunities {1}</p>',
          new List<String>{ jobError.message, String.join(failedOpps, ',') }
        );
      }
      // Send email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(new List<String>{ usersEmail });
      mail.setReplyTo(usersEmail);
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
    public List<Account> records;
  }
}
