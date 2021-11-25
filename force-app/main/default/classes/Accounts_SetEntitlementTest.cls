@IsTest(SeeAllData=true)
public class Accounts_SetEntitlementTest {
  @IsTest
  static void testSLAChangeOnAccount() {
    Account a = new Account(Name = 'Test Account');
    insert a;

    Account aUpdated = [SELECT ID, SLA__c FROM Account LIMIT 1];
    aUpdated.SLA__c = 'Gold';
    update aUpdated;
  }

  @IsTest
  static void testSLAWithCasesChange() {
    Account a = [
      SELECT ID, SLA__c
      FROM Account
      WHERE ID = '0015e00000Ele95AAB'
      LIMIT 1
    ];
    a.SLA__c = 'Gold';
    update a;
  }
}
