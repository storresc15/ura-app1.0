@isTest
public class BillFromOppIntegrationTest {
  @isTest
  static void testBillCreationFromOpportunity() {
    Opportunity opp = new Opportunity(
      Name = 'Test Opp',
      Amount = 2400,
      StageName = 'Prospecting',
      CloseDate = Date.today(),
      Project_Type__c = 'Salesforce_Implementation',
      Planned_Start_Date__c = Date.today()
    );
    insert opp;

    Opportunity opp1 = [SELECT ID, StageName FROM Opportunity LIMIT 1];
    opp1.StageName = 'Closed Won';
    update opp1;
  }
}
